USE [WS]
GO

SELECT 
		*
FROM 
    
(
SELECT 
    Serie, 
    COUNT(*) AS Total_Repetidos
FROM 
    RV_TBL_SIP_ITEM_TP
GROUP BY 
    Serie
HAVING 
    COUNT(*) > 1
	) AS W

SELECT 
    *,
    COUNT(*) OVER(PARTITION BY Serie) AS Cantidad_Repetidos
FROM 
    RV_TBL_SIP_ITEM_TP
WHERE 
    Serie IN (
        SELECT 
            Serie 
        FROM 
            RV_TBL_SIP_ITEM_TP 
        GROUP BY 
            Serie 
        HAVING 
            COUNT(*) > 1
    )
ORDER BY 
    HoraFabricacion ASC;

	select * from [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
where SerialNumber ='RO2513310005547'

select * from [WS].DBO.RV_TBL_SIP_ITEM_TP
where Serie='RO2513310005552'
select * from [WS].DBO.RV_TBL_SIP_ITEM_TP
where TranNum=110971

select * from [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
where SerialNumber ='RF11033UI100051'

SELECT 
		*
FROM 
    
(
SELECT 
    SerialNumber, 
    COUNT(*) AS Total_Repetidos
FROM 
    [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
GROUP BY 
    SerialNumber
HAVING 
    COUNT(*) > 1
	) AS W

select * from (
SELECT
    x.Id,
    x.Company,
    x.OT,
    x.PartNum,
    x.SerialNumber,
    x.Estado,
    x.FechaAlta,
    x.Fecha,
    x.[Timestamp],
    CASE
        -- Todo registro ERROR se elimina
        WHEN x.Estado = 'ERROR'
            THEN 'Eliminar'

        -- Si el grupo no tiene ERROR, elimina el registro más antiguo
        WHEN x.TieneError = 0
             AND x.OrdenAntiguedad = 1
            THEN 'Eliminar'

        ELSE ''
    END AS Criterio
FROM
(
    SELECT
        t.Id,
        t.Company,
        t.OT,
        t.PartNum,
        t.SerialNumber,
        t.Estado,
        t.FechaAlta,
        t.Fecha,
        t.[Timestamp],

        COUNT(*) OVER
        (
            PARTITION BY
                t.Company,
                t.OT,
                t.PartNum,
                t.SerialNumber
        ) AS CantidadRepeticiones,

        MAX
        (
            CASE
                WHEN t.Estado = 'ERROR' THEN 1
                ELSE 0
            END
        ) OVER
        (
            PARTITION BY
                t.Company,
                t.OT,
                t.PartNum,
                t.SerialNumber
        ) AS TieneError,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                t.Company,
                t.OT,
                t.PartNum,
                t.SerialNumber
            ORDER BY
                t.FechaAlta ASC,
                t.Id ASC
        ) AS OrdenAntiguedad

    FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE] t
) x
WHERE x.CantidadRepeticiones > 1
) AS W
where W.Criterio='Eliminar'