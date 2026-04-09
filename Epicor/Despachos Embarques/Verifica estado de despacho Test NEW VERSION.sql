DECLARE @Company   NVARCHAR(8) = 'CO01',
        @OrderNum  INT         = 281789;

SELECT
    B2.Company,
    B2.OrderNum,
    B2.OrderLine,
    B2.PartNum,
    B2.OrderRelNum,
    B2.AnchorLine,
    /* ===== Estado unificado por grupo AC (SK, UI, UE) ===== */
    CASE
        WHEN B2.AnchorLine IS NOT NULL THEN
            CASE
                WHEN B2.GrpHasIntegracion = 1
                    THEN 'DESPACHADO INTEGRACION'
                WHEN B2.GrpHasDespPor = 1
                    THEN CONCAT('DESPACHADO POR ', B2.GrpShipPersonU)
                ELSE B2.EstadoDet
            END
        ELSE
            B2.EstadoDet
    END AS EstadoDespacho_Unificado
FROM
(
    /* ========= B2: agregados por GRUPO (AnchorLine) ========= */
    SELECT
        B1.*,

        /* ¿Hay integración en el grupo? */
        MAX(B1.IsIntegracion) OVER (
            PARTITION BY B1.Company, B1.OrderNum, B1.AnchorLine
        ) AS GrpHasIntegracion,

        /* ¿Hay "DESPACHADO POR ..." en el grupo? */
        MAX(B1.IsDespPor) OVER (
            PARTITION BY B1.Company, B1.OrderNum, B1.AnchorLine
        ) AS GrpHasDespPor,

        /* Representante de ShipPerson en mayúsculas para el grupo (si aplica) */
        MAX(CASE WHEN B1.IsDespPor = 1 THEN B1.ShipPersonU END) OVER (
            PARTITION BY B1.Company, B1.OrderNum, B1.AnchorLine
        ) AS GrpShipPersonU
    FROM
    (
        /* ========= B1: calcula AnchorLine una vez ========= */
        SELECT
            B0.*,
            MAX(B0.AnchorLineSelf) OVER (
                PARTITION BY B0.Company, B0.OrderNum
                ORDER BY B0.OrderLine
                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
            ) AS AnchorLine
        FROM
        (
            /* ========= B0: JOINs + EstadoDet + banderas ========= */
            SELECT
                OH.Company,
                OH.OrderNum,
                OD.OrderLine,
                OD.PartNum,
                --P.ClassID,
                REL.OrderRelNum,
                REL.OpenRelease,
                REL.Plant,
                SIG.Archivo,
                ART.CodigoCategoria,
                ART.ClassID,
                SD.ReadyToInvoice,
                SD.ShipCmpl,
                SH.ShipPerson,
                SH.EntryPerson,

                /* ------ Estado detallado fila a fila ------ */
                CASE

                    WHEN        P.ClassID in ('CEEC')
                            AND
                                (SD.ReadyToInvoice = 1 )
                    THEN        'CARGO DE ENVIO DESPACHADO'
                    WHEN     (SD.ReadyToInvoice = 1 AND SD.ShipCmpl = 1)
                         AND (REL.OpenRelease = 0)
                         AND (
                               SH.EntryPerson LIKE 'USR_%'
                            OR SH.ShipPerson  LIKE 'USR_%'
                             )
                         OR  (SIG.Archivo IS NOT NULL)
                    THEN 'DESPACHADO INTEGRACION'

                    WHEN     (SD.ReadyToInvoice = 1 AND SD.ShipCmpl = 1)
                         AND (REL.OpenRelease = 0)
                         AND (SH.EntryPerson NOT LIKE 'USR_%'
                              --/* si querés exigir que tampoco el ShipPerson sea USR_% quita este comentario:
                                 AND SH.ShipPerson NOT LIKE 'USR_%'
                              --*/
                             )
                         OR  (SIG.Archivo IS NULL)
                    THEN CONCAT('DESPACHADO POR ', UPPER(SH.ShipPerson))

                    WHEN (SD.ReadyToInvoice IS NULL OR SD.ShipCmpl IS NULL)
                         AND (REL.OpenRelease = 1)
                    THEN 'PENDIENTE DE DESPACHO'  -- (mantengo el literal que usas)

                    ELSE 'CERRADA'
                END AS EstadoDet,

                /* Mayúsculas para la variante "POR ..." */
                UPPER(SH.ShipPerson) AS ShipPersonU,

                /* Marca de ANCLA propia si AA-SPLIT + SK% */
                CASE
                    WHEN ART.CodigoCategoria = 'AA-SPLIT' AND ART.ClassID LIKE 'SK%'
                        THEN OD.OrderLine
                    ELSE NULL
                END AS AnchorLineSelf,

                /* Banderas para agregados de grupo */
                CASE
                    WHEN ( (SD.ReadyToInvoice = 1 AND SD.ShipCmpl = 1)
                           AND (REL.OpenRelease = 0)
                           AND (SH.EntryPerson LIKE 'USR_%' OR SH.ShipPerson LIKE 'USR_%')
                         )
                         OR (SIG.Archivo IS NOT NULL)
                    THEN 1 ELSE 0
                END AS IsIntegracion,

                CASE
                    WHEN ( (SD.ReadyToInvoice = 1 AND SD.ShipCmpl = 1)
                           AND (REL.OpenRelease = 0)
                           AND (SH.EntryPerson NOT LIKE 'USR_%')
                         )
                         OR (SIG.Archivo IS NULL)
                    THEN 1 ELSE 0
                END AS IsDespPor
            FROM   [CORPL11-EPIDB].[EpicorERPTest].Erp.OrderHed  AS OH
            INNER JOIN [CORPL11-EPIDB].[EpicorERPTest].Erp.OrderDtl AS OD
                ON OH.Company  = OD.Company
               AND OH.OrderNum = OD.OrderNum
            INNER JOIN [CORPL11-EPIDB].[EpicorERPTest].Erp.Part AS P 
                ON OD.Company   = P.Company
                AND OD.PartNum  = P.PartNum
            INNER JOIN [CORPL11-EPIDB].[EpicorERPTest].Erp.OrderRel AS REL
                ON OD.Company   = REL.Company
               AND OD.OrderNum  = REL.OrderNum
               AND OD.OrderLine = REL.OrderLine            
            LEFT JOIN  [SIG_TEST].dbo.[Ordenes] AS SIG
                ON  REL.Company     = SIG.Company  COLLATE Modern_Spanish_CI_AS
                AND REL.OrderNum    = SIG.OrderNum
                AND REL.OrderLine   = SIG.OrderLine
                AND REL.OrderRelNum = SIG.OrderRelNum
            LEFT JOIN  [CORPL11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS AS ART
                ON OD.Company = ART.Compania
               AND OD.PartNum = ART.CodigoArticulo
            LEFT JOIN  [CORPL11-EPIDB].[EpicorERPTest].Erp.ShipDtl AS SD
                ON  REL.Company     = SD.Company
                AND REL.OrderNum    = SD.OrderNum
                AND REL.OrderLine   = SD.OrderLine
                AND REL.OrderRelNum = SD.OrderRelNum
            INNER JOIN [CORPL11-EPIDB].[EpicorERPTest].Erp.ShipHead AS SH
                ON  SD.Company = SH.Company
                AND SD.PackNum = SH.PackNum
            WHERE  OH.Company = @Company
              AND  OH.OrderNum = @OrderNum
        ) AS B0
    ) AS B1
) AS B2
ORDER BY B2.Company, B2.OrderNum, B2.OrderLine, B2.OrderRelNum;
