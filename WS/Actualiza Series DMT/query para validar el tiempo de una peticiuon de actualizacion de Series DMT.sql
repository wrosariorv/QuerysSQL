-- OPCIONAL: parámetro
DECLARE @GroupID INT = 100;

SELECT
    d.GroupID,
    d.SerialNumber,
    d.InicioReal,
    d.FechaActualizacion,
    d.DeltaSeg,
    CASE WHEN d.DeltaSeg < 60
         THEN CAST(d.DeltaSeg AS varchar(10)) + 's'
         ELSE CAST(d.DeltaSeg / 60 AS varchar(10)) + 'm ' + CAST(d.DeltaSeg % 60 AS varchar(10)) + 's'
    END AS DeltaFmt,
    SUM(d.DeltaSeg) OVER (
        PARTITION BY d.GroupID
        ORDER BY d.FechaActualizacion, d.SerialNumber
        ROWS UNBOUNDED PRECEDING
    ) AS AcumSeg,
    CASE WHEN SUM(d.DeltaSeg) OVER (
                PARTITION BY d.GroupID
                ORDER BY d.FechaActualizacion, d.SerialNumber
                ROWS UNBOUNDED PRECEDING
         ) < 60
         THEN CAST(SUM(d.DeltaSeg) OVER (
                    PARTITION BY d.GroupID
                    ORDER BY d.FechaActualizacion, d.SerialNumber
                    ROWS UNBOUNDED PRECEDING
              ) AS varchar(10)) + 's'
         ELSE CAST(SUM(d.DeltaSeg) OVER (
                    PARTITION BY d.GroupID
                    ORDER BY d.FechaActualizacion, d.SerialNumber
                    ROWS UNBOUNDED PRECEDING
              ) / 60 AS varchar(10))
              + 'm '
              + CAST(SUM(d.DeltaSeg) OVER (
                    PARTITION BY d.GroupID
                    ORDER BY d.FechaActualizacion, d.SerialNumber
                    ROWS UNBOUNDED PRECEDING
                ) % 60 AS varchar(10)) + 's'
    END AS AcumFmt
FROM (
    SELECT
        s.GroupID,
        s.SerialNumber,
        s.FechaActualizacion,
        s.InicioReal,
        -- ya NO hay funciones de ventana dentro de otra ventana
        DATEDIFF(SECOND, COALESCE(s.PrevFA, s.InicioReal), s.FechaActualizacion) AS DeltaSeg
    FROM (
        SELECT
            t.GroupID,
            t.SerialNumber,
            t.FechaActualizacion,
            MAX(t.Fecha) OVER (PARTITION BY t.GroupID) AS InicioReal,
            LAG(t.FechaActualizacion) OVER (
                PARTITION BY t.GroupID
                ORDER BY t.FechaActualizacion, t.SerialNumber
            ) AS PrevFA
        FROM WS.[AS].RV_TBL_SIP_ACTUALIZA_SERIE t
        WHERE t.GroupID = @GroupID
          AND t.Estado = 'Integrado'
          AND t.FechaActualizacion IS NOT NULL
    ) AS s
) AS d
ORDER BY d.GroupID, d.FechaActualizacion, d.SerialNumber;




SELECT
    r.GroupID,
    r.InicioReal,
    MAX(r.FechaActualizacion) AS FinProcesamiento,
    MAX(r.AcumSeg)            AS TiempoTotalSeg,
    CASE 
        WHEN MAX(r.AcumSeg) < 60
            THEN CAST(MAX(r.AcumSeg) AS varchar(10)) + 's'
        ELSE CAST(MAX(r.AcumSeg) / 60 AS varchar(10)) + 'm ' +
             CAST(MAX(r.AcumSeg) % 60 AS varchar(10)) + 's'
    END AS TiempoFormateado
FROM (
    SELECT
        d.GroupID,
        d.InicioReal,
        d.FechaActualizacion,
        -- acumulado solo usa SUM sobre el delta ya calculado (sin ventanas internas)
        SUM(d.DeltaSeg) OVER (
            PARTITION BY d.GroupID
            ORDER BY d.FechaActualizacion, d.SerialNumber
            ROWS UNBOUNDED PRECEDING
        ) AS AcumSeg
    FROM (
        SELECT
            s.GroupID,
            s.SerialNumber,
            s.FechaActualizacion,
            s.InicioReal,
            DATEDIFF(SECOND, COALESCE(s.PrevFA, s.InicioReal), s.FechaActualizacion) AS DeltaSeg
        FROM (
            SELECT
                t.GroupID,
                t.SerialNumber,
                t.FechaActualizacion,
                MAX(t.Fecha) OVER (PARTITION BY t.GroupID) AS InicioReal,
                LAG(t.FechaActualizacion) OVER (
                    PARTITION BY t.GroupID
                    ORDER BY t.FechaActualizacion, t.SerialNumber
                ) AS PrevFA
            FROM WS.[AS].RV_TBL_SIP_ACTUALIZA_SERIE t
            WHERE t.GroupID = @GroupID
              AND t.Estado = 'Integrado'
              AND t.FechaActualizacion IS NOT NULL
        ) AS s
    ) AS d
) AS r
GROUP BY r.GroupID, r.InicioReal;



--Old method
/*

SELECT
			t.GroupID,
			MIN(t.Fecha)																							AS InicioSolicitud,
			MAX(t.FechaActualizacion)																				AS FinProcesamiento,
			DATEDIFF(SECOND, MIN(t.Fecha), MAX(t.FechaActualizacion))												AS TiempoTotalSeg,
			CASE 
			    WHEN DATEDIFF(SECOND, MIN(t.Fecha), MAX(t.FechaActualizacion)) < 60 
			        THEN CAST(DATEDIFF(SECOND, MIN(t.Fecha), MAX(t.FechaActualizacion))	AS varchar(10)) + 's'
			    ELSE 
			        CAST(DATEDIFF(SECOND, MIN(t.Fecha), MAX(t.FechaActualizacion)) / 60	AS varchar(10)) + 'm ' +
			        CAST(DATEDIFF(SECOND, MIN(t.Fecha), MAX(t.FechaActualizacion)) % 60	AS varchar(10)) + 's'
			END																										AS TiempoFormateado
FROM		WS.[AS].RV_TBL_SIP_ACTUALIZA_SERIE t
WHERE		t.GroupID				=		99
  AND		t.Estado				=		'Integrado'
  AND		t.FechaActualizacion	IS NOT NULL

GROUP BY t.GroupID



SELECT
			GroupID,
			SerialNumber,
			Fecha,
			FechaActualizacion,
			Duracion_ms = DATEDIFF_BIG(millisecond, Fecha, FechaActualizacion)

FROM		WS.[AS].RV_TBL_SIP_ACTUALIZA_SERIE

WHERE		GroupID = 99
  AND		Estado = 'Integrado'
  AND		FechaActualizacion IS NOT NULL
--ORDER BY Duracion_ms DESC

ORDER BY Fecha, FechaActualizacion 

*/
