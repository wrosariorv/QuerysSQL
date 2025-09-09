/*****************************************************************
Detalle de series vendidas
*****************************************************************/

SET DATEFORMAT DMY

DECLARE				@Company			VARCHAR(15)		=			'CO01', 
					@FechaDesde			DATE			=			'01/03/2021', 
					@FechasHasta		DATE			=			'31/03/2021', 
					@ProdCode			VARCHAR(15)		=			'TV-LED'


SELECT				SH.Company, SH.PackNum, SH.ShipDate, SH.CustNum, 
					SD.PackLine, SD.PartNum, SD.LineDesc, SD.Plant, 
					P.ProdCode, P.ClassID, P.PartNum, P.SearchWord, 
					C.CustID, C.[Name], 
					SN.SerialNumber, 
					SN.OrderNum, SN.OrderLine, 
					IH.InvoiceNum, IH.LegalNumber, IH.InvoiceDate 

FROM				[CORPEPIDB].EpicorErp.Erp.ShipHead				SH				With(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.ShipDtl				SD				With(NoLock)
	ON				SH.Company				=				SD.Company
	AND				SH.PackNum				=				SD.PackNum	
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part					P				With(NoLock)
	ON				SD.Company				=				P.Company
	AND				SD.PartNum				=				P.PartNum	
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer				C				With(NoLock)
	ON				SH.Company				=				C.Company
	AND				SH.CustNum				=				C.CustNum
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.SerialNo				SN				With(NoLock)
	ON				SD.Company				=				SN.Company
	AND				SD.PackNum				=				SN.PackNum
	AND				SD.PackLine				=				SN.Packline 
LEFT OUTER JOIN		(
					SELECT				*
					FROM				[CORPEPIDB].EpicorErp.Erp.InvcDtl			With(NoLock)
					WHERE				RMANum					=				0
					)												ID			
	ON				SD.Company				=				ID.Company
	AND				SD.PackNum				=				ID.PackNum
	AND				SD.PackLine				=				ID.PackLine 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcHead				IH				With(NoLock)
	ON				ID.Company				=				IH.Company
	AND				ID.InvoiceNum			=				IH.InvoiceNum

WHERE				SH.Company				=				@Company 
	AND				SH.ShipDate				BETWEEN			@FechaDesde		AND		@FechasHasta
	AND				P.ProdCode				=				@ProdCode	


ORDER BY			SN.Company, SN.PartNum, SN.SerialNumber 