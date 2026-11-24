USE [WS]
GO

/*

ALTER PROCEDURE	[dbo].[RV_PRC_SIP_NOTIFICACION_EMAIL]
AS

--*/


--/*
INSERT INTO	[WS].[dbo].[RV_TBL_SIP_NOTIFICACION_EMAIL]	(
														[Identificador],
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
													X.OT,
--													X.PartNum,
													'Declaracion de Produccion'			AS Proceso,
													X.Codigo,
													X.TAuditoria,
													X.Estado,
													X.Descripcion,
													X.DetalleUsuario,
													GETDATE()							AS FechaInfromado

FROM		(
				SELECT		Y.*
				FROM		(
								SELECT		A.ID,A.Company,A.TranNum,A.OT,A.PartNum,A.Codigo,A.TAuditoria,A.Descripcion,B.DetalleUsuario,A.Estado

								FROM		RV_TBL_SIP_LOG_TP							AS A

								INNER JOIN	RV_TBL_SIP_LOG_MENSAJE						AS B

								ON			SUBSTRING ( A.Codigo, 5, 5 )		=		B.Codigo
								WHERE		
											A.Estado							IN		('WARNING','ERROR')
								AND			A.Fecha								>=		DATEADD(HOUR, -48, GETDATE())
								AND			A.TranNum							<>		0
								AND			(
													A.Codigo like '%BT%'
												OR
													A.Codigo like '%PT%'
											)
							) AS Y
				LEFT JOIN	RV_TBL_SIP_LOG_TP							AS C
				ON			Y.ID		=		C.ID
				
				UNION ALL

				SELECT		0 AS ID ,Y.*
				FROM		(
								SELECT		A.Company,A.TranNum,A.OT,A.PartNum,A.Codigo,A.TAuditoria,A.Descripcion,B.DetalleUsuario,A.Estado

								FROM		RV_TBL_SIP_LOG_TP							AS A

								INNER JOIN	RV_TBL_SIP_LOG_MENSAJE						AS B

								ON			SUBSTRING ( A.Codigo, 5, 5 )		=		B.Codigo
								WHERE		
											A.Estado							IN		('WARNING','ERROR')
								AND			A.Fecha								>=		DATEADD(HOUR, -48, GETDATE())
								AND			A.TranNum							=		0
								AND			(
													A.Codigo like '%BT%'
												OR
													A.Codigo like '%PT%'
											)
								GROUP BY	A.Company,A.TranNum,A.OT,A.PartNum,A.Codigo,A.TAuditoria,A.Descripcion,B.DetalleUsuario,A.Estado
								
							) AS Y
			) AS X
WHERE		/*
			(
				X.OT			NOT IN	(
											SELECT		
															Identificador
											FROM			[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
											WHERE			
															FechaNotificacion		IS NOT NULL
											AND				Proceso						=		'Declaracion de Produccion'
											AND				FechaInformado				>=		DATEADD(HOUR, -48, GETDATE())
											AND				Identificador			is not null --se exluye los log con OT en NULL
										)
				OR 
				X.Codigo		NOT IN	(
											SELECT		
															Codigo
											FROM			[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
											WHERE			
															FechaNotificacion		IS NOT NULL
											AND				Proceso					=		'Declaracion de Produccion'
											AND				FechaInformado			>=		DATEADD(HOUR, -48, GETDATE())
										)
				
			)
			(
				-- Caso 1: el error tiene OT
					(
						X.OT IS NOT NULL
						AND X.OT NOT EXISTS
						(
							SELECT		
											Identificador
							FROM			[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
							WHERE			
											FechaNotificacion		IS NOT NULL
							AND				Proceso						=		'Declaracion de Produccion'
							AND				FechaInformado				>=		DATEADD(HOUR, -48, GETDATE())
							AND				Identificador			is not null --se exluye los log con OT en NULL
						)
					)

					OR

					-- Caso 2: el error NO tiene OT
					(
						X.OT IS NULL
						AND NOT EXISTS
						(
							SELECT		
											Codigo
							FROM			[WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL
							WHERE			
											FechaNotificacion		IS NOT NULL
							AND				Proceso					=		'Declaracion de Produccion'
							AND				FechaInformado			>=		DATEADD(HOUR, -48, GETDATE())
						)
					)
			
			)*/
			 -- TIENE OT:
    -- La combinación OT + Código no debe haber sido informada
    (
        X.OT IS NOT NULL
        AND NOT EXISTS
        (
            SELECT  1
            FROM    [WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL AS N
            WHERE   N.FechaNotificacion IS NOT NULL
            AND     N.Proceso = 'Declaracion de Produccion'
            AND     N.FechaInformado >= DATEADD(HOUR, -48, GETDATE())
            AND     N.Identificador = X.OT
            AND     N.Codigo = X.Codigo
        )
    )

    OR

    -- NO TIENE OT:
    -- El Código no debe haber sido informado
    (
        X.OT IS NULL
        AND NOT EXISTS
        (
            SELECT  1
            FROM    [WS].[dbo].RV_TBL_SIP_NOTIFICACION_EMAIL AS N
            WHERE   N.FechaNotificacion IS NOT NULL
            AND     N.Proceso = 'Declaracion de Produccion'
            AND     N.FechaInformado >= DATEADD(HOUR, -48, GETDATE())
            AND     N.Codigo = X.Codigo
        )
    )


AND			X.Codigo		not in	('COD:PT031','COD:PT023')


GO


