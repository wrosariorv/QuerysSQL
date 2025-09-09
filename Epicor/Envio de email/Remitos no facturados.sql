USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_SEND_MAIL_REMITOS_NO_FACTURADOS]    Script Date: 25/11/2022 08:27:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 /*

ALTER PROCEDURE	[dbo].[RVF_PRC_SEND_MAIL_REMITOS_NO_FACTURADOS]


AS

 */

-----------------------------------------------------------

DECLARE				@Pendientes SMALLINT

-----------------------------------------------------------

SELECT				@Pendientes			=		COUNT(*)
FROM				RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
WHERE				LegalNumber					<>					''
	AND				(
					DaysCompl					>		0
					OR
						(
						Plant					IN		('CDEE', 'MPlace')
						AND
						DaysCompl				=		0
						AND
						MinCompl				>		30
						)
					)

-----------------------------------------------------------

IF					@Pendientes					=					0
		BEGIN
				PRINT				'No hay remitos pendientes de facturar'
		END

ELSE

		BEGIN

		/*****************************************************************************************************************

				SELECT				Company, CustID, Name, ChangeDate, PackNum, LegalNumber, ShipStatus, Plant, ChangeTime
				FROM				RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
				WHERE				LegalNumber					<>					''

		*****************************************************************************************************************/

		DECLARE @tableHTML  NVARCHAR(MAX) ;

		SET @tableHTML =
			N'<H1>Remitos no facturados</H1>' +
			N'<table border="1">' +
			N'<tr><th>Empresa</th><th>Cod Cliente</th><th>Nombre Cliente</th><th>Fecha</th><th>Embarque</th>' +
			N'<th>Numero Remito</th><th>Estado</th><th>Planta</th><th>Hora</th><th>Emb Completo</th></tr>' +
			CAST	( 
						( 
							SELECT		td = Company     , '',
										td = CustID      , '',
										td = Name        , '',
										td = ChangeDate  , '',
										td = PackNum     , '',
										td = LegalNumber , '', 
										td = ShipStatus  , '', 
										td = Plant       , '', 
										td = ChangeTime  , '', 
										td = ShipCompl
							FROM		RVF_Local.dbo.RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
							WHERE		LegalNumber			<>		''
								AND		(
										DaysCompl			>		0
										OR
											(
											Plant					IN		('CDEE', 'MPlace')
											AND
											DaysCompl		=		0
											AND
											MinCompl		>		30
											)
										)
								FOR		XML PATH('tr'), TYPE 
						) AS NVARCHAR(MAX) 
					) +
			N'</table>' ;

				--EXEC	msdb.dbo.sp_send_dbmail
				--		@profile_name	=	'Notificaciones Grupo Epicor',  
				--		@recipients		=	'epicor@radiovictoria.com.ar',  
				--		@importance		=	'HIGH',  
				--		@subject		=	'URGENTE - Detalle de remitos no facturados',
				--		@body			=	@tableHTML,
				--		@body_format	=	'HTML';


				
SELECT				*
FROM				RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
WHERE				LegalNumber					<>					''
	AND				(
					DaysCompl					>		0
					OR
						(
						Plant					IN		('CDEE', 'MPlace')
						AND
						DaysCompl				=		0
						AND
						MinCompl				>		30
						)
					)
		END

-----------------------------------------------------------


GO


select * from [CORPEPIDB].EpicorErp.erp.Shiphead
where packnum in (
'244782',
'244783',
'244786',
'244788',
'244789',
'244791',
'244793',
'244795',
'244797',
'244800'
)