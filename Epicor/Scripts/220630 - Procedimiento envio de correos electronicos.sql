
/*

CREATE PROCEDURE	RVF_PRC_SEND_MAIL_REMITOS_NO_FACTURADOS

AS

*/

-----------------------------------------------------------

DECLARE				@Pendientes SMALLINT

-----------------------------------------------------------

SELECT				@Pendientes			=		COUNT(*)
FROM				RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
WHERE				LegalNumber					<>					''

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
			N'<tr><th>Company</th><th>CustID</th><th>Name</th><th>Change Date</th><th>PackNum</th>' +
			N'<th>Legal Number</th><th>ShipStatus</th><th>Plant</th><th>Change Time</th></tr>' +
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
										td = ChangeTime 
						  FROM			RVF_Local.dbo.RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
						  WHERE			LegalNumber			<>		''
							FOR			XML PATH('tr'), TYPE 
						) AS NVARCHAR(MAX) 
						) +
			N'</table>' ;

				EXEC	msdb.dbo.sp_send_dbmail
						@profile_name	=	'Notificaciones Grupo Epicor',  
						@recipients		=	'epicor@radiovictoria.com',  
						@importance		=	'HIGH',  
						@subject		=	'Detalle de remitos no facturados',
						@body			=	@tableHTML,
						@body_format	=	'HTML';
		END

-----------------------------------------------------------
