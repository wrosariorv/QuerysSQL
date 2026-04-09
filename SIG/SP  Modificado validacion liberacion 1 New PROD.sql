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
						@OrderNum		INT				=		285147,--283107,
						@OrderLine		INT				=		2,
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
 

   /* ===== Agregar a @PendientesCSV las líneas/liberaciones abiertas NO despachadas ===== */
    DECLARE @PendCSVDesp NVARCHAR(4000);

    DECLARE @Pend TABLE (Company nvarchar(5), OrderNum INT,OrderLine INT, OrderRelNum INT, estado nvarchar(50));

    INSERT INTO     @Pend (company, OrderNum, OrderLine, OrderRelNum, estado)

    SELECT
                        B2.Company,
                        B2.OrderNum,
                        B2.OrderLine,
                        B2.OrderRelNum,
                        CASE
                                    /* ===== Grupo AA dinámico (ancla SK => grupo ancla..ancla+2) ===== */
                                    WHEN        B2.AnchorLine       IS NOT NULL 
                                        AND     B2.OrderRelNum      =   1 
                                        THEN
                                                CASE
                                                    WHEN        
                                                            B2.PendPrinGrp      =   1 
                                                        AND 
                                                            B2.PendFueraGrp     >   0 
                                                    THEN                                    'STOP'
                                            
                                                    WHEN    B2.PendPrinGrp      =   1 
                                                        AND 
                                                            B2.PendFueraGrp     =   0 
                                                        AND B2.TotFueraGrp      >    0 
                                                    THEN                                    'PENDIENTE'
                                            
                                                    ELSE 
                                                        B2.EstadoDespacho
                                                END

                                    /* ===== Caso NO AA (por línea) ===== */
                                     WHEN       B2.AnchorLine       IS NULL 
                                        AND     B2.OrderRelNum      = 1 
                                        THEN
                                                CASE
                                                    WHEN 
                                                            B2.PendPrin_NoAA    =   1 
                                                        AND 
                                                            B2.PendFuera_NoAA   >   0 
                                                    THEN                                    'STOP'

                                                    WHEN    B2.PendPrin_NoAA    =   1 
                                                        AND 
                                                            B2.PendFuera_NoAA   =   0 
                                                        AND 
                                                            B2.TotFuera_NoAA    >   0 
                                                        THEN 'PENDIENTE'
                                                    ELSE B2.EstadoDespacho
                                                END

                                    /* Resto: estado real */
                                    ELSE        B2.EstadoDespacho
                        END                     AS EstadoLiberacion
FROM
                        (
                                /* ========= B2: usa AnchorLine (columna ya calculada) para las ventanas ========= */
                                SELECT
                                    B1.*,

                                    /* ---- Agregados por LÍNEA (NO AA) ---- */
                                    MAX(CASE WHEN B1.OrderRelNum = 1 AND B1.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)
                                        OVER (PARTITION BY B1.Company, B1.OrderNum, B1.OrderLine) AS PendPrin_NoAA,

                                    SUM(CASE WHEN B1.OrderRelNum <> 1 AND B1.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)
                                        OVER (PARTITION BY B1.Company, B1.OrderNum, B1.OrderLine) AS PendFuera_NoAA,

                                    SUM(CASE WHEN B1.OrderRelNum <> 1 THEN 1 ELSE 0 END)
                                        OVER (PARTITION BY B1.Company, B1.OrderNum, B1.OrderLine) AS TotFuera_NoAA,

                                    /* ---- Agregados por GRUPO AA (partición por AnchorLine ya calculada) ---- */
                                    MAX(CASE WHEN B1.OrderRelNum = 1 AND B1.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)
                                        OVER (PARTITION BY B1.Company, B1.OrderNum, B1.AnchorLine) AS PendPrinGrp,

                                    SUM(CASE WHEN B1.OrderRelNum <> 1 AND B1.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)
                                        OVER (PARTITION BY B1.Company, B1.OrderNum, B1.AnchorLine) AS PendFueraGrp,

                                    SUM(CASE WHEN B1.OrderRelNum <> 1 THEN 1 ELSE 0 END)
                                        OVER (PARTITION BY B1.Company, B1.OrderNum, B1.AnchorLine) AS TotFueraGrp
                                FROM
                                (
                                    /* ========= B1: calcula AnchorLine una sola vez (sin anidar ventanas) ========= */
                                    SELECT
                                        B0.*,
                                        /* Línea ANCLA = mayor AnchorLineSelf en la “ventana móvil” de 2 líneas previas */
                                        MAX(B0.AnchorLineSelf) OVER (
                                            PARTITION BY B0.Company, B0.OrderNum
                                            ORDER BY B0.OrderLine
                                            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
                                        ) AS AnchorLine
                                    FROM
                                    (
                                        /* ========= B0: JOINs + EstadoDespacho + AnchorLineSelf ========= */
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
							                        END	                                        AS EstadoDespacho,

                                            /* Marca de ANCLA propia si AA-SPLIT + SK% */
                                            CASE
                                                    WHEN 
                                                            ART.CodigoCategoria = 'AA-SPLIT' 
                                                        AND 
                                                            ART.ClassID LIKE 'SK%'
                                                    THEN    OD.OrderLine
                                                    ELSE    NULL
                                            END                                                         AS AnchorLineSelf
                                        FROM			[CORPE11-EPIDB].[EpicorErp].Erp.OrderHed								OH
			                            INNER JOIN		[CORPE11-EPIDB].[EpicorErp].Erp.OrderDtl								OD
				                            ON			OH.Company		=		OD.Company
				                            AND			OH.OrderNum		=		OD.OrderNum
			                            INNER JOIN		[CORPE11-EPIDB].[EpicorErp].Erp.OrderRel								REL
				                            ON			OD.Company		=		REL.Company
				                            AND			OD.OrderNum		=		REL.OrderNum
				                            AND			OD.OrderLine	=		REL.OrderLine
			                            LEFT JOIN		[CORPL11-SSRS].[RVF_Local].dbo.RVF_VW_MOVI_ARTICULOS			ART
				                            ON			OD.Company			=			ART.Compania
				                            AND			OD.PartNum			=			ART.CodigoArticulo
			                            LEFT JOIN		[CORPE11-EPIDB].[EpicorErp].Erp.ShipDtl									SD
				                            ON			REL.Company		=		SD.Company
				                            AND			REL.OrderNum	=		SD.OrderNum
				                            AND			REL.OrderLine	=		SD.OrderLine
				                            AND			REL.OrderRelNum	=		SD.OrderRelNum

			                            WHERE			
							                            OH.Company		=		@Company
				                        AND			    OH.OrderNum		=		@OrderNum
                                    ) AS B0
                                ) AS B1
                        ) AS B2
    ORDER BY B2.Company, B2.OrderNum, B2.OrderLine, B2.OrderRelNum;


   SELECT
			  @PendCSVDesp =
							CASE
							  WHEN EXISTS (
									            SELECT 1
									            FROM @Pend p
									            WHERE p.Company        =   @Company
									              AND p.OrderNum       =   @OrderNum
									              AND p.OrderLine      =   @OrderLine
									              AND p.OrderRelNum    =   @OrderRelNum
									              AND p.Estado         =   'STOP'
								           )
							  THEN (
									 SELECT STRING_AGG(CONCAT('L', CAST(p2.OrderLine AS NVARCHAR(10)),
															  '-R', CAST(p2.OrderRelNum AS NVARCHAR(10))), ', ')
									 FROM @Pend p2
									 WHERE p2.Company   =   @Company
									   AND p2.OrderNum  =   @OrderNum
                                       AND p2.OrderLine =    @OrderLine
									   AND p2.Estado    =   'PENDIENTE'
								   )
							  ELSE NULL
							END;

    
    SET @PendientesCSV = CONCAT_WS(', ', NULLIF(@PendientesCSV, N''), NULLIF(@PendCSVDesp, N''));


    IF (@PendientesCSV IS NOT NULL AND LEN(@PendientesCSV) > 0)
    BEGIN
        SET @Estado = N'ERROR';
        SET @Mensaje   = CONCAT('No se debe tomar la liberación 1. Existen otras liberaciones pendientes de tomar en OV ',@OrderNum,' : '
                       , @PendientesCSV);
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
GO


