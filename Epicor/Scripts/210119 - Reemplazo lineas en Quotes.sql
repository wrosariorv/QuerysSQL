

DECLARE				@PartNumQuitar		VARCHAR(50)			=			'AND50P6UHD-F', 
					@PartNumCorrecto	VARCHAR(50)			=			'AND50P6UHD-B' 


/************************************************
Detalle de cotizaciones de venta
************************************************/


SET DATEFORMAT DMY

SELECT				QH.Company, QH.EntryDate, QH.QuoteNum, QH.ReasonType, 
					QD.QuoteLine, QD.PartNum, QD.OrderQty, QD.ListPrice, QD.LineDesc, QD.ExpUnitPrice, 
					QD.DiscountPercent, QD.Discount, QD.ChangedBy, QD.Quoted, QD.Ordered, 
					C.CustID, C.[Name]
FROM				[CORPEPIDB].EpicorErp.Erp.QuoteDtl			QD		WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.QuoteHed			QH		WITH (NoLock)
	ON				QD.Company			=			QH.Company
	AND				QD.QuoteNum			=			QH.QuoteNum
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer			C		WITH (NoLock)
	ON				QH.Company			=			C.Company
	AND				QH.CustNum			=			C.CustNum
WHERE				QH.ReasonType		NOT IN		('W', 'L')
	AND				(
					QD.PartNum			=			@PartNumCorrecto				-- Debe permanecer
					OR
					QD.PartNum			=			@PartNumQuitar					-- Hay que quitar
					)
	AND				QD.Ordered			=			0


ORDER BY			1, 2, 3, 4

