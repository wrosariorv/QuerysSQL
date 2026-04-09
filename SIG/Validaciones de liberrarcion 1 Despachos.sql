SELECT				top 20
					ORE.Company, ORE.OrderNum, ORE.OrderLine, ORE.OrderRelNum, ORE.OurReqQty, ORE.OurStockShippedQty, ORE.OpenRelease , ORE.Plant
FROM				[CORPE11-EPIDB].EpicorErp.Erp.OrderRel					Ore			--COLLATE 'SQL_Latin1_General_CP1_CI_AS' 'Modern_Spanish_CI_AS'
INNER JOIN			[SIG-CD].[dbo].[Ordenes]								O 
	ON				o.Company     = ORE.Company		COLLATE SQL_Latin1_General_CP1_CI_AS 
    AND				o.Plant       = ORE.Plant		COLLATE SQL_Latin1_General_CP1_CI_AS 
    AND				o.OrderNum    = ORE.OrderNum	--COLLATE SQL_Latin1_General_CP1_CI_AS 

WHERE				
					--OrderNum='283107'
					ore.OrderLine	=1
		AND			ore.OrderRelNum	=1
		AND			ore.OpenRelease = 1

ORDER BY			OrderNum DESC 

SELECT		W.Company,W.OrderNum, W.OrderLine
			,W.OrderRelNum
			CASE	
					W.

			END	AS Estado
FROM		(
				SELECT			
								
								OH.Company,OH.OrderNum, OD.OrderLine, OD.PartNum
								,REL.OrderRelNum, REL.OpenRelease, REL.Plant
								
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

										ELSE 'CERRADA'
								END	AS EstadoDespacho
								--* 
				FROM			Erp.OrderHed								OH
				INNER JOIN		Erp.OrderDtl								OD
					ON			OH.Company		=		OD.Company
					AND			OH.OrderNum		=		OD.OrderNum
				INNER JOIN		Erp.OrderRel								REL
					ON			OD.Company		=		REL.Company
					AND			OD.OrderNum		=		REL.OrderNum
					AND			OD.OrderLine	=		REL.OrderLine
				LEFT JOIN		Erp.ShipDtl									SD
					ON			REL.Company		=		SD.Company
					AND			REL.OrderNum	=		SD.OrderNum
					AND			REL.OrderLine	=		SD.OrderLine
					AND			REL.OrderRelNum	=		SD.OrderRelNum

				WHERE			
								OH.OrderNum='283107'


			) AS W
	

	

	SELECT			* 
	FROM			Erp.OrderDtl
	where			
					OrderNum='283107'

	SELECT			* 
	FROM			Erp.ShipHead
	where			
					OrderNum='283107'

	SELECT			ShipCmpl,ReadyToInvoice,* 
	FROM			Erp.ShipDtl
	where			
					Company='CO01'
	AND				OrderNum='283107'
	AND				OrderLine='3'
	AND				OrderRel='1'
	


	DECLARE					@Company		NVARCHAR(8)		=		'CO01',
						@Plant			NVARCHAR(8)		=		'CDEE',
						@OrderNum		INT				=		283147,--283466,--283107,
						@OrderLine		INT				=		4,
						@OrderRelNum	INT				=		1
--*/

 DECLARE @Estado      NVARCHAR(10)   = N'OK';
    DECLARE @Mensaje        NVARCHAR(4000) = N'';
    DECLARE @PendientesCSV  NVARCHAR(4000) = N'';

    DECLARE @OtrasRel TABLE (OrderRelNum INT PRIMARY KEY);
    DECLARE @OtrasNoTomadas TABLE (OrderRelNum INT PRIMARY KEY);

	/* ===== Agregar a @PendientesCSV las líneas/liberaciones abiertas NO despachadas ===== */
    DECLARE @PendCSVDesp NVARCHAR(4000);

    --DECLARE @Pend TABLE (OrderLine INT, OrderRelNum INT);

    SELECT          
                    --DISTINCT
                    REL.OrderLine,
                    REL.OrderRelNum,
					SD.ReadyToInvoice,
					SD.ShipCmpl

    FROM            [CORPE11-EPIDB].EpicorErp.Erp.OrderRel AS REL WITH (NOLOCK)

    LEFT JOIN       [CORPE11-EPIDB].EpicorErp.Erp.ShipDtl AS SD WITH (NOLOCK)
        ON          SD.Company          =       REL.Company
        AND         SD.OrderNum         =       REL.OrderNum
        AND         SD.OrderLine        =       REL.OrderLine
        AND         SD.OrderRelNum      =       REL.OrderRelNum
    WHERE 
                    REL.Company                     =       @Company
        AND         REL.Plant                       =       @Plant
        AND         REL.OrderNum                    =       @OrderNum
        AND         NOT (
                                REL.OrderLine       =       @OrderLine 
                            AND 
                                REL.OrderRelNum     =       @OrderRelNum
                        )                                                           -- excluir la actual
        AND         ISNULL(REL.OpenRelease, 0)      =       1                       -- solo liberaciones abiertas

    GROUP BY        REL.OrderLine, REL.OrderRelNum, SD.ReadyToInvoice,	SD.ShipCmpl
    HAVING MIN(CASE WHEN SD.ReadyToInvoice = 1 AND SD.ShipCmpl = 1 THEN 1 ELSE 0 END) = 0;

SELECT @PendCSVDesp =
    STRING_AGG(CONCAT('L', CAST(OrderLine AS NVARCHAR(10)), '-R', CAST(OrderRelNum AS NVARCHAR(10))), ', ')
FROM @Pend;

/* Unificar ambas listas de pendientes en la MISMA variable usada por el SP */
SET @PendientesCSV = CONCAT_WS(', ', NULLIF(@PendientesCSV, N''), NULLIF(@PendCSVDesp, N''));

SELECT @PendientesCSV

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

--INSERT INTO     @Pend (company, OrderNum, OrderLine, OrderRelNum, estado)
SELECT
				W.Company, W.OrderNum, W.OrderLine, W.PArtNum, W.OrderRelNum,
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



ORDER BY W.Company, W.OrderNum, W.OrderRelNum, W.OrderLine;


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
-- Opcional: ver resultado
SELECT @PendCSVDesp AS PendCSVDesp;

