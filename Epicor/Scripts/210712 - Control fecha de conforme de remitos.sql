


CREATE PROCEDURE	RVF_PRC_CONTROL_FECHA_CONFORME_REMITOS
					@Company			VARCHAR(15)	=			'CO01', 
					@FechaCorte			DATE, 
					@Plant				VARCHAR(15), 
					@Error				VARCHAR(15)

AS


SET DATEFORMAT DMY

----------------------------------------------------------
/*

DECLARE				@Company			VARCHAR(15)	=			'CO01', 
					@FechaCorte			DATE		=			'30/06/2021', 
					@Plant				VARCHAR(15)	=			'CDEE', 
					@Error				VARCHAR(15)	=			'Todos' 

*/
----------------------------------------------------------

DECLARE				@FechaDesde			DATE		=			'01/05/2021',		-- Este parametro qued fijo
					@ErrorIni			VARCHAR(15), 
					@ErrorFin			VARCHAR(15) 

----------------------------------------------------------

IF		@Error		=	'Todos'	
		BEGIN		
				SELECT		@ErrorIni		=		'', 
							@ErrorFin		=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@ErrorIni		=		@Error, 
							@ErrorFin		=		@Error	
		END 

----------------------------------------------------------

SELECT				A.*
FROM				(
					SELECT				SH.Company, SH.PackNum, SH.ShipDate, SH.ShipPerson, SH.Invoiced, SH.Plant, SH.ShipStatus, 
										SH.LegalNumber														AS	NumLegal_Remito, 
										SHU.RV_FechaConforme_c, 
					--					SD.OrderNum, SD.OrderLine, SD.OrderRelNum, 
										C.CustID, C.[Name], 
										ID.InvoiceNum, 
										IH.LegalNumber														AS	NumLegal_Factura, 
										IH.InvoiceDate, 
										CASE 
												WHEN 
												SHU.RV_FechaConforme_c			>				@FechaCorte
												OR
												SHU.RV_FechaConforme_c			IS NULL			THEN		'Si'
												ELSE														'No'
										END																	AS	Error

					FROM				[CORPEPIDB].EpicorErp.Erp.ShipHead					SH				WITH(NoLock)
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.ShipHead_UD				SHU				WITH(NoLock)
						ON				SH.SysRowID					=				SHU.ForeignSysRowID

					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer					C				WITH(NoLock)
						ON				SH.Company					=				C.Company
						AND				SH.CustNum					=				C.CustNum

					INNER JOIN			(
										SELECT				Company, PackNum, OrderNum, OrderLine, OrderRelNum
										FROM				[CORPEPIDB].EpicorErp.Erp.ShipDtl									WITH(NoLock)
										)		SD
						ON				SH.Company					=				SD.Company
						AND				SH.PackNum					=				SD.PackNum 

					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcDtl					ID				WITH(NoLock)
						ON				SD.Company					=				ID.Company
						AND				SD.OrderNum					=				ID.OrderNum
						AND				SD.OrderLine				=				ID.OrderLine
						AND				SD.OrderRelNum				=				ID.OrderRelNum 

					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcHead					IH				WITH(NoLock)
						ON				ID.Company					=				IH.Company
						AND				ID.InvoiceNum				=				IH.InvoiceNum

					WHERE				SH.Company					=				@Company 
						AND				SH.ShipDate					BETWEEN			@FechaDesde			AND			@FechaCorte
						AND				SH.Plant					=				@Plant
					)			A

WHERE				Error			BETWEEN			@ErrorIni		AND			@ErrorFin

ORDER BY			ShipDate DESC, PackNum 

