DECLARE @Company     NVARCHAR(8) = 'CO01',
        @Plant       NVARCHAR(8) = 'CDEE',
        @OrderNum    INT         = 281750,--281750,--281425, -- ejemplo
        @OrderLine   INT         = 1,
        @OrderRelNum INT         = 2;


-- ===================== W: dataset base =====================
SELECT * FROM (
SELECT
    W.Company,
    W.OrderNum,
    W.OrderLine,
    --W.PartNum,
    W.OrderRelNum,
    
        CASE
            /* ===== Grupo AA dinámico (ancla SK => grupo ancla..ancla+2) ===== */
            WHEN GAA.AnchorLine IS NOT NULL AND W.OrderRelNum = 1 THEN
                CASE
                    WHEN GAA.PendPrinGrp = 1 AND GAA.PendFueraGrp > 0 THEN 'STOP'
                    WHEN GAA.PendPrinGrp = 1 AND GAA.PendFueraGrp = 0 AND GAA.TotFueraGrp > 0 THEN 'PENDIENTE'
                    ELSE W.EstadoDespacho
                END

            /* ===== Caso NO AA (por línea) ===== */
            WHEN GAA.AnchorLine IS NULL AND W.OrderRelNum = 1 THEN
                CASE
                    WHEN SL.PendPrin_NoAA = 1 AND SL.PendFuera_NoAA > 0 THEN 'STOP'
                    WHEN SL.PendPrin_NoAA = 1 AND SL.PendFuera_NoAA = 0 AND SL.TotFuera_NoAA > 0 THEN 'PENDIENTE'
                    ELSE W.EstadoDespacho
                END

            /* Resto: estado real */
            ELSE W.EstadoDespacho
        END AS EstadoLiberacion
FROM
(
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
			FROM			[CORPL11-EPIDB].EpicorErpTest.Erp.OrderHed								OH
			INNER JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.OrderDtl								OD
				ON			OH.Company		=		OD.Company
				AND			OH.OrderNum		=		OD.OrderNum
			INNER JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.OrderRel								REL
				ON			OD.Company		=		REL.Company
				AND			OD.OrderNum		=		REL.OrderNum
				AND			OD.OrderLine	=		REL.OrderLine
			LEFT JOIN		[CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS			ART
				ON			OD.Company			=			ART.Compania
				AND			OD.PartNum			=			ART.CodigoArticulo
			LEFT JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.ShipDtl									SD
				ON			REL.Company		=		SD.Company
				AND			REL.OrderNum	=		SD.OrderNum
				AND			REL.OrderLine	=		SD.OrderLine
				AND			REL.OrderRelNum	=		SD.OrderRelNum

			WHERE			
							OH.Company		=		@Company
				AND			OH.OrderNum		=		@OrderNum
) AS W

/* ===================== GAA: agregados por GRUPO AA  ===================== */
LEFT JOIN
(
    /* Anclas AA (líneas con AA-SPLIT + SK%) */
    SELECT
        GA.Company,
        GA.OrderNum,
        GA.AnchorLine,
        -- ¿algún principal pendiente dentro del grupo?
        PendPrinGrp = MAX(CASE WHEN X.OrderRelNum = 1 AND X.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END),
        -- Pendientes fuera del principal dentro del grupo
        PendFueraGrp = SUM(CASE WHEN X.OrderRelNum <> 1 AND X.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END),
        -- Total fuera del principal (para la regla de PENDIENTE)
        TotFueraGrp  = SUM(CASE WHEN X.OrderRelNum <> 1 THEN 1 ELSE 0 END)
    FROM
    (
        SELECT  DISTINCT
                Company, OrderNum, OrderLine AS AnchorLine
        FROM
        (
            SELECT
                        OH.Company, OH.OrderNum, OD.OrderLine,
                        ART.CodigoCategoria, ART.ClassID
            FROM        [CORPL11-EPIDB].EpicorErpTest.Erp.OrderHed  AS OH
            INNER JOIN  [CORPL11-EPIDB].EpicorErpTest.Erp.OrderDtl AS OD
              ON        OH.Company      =       OD.Company 
              AND       OH.OrderNum     =       OD.OrderNum
            INNER JOIN  [CORPL11-EPIDB].EpicorErpTest.Erp.OrderRel AS REL
              ON        OD.Company      =       REL.Company 
              AND       OD.OrderNum     =       REL.OrderNum 
              AND       OD.OrderLine    =       REL.OrderLine
            LEFT JOIN   [CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS AS ART
              ON        OD.Company      =       ART.Compania 
              AND       OD.PartNum      =       ART.CodigoArticulo
            WHERE 
                        OH.Company      =       @Company
              AND       OH.OrderNum     =       @OrderNum
        ) AS A0
        WHERE           A0.CodigoCategoria      =       'AA-SPLIT' 
        AND             A0.ClassID              LIKE    'SK%'
    ) AS GA
    /* Expandimos cada grupo: AnchorLine .. AnchorLine+2 */
    INNER JOIN
    (
        SELECT
                        OH.Company, OH.OrderNum, OD.OrderLine, REL.OrderRelNum,
                        CASE
                            WHEN        (       SD.ReadyToInvoice = 1 
                                            AND 
                                                SD.ShipCmpl = 1
                                         ) 
                                        AND 
                                        REL.OpenRelease = 0 
                            THEN 'DESPACHADO'
                            WHEN        (
                                                SD.ReadyToInvoice IS NULL 
                                            OR 
                                                SD.ShipCmpl IS NULL
                                         ) 
                                         AND 
                                         REL.OpenRelease = 1 
                            THEN 'PENDIENTE'
                            ELSE 'CERRADA'
                        END AS EstadoDespacho
        FROM            [CORPL11-EPIDB].EpicorErpTest.Erp.OrderHed  AS OH
        INNER JOIN      [CORPL11-EPIDB].EpicorErpTest.Erp.OrderDtl AS OD
          ON            OH.Company      =       OD.Company 
          AND           OH.OrderNum     =       OD.OrderNum
        INNER JOIN      [CORPL11-EPIDB].EpicorErpTest.Erp.OrderRel AS REL
          ON            OD.Company      =       REL.Company 
          AND           OD.OrderNum     =       REL.OrderNum 
          AND           OD.OrderLine    =       REL.OrderLine
        LEFT JOIN       [CORPL11-EPIDB].EpicorErpTest.Erp.ShipDtl AS SD
          ON            REL.Company     =       SD.Company 
          AND           REL.OrderNum    =       SD.OrderNum 
          AND           REL.OrderLine   =       SD.OrderLine 
          AND           REL.OrderRelNum =       SD.OrderRelNum
        WHERE           OH.Company      =       @Company
          AND           OH.OrderNum     =       @OrderNum
    ) AS X
      ON X.Company          =       GA.Company
     AND X.OrderNum         =       GA.OrderNum
     AND X.OrderLine        BETWEEN GA.AnchorLine 
     AND GA.AnchorLine + 2
    GROUP BY GA.Company, GA.OrderNum, GA.AnchorLine
) AS GAA
  ON    GAA.Company     =       W.Company
 AND    GAA.OrderNum    =       W.OrderNum
 AND W.OrderLine        BETWEEN GAA.AnchorLine
 AND GAA.AnchorLine + 2

/* ===================== SL: agregados por LÍNEA (NO AA) ===================== */
LEFT JOIN
(
    SELECT
                    Company,
                    OrderNum,
                    OrderLine,
                    MAX(CASE WHEN OrderRelNum = 1 AND EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)   AS PendPrin_NoAA,
                    SUM(CASE WHEN OrderRelNum <> 1 AND EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)  AS PendFuera_NoAA,
                    SUM(CASE WHEN OrderRelNum <> 1 THEN 1 ELSE 0 END)                                   AS TotFuera_NoAA 
    FROM
    (
        SELECT
                        OH.Company, OH.OrderNum, OD.OrderLine, REL.OrderRelNum,
                        CASE
                            WHEN        (       SD.ReadyToInvoice = 1 
                                            AND 
                                                SD.ShipCmpl = 1
                                         ) 
                                        AND 
                                        REL.OpenRelease = 0 
                            THEN 'DESPACHADO'
                            WHEN        (
                                                SD.ReadyToInvoice IS NULL 
                                            OR 
                                                SD.ShipCmpl IS NULL
                                         ) 
                                         AND 
                                         REL.OpenRelease = 1 
                            THEN 'PENDIENTE'
                            ELSE 'CERRADA'
                        END AS EstadoDespacho
        FROM            [CORPL11-EPIDB].EpicorErpTest.Erp.OrderHed  AS OH
        INNER JOIN      [CORPL11-EPIDB].EpicorErpTest.Erp.OrderDtl AS OD
          ON            OH.Company      =       OD.Company 
          AND           OH.OrderNum     =       OD.OrderNum
        INNER JOIN      [CORPL11-EPIDB].EpicorErpTest.Erp.OrderRel AS REL
          ON            OD.Company      =       REL.Company 
          AND           OD.OrderNum     =       REL.OrderNum 
          AND           OD.OrderLine    =       REL.OrderLine
        LEFT JOIN       [CORPL11-EPIDB].EpicorErpTest.Erp.ShipDtl AS SD
          ON            REL.Company     =       SD.Company 
          AND           REL.OrderNum    =       SD.OrderNum 
          AND           REL.OrderLine   =       SD.OrderLine 
          AND           REL.OrderRelNum =       SD.OrderRelNum
        WHERE           OH.Company      =       @Company
          AND           OH.OrderNum     =       @OrderNum
    ) AS Y
    GROUP BY Company, OrderNum, OrderLine
) AS SL
  ON SL.Company  = W.Company
 AND SL.OrderNum = W.OrderNum
 AND SL.OrderLine= W.OrderLine

 ) AS FIN
ORDER BY /*W.Company, W.OrderNum, W.OrderLine, W.OrderRelNum*/ FIN.EstadoLiberacion desc;
