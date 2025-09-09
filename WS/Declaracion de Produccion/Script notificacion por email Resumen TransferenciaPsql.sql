

DECLARE @RowCount INT;

exec [CORPSQLMULT2019].[WS].dbo.[RV_PRC_SIP_NOTIFICACION_EMAIL_RESUMEN]

SELECT		
				@RowCount = COUNT(*)
FROM			[CORPSQLMULT2019].[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
WHERE			
				FechaInformado			<		DATEADD(MINUTE, -1, GETDATE())
AND				FechaNotificacion		IS NULL
AND				TipoNotificacion		=		'WARNING'

	------------------------------------------------
	--COMPRUEBO SI HAY NOTIFICACIONES PENDIENTES
	------------------------------------------------

    IF @RowCount >0
    BEGIN
		---------------------------------------------------
		--CREO BODDY DEL EMAIL
		---------------------------------------------------

        DECLARE @tableHTML  NVARCHAR(MAX) ;

		SET @tableHTML =
			N'<H1>Resumena de notificacion declaracion de produccion</H1>' +
			N'<table border="1">' +
			N'<tr><th>Notificacion</th><th>Detalle</th><th>Codigo de Notificacion</th><th>Servicio</th><th>Fecha Notificacion</th>' +
			CAST	( 
						( 
							SELECT		td = TipoNotificacion		, '',
										td = Detalle				, '',
										td = Codigo					, '',
										td = Proceso				, '',
										td = GETDATE()				, ''
										
							FROM		[CORPSQLMULT2019].[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
							WHERE			
										FechaInformado		>=		DATEADD(MINUTE, -1, GETDATE())
							AND			FechaNotificacion		IS NULL
							AND			TipoNotificacion		=		'WARNING'
								FOR		XML PATH('tr'), TYPE 
						) AS NVARCHAR(MAX) 
					) +
			N'</table>' ;

		---------------------------------------------------
		--ENVIO EMAIL CON EL DETALLE DE LAS NOTIFICACIONES
		---------------------------------------------------
		EXEC					msdb.dbo.sp_send_dbmail
								@profile_name		=	'Grupo Desarrollo RV',
								--@recipients			=	'wrosario@radiovictoria.com.ar',
								@recipients			=	'hzungri@radiovictoria.com.ar;egarro@radiovictoria.com.ar;svitullo@radiovictoria.com.ar',
								@copy_recipients	=	'wrosario@radiovictoria.com.ar;fmastronardi@radiovictoria.com.ar',
								@importance			=	'HIGH',  
								@subject			=	'Resumen delcaracion de Produccion',
								@body				=	@tableHTML,
								@body_format		=	'HTML';

		---------------------------------------------------
		--ESCRIBO FECHAR DE LAS NOTIFICACIONES
		---------------------------------------------------
		UPDATE		[CORPSQLMULT2019].[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
		SET			FechaNotificacion	= GETDATE()
		WHERE		FechaNotificacion		IS NULL
		AND			TipoNotificacion		=		'WARNING'		

    END