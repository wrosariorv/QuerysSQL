SELECT		*
FROM		[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
WHERE 
			Proceso = 'Declaracion de Produccion'
AND			TipoNotificacion in ('ERROR','WARNING')
AND			FechaInformado	> '2026-09-07 08:05:36.850'
order by	FechaInformado desc