
--/*

ALTER PROCEDURE	[dbo].[RV_PRC_SIP_NOTIFICACION_EMAIL]
AS

--*/


--/*
INSERT INTO	[WS].[dbo].[RV_TBL_SIP_NOTIFICACION_EMAIL]	(
														[Proceso],
														[Codigo],
														[TAuditoria],
														[TipoNotificacion],
														[Detalle],
														[DetalleUsuario],
														[FechaInformado]
													)
--*/

SELECT												
--													X.Company,
--													X.TranNum,
--													X.OT,
--													X.PartNum,
													X.Proceso		AS Proceso,
													X.Codigo,
													X.TAuditoria,
													X.Estado,
													X.Descripcion,
													X.DetalleUsuario,
													GETDATE()							AS FechaInfromado

FROM		(
				SELECT		Y.*
				FROM		(
								SELECT		A.ID,A.Company,A.TranNum,A.OT,A.PartNum,A.Codigo,A.TAuditoria,A.Descripcion,B.DetalleUsuario,A.Proceso,A.Estado

								FROM		RV_TBL_SIP_LOG_TP							AS A

								INNER JOIN	RV_TBL_SIP_LOG_MENSAJE						AS B

								ON			SUBSTRING ( A.Codigo, 5, 5 )		=		B.Codigo
								WHERE		
											A.Estado							IN		('WARNING','ERROR')
								AND			A.Fecha								>=		DATEADD(HOUR, -12, GETDATE())
								AND			A.TranNum							<>		0
								
							) AS Y
				LEFT JOIN	RV_TBL_SIP_LOG_TP							AS C
				ON			Y.ID		=		C.ID
				
				UNION ALL

				SELECT		0 AS ID ,Y.*
				FROM		(
								SELECT		A.Company,A.TranNum,A.OT,A.PartNum,A.Codigo,A.TAuditoria,A.Descripcion,B.DetalleUsuario,A.Proceso,A.Estado

								FROM		RV_TBL_SIP_LOG_TP							AS A

								INNER JOIN	RV_TBL_SIP_LOG_MENSAJE						AS B

								ON			SUBSTRING ( A.Codigo, 5, 5 )		=		B.Codigo
								WHERE		
											A.Estado							IN		('WARNING','ERROR')
								AND			A.Fecha								>=		DATEADD(HOUR, -12, GETDATE())
								AND			A.TranNum							=		0
								GROUP BY	A.Company,A.TranNum,A.OT,A.PartNum,A.Codigo,A.TAuditoria,A.Descripcion,B.DetalleUsuario,A.Proceso,A.Estado
								
							) AS Y
			) AS X
WHERE		X.Estado ='WARNING'
ORDER BY 1

