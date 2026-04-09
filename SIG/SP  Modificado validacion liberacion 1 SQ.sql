DECLARE					@Company		NVARCHAR(8)		=		'CO01',
						@Plant			NVARCHAR(8)		=		'CDEE',
						@OrderNum		INT				=		283147,--283304 (con 1 linea y liberacion abierta),--283147(con varias linea abiertas),--283466,--283107(incial problema),
						@OrderLine		INT				=		1,
						@OrderRelNum	INT				=		4
--*/

 DECLARE @Estado      NVARCHAR(10)   = N'OK';
    DECLARE @Mensaje        NVARCHAR(4000) = N'';
    DECLARE @PendientesCSV  NVARCHAR(4000) = N'';

    DECLARE @OtrasRel TABLE (OrderRelNum INT PRIMARY KEY);
    DECLARE @OtrasNoTomadas TABLE (OrderRelNum INT PRIMARY KEY);

	/* ===== Agregar a @PendientesCSV las líneas/liberaciones abiertas NO despachadas ===== */
    DECLARE @PendCSVDesp NVARCHAR(4000);

SELECT
    W.Company,
    W.OrderNum,
    W.OrderLine,
    W.OrderRelNum,
    W.CodigoCategoria,
    W.ClassID,
    W.EstadoDespacho,

    /* ===== Flags por pedido (sin anidar OVER) ===== */
    MAX(CASE WHEN W.OrderLine = 1 AND W.OrderRelNum = 1
                 AND W.CodigoCategoria = 'AA-SPLIT'
                 AND W.ClassID LIKE 'SK%' THEN 1 ELSE 0 END)
        OVER (PARTITION BY W.Company, W.OrderNum) AS HasAA11,           -- L1/R1 es AA?

    MAX(CASE WHEN W.OrderLine = 1 AND W.OrderRelNum = 1
                 AND W.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)
        OVER (PARTITION BY W.Company, W.OrderNum) AS IsPend11,          -- L1/R1 pendiente?

    -- Pendientes fuera del GRUPO AA (OL 1..3, OR 1)
    SUM(CASE WHEN W.EstadoDespacho = 'PENDIENTE'
                 AND NOT (W.OrderRelNum = 1 AND W.OrderLine BETWEEN 1 AND 3)
             THEN 1 ELSE 0 END)
        OVER (PARTITION BY W.Company, W.OrderNum) AS PendFueraAA,

    -- Pendientes fuera de L1/R1 (cuando NO es AA)
    SUM(CASE WHEN W.EstadoDespacho = 'PENDIENTE'
                 AND NOT (W.OrderRelNum = 1 AND W.OrderLine = 1)
             THEN 1 ELSE 0 END)
        OVER (PARTITION BY W.Company, W.OrderNum) AS PendFueraNoAA,

    /* ===== Estado evaluado según las 4 reglas ===== */
    CASE
        -- Regla 2 + 4: si L1/R1 es AA, evalúo el grupo (OL 1..3, OR 1)
        WHEN
            MAX(CASE WHEN W.OrderLine = 1 AND W.OrderRelNum = 1
                        AND W.CodigoCategoria = 'AA-SPLIT'
                        AND W.ClassID LIKE 'SK%' THEN 1 ELSE 0 END)
                OVER (PARTITION BY W.Company, W.OrderNum) = 1         -- hay AA en L1/R1
            AND (W.OrderRelNum = 1 AND W.OrderLine BETWEEN 1 AND 3)   -- filas del grupo
            AND
            MAX(CASE WHEN W.OrderLine = 1 AND W.OrderRelNum = 1
                        AND W.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)
                OVER (PARTITION BY W.Company, W.OrderNum) = 1         -- L1/R1 pendiente
            AND
            SUM(CASE WHEN W.EstadoDespacho = 'PENDIENTE'
                        AND NOT (W.OrderRelNum = 1 AND W.OrderLine BETWEEN 1 AND 3)
                     THEN 1 ELSE 0 END)
                OVER (PARTITION BY W.Company, W.OrderNum) > 0         -- hay otros pendientes
        THEN 'STOP'

        -- Regla 2 (sin AA): si L1/R1 está pendiente y hay otros pendientes => STOP
        WHEN
            MAX(CASE WHEN W.OrderLine = 1 AND W.OrderRelNum = 1
                        AND W.EstadoDespacho = 'PENDIENTE' THEN 1 ELSE 0 END)
                OVER (PARTITION BY W.Company, W.OrderNum) = 1
            AND (W.OrderLine = 1 AND W.OrderRelNum = 1)
            AND
            SUM(CASE WHEN W.EstadoDespacho = 'PENDIENTE'
                        AND NOT (W.OrderRelNum = 1 AND W.OrderLine = 1)
                     THEN 1 ELSE 0 END)
                OVER (PARTITION BY W.Company, W.OrderNum) > 0
        THEN 'STOP'

        -- Regla 3: resto muestra su propio estado
        ELSE W.EstadoDespacho
    END AS EstadoEvaluado

FROM (
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
) AS W
ORDER BY W.Company, W.OrderNum, W.OrderLine, W.OrderRelNum;
