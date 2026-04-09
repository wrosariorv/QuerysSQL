USE [SIG-CD]
GO

/*
ALTER PROCEDURE [dbo].[PRC_VERIFICAR_DESPACHOS_PENDIENTES_INICIAL]
      @Company      NVARCHAR(8)
    , @Plant        NVARCHAR(8)
    , @OrderNum     INT
    , @OrderLine    INT
    , @OrderRelNum  INT   -- liberación que se desea tomar ahora
AS
--*/
--/*
DECLARE					@Company		NVARCHAR(8)		=		'CO01',
						@Plant			NVARCHAR(8)		=		'CDEE',
						@OrderNum		INT				=		283304,--283304 (con 1 linea y liberacion abierta),--283147(con varias linea abiertas),--283466,--283107(incial problema),
						@OrderLine		INT				=		1,
						@OrderRelNum	INT				=		1
--*/
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @Estado      NVARCHAR(10)   = N'OK';
    DECLARE @Mensaje        NVARCHAR(4000) = N'';
    DECLARE @PendientesCSV  NVARCHAR(4000) = N'';
 
    /* Caso simple: si NO es liberación 1, no hay validación adicional */
    IF (@OrderRelNum <> 1)
    BEGIN
        SET @Mensaje = N'Liberación distinta de 1; validación no requerida.';
        SELECT
              Estado		= @Estado
            , Mensaje       = @Mensaje
            , Company       = @Company
            , Plant         = @Plant
            , OrderNum      = @OrderNum
            , OrderLine     = @OrderLine
            , OrderRelNum   = @OrderRelNum
            , PendientesCSV = @PendientesCSV;
        RETURN;
    END;
 
    /* ========= Reemplazo de CTE por TABLAS VARIABLES ========= */
 
    DECLARE @OtrasRel TABLE (OrderRelNum INT PRIMARY KEY);
    DECLARE @OtrasNoTomadas TABLE (OrderRelNum INT PRIMARY KEY);
 
    /* Otras liberaciones (<>1) de ESTA misma línea */
    INSERT INTO @OtrasRel (OrderRelNum)
    SELECT DISTINCT Ore.OrderRelNum
    FROM [CORPE11-EPIDB].EpicorErp.Erp.OrderRel AS Ore WITH (NOLOCK)
    WHERE Ore.Company   = @Company
      AND Ore.Plant     = @Plant
      AND Ore.OrderNum  = @OrderNum
      AND Ore.OrderLine = @OrderLine
      AND Ore.OrderRelNum <> 1
      -- Si querés considerar solo liberaciones abiertas:
      -- AND ISNULL(Ore.OpenRelease, 0) = 1
    ;
 
    /* De esas otras liberaciones, marcar las que NO están tomadas en [Ordenes] */
    INSERT INTO @OtrasNoTomadas (OrderRelNum)
    SELECT r.OrderRelNum
    FROM @OtrasRel AS r
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[Ordenes] AS o WITH (NOLOCK)
        WHERE o.Company     = @Company
          AND o.Plant       = @Plant
          AND o.OrderNum    = @OrderNum
          -- Si tu criterio de “tomada” requiere finalización, activá esta línea:
          -- AND o.FechaFin IS NOT NULL
    );
 
    /* Armar el CSV con las pendientes */
    SELECT @PendientesCSV =
        STRING_AGG(CAST(OrderRelNum AS NVARCHAR(20)), N', ')
    FROM @OtrasNoTomadas;


    /* ===== Agregar a @PendientesCSV las líneas/liberaciones abiertas NO despachadas ===== */
    DECLARE @PendCSVDesp NVARCHAR(4000);

    DECLARE @Pend TABLE (Company nvarchar(5), OrderNum INT,OrderLine INT, OrderRelNum INT, estado nvarchar(50));

    

    ;WITH W AS (
    SELECT			
								
							OH.Company,OH.OrderNum, OD.OrderLine, OD.PartNum
							,REL.OrderRelNum, REL.OpenRelease, REL.Plant
							,ART.CodigoCategoria, ART.ClassID
							,SD.ReadyToInvoice, SD.ShipCmpl
							,CASE
									WHEN	(
													SD.ReadyToInvoice = 1
												AND
													SD.ShipCmpl = 1
											)
											AND
											(
													REL.OpenRelease=0
											)
									THEN	'DESPACHADO'
									WHEN	(
													SD.ReadyToInvoice is null
												OR
													SD.ShipCmpl is null
											
											)
											AND
											(
													REL.OpenRelease=1
											)
							
									THEN	'PENDIENTE'

									ELSE	'CERRADA'
							END	AS EstadoDespacho
							--* 
			FROM			[CORPE11-EPIDB].EpicorErp.Erp.OrderHed								OH
			INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.OrderDtl								OD
				ON			OH.Company		=		OD.Company
				AND			OH.OrderNum		=		OD.OrderNum
			INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.OrderRel								REL
				ON			OD.Company		=		REL.Company
				AND			OD.OrderNum		=		REL.OrderNum
				AND			OD.OrderLine	=		REL.OrderLine
			LEFT JOIN		[CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS			ART
				ON			OD.Company			=			ART.Compania
				AND			OD.PartNum			=			ART.CodigoArticulo
			LEFT JOIN		[CORPE11-EPIDB].EpicorErp.Erp.ShipDtl									SD
				ON			REL.Company		=		SD.Company
				AND			REL.OrderNum	=		SD.OrderNum
				AND			REL.OrderLine	=		SD.OrderLine
				AND			REL.OrderRelNum	=		SD.OrderRelNum

			WHERE			
							OH.Company		=		@Company
				AND			OH.OrderNum		=		@OrderNum
),
Agg AS (
    SELECT
        Company, OrderNum,
        HasAA11   = MAX(CASE WHEN OrderLine=1 AND OrderRelNum=1
                               AND CodigoCategoria='AA-SPLIT' AND ClassID LIKE 'SK%' THEN 1 ELSE 0 END),
        IsPend11  = MAX(CASE WHEN OrderLine=1 AND OrderRelNum=1 AND EstadoDespacho='PENDIENTE' THEN 1 ELSE 0 END),
        PendOutAA = SUM(CASE WHEN EstadoDespacho='PENDIENTE'
                               AND NOT (OrderRelNum=1 AND OrderLine BETWEEN 1 AND 3) THEN 1 ELSE 0 END),
        PendOutNo = SUM(CASE WHEN EstadoDespacho='PENDIENTE'
                               AND NOT (OrderRelNum=1 AND OrderLine=1) THEN 1 ELSE 0 END)
    FROM W
    GROUP BY Company, OrderNum
)

INSERT INTO     @Pend (company, OrderNum, OrderLine, OrderRelNum, estado)
SELECT
				W.Company, W.OrderNum, W.OrderLine, W.OrderRelNum,
				--W.CodigoCategoria, W.ClassID, W.EstadoDespacho,
				CASE
					WHEN	
								X.Clave=1 
							AND 
								A.IsPend11=1
					THEN 
							CASE 
								WHEN 
										X.PendFuera>0 
								THEN	'STOP' 
								ELSE	'PENDIENTE' 
							END					-- 2/4/5
					ELSE	W.EstadoDespacho    -- 3
				END AS EstadoEvaluado
FROM W
JOIN Agg A 
	ON			A.Company		=		W.Company 
	AND			A.OrderNum		=		W.OrderNum
CROSS APPLY (
    SELECT
        Clave =
					CASE
						WHEN A.HasAA11=1 AND W.OrderRelNum=1 AND W.OrderLine BETWEEN 1 AND 3 THEN 1
						WHEN A.HasAA11=0 AND W.OrderRelNum=1 AND W.OrderLine=1 THEN 1
						ELSE 0
					END,
        PendFuera = CASE WHEN A.HasAA11=1 THEN A.PendOutAA ELSE A.PendOutNo END
--WHERE
--				W.Company		=		@Company
--	AND			W.OrderNum		=		@OrderNum
--	AND			W.OrderLine		=		@OrderLine
--	AND			W.OrderRelNum	=		@OrderRelNum
	
) X

   SELECT
			  @PendCSVDesp =
							CASE
							  WHEN EXISTS (
									 SELECT 1
									 FROM @Pend p
									 WHERE p.Company = @Company
									   AND p.OrderNum = @OrderNum
									   AND p.OrderLine = @OrderLine
									   AND p.OrderRelNum = @OrderRelNum
									   AND p.Estado = 'STOP'
								   )
							  THEN (
									 SELECT STRING_AGG(CONCAT('L', CAST(p2.OrderLine AS NVARCHAR(10)),
															  '-R', CAST(p2.OrderRelNum AS NVARCHAR(10))), ', ')
									 FROM @Pend p2
									 WHERE p2.Company = @Company
									   AND p2.OrderNum = @OrderNum
									   AND p2.Estado = 'PENDIENTE'
								   )
							  ELSE NULL
							END;

    
    SET @PendientesCSV = CONCAT_WS(', ', NULLIF(@PendientesCSV, N''), NULLIF(@PendCSVDesp, N''));



 
    IF (@PendientesCSV IS NOT NULL AND LEN(@PendientesCSV) > 0)
    BEGIN
        SET @Estado = N'ERROR';
        SET @Mensaje   = N'No se debe tomar la liberación 1. Existen otras liberaciones pendientes de tomar en [Ordenes]: '
                       + @PendientesCSV;
    END
    ELSE
    BEGIN
        SET @Mensaje = N'Se permite tomar la liberación 1 (no hay otras pendientes o todas ya fueron tomadas).';
    END;
 
    /* Respuesta única por SELECT */
    SELECT
          Estado		= @Estado
        , Mensaje       = @Mensaje
        , Company       = @Company
        , Plant         = @Plant
        , OrderNum      = @OrderNum
        , OrderLine     = @OrderLine
        , OrderRelNum   = @OrderRelNum
        , PendientesCSV = ISNULL(@PendientesCSV, N'');
END