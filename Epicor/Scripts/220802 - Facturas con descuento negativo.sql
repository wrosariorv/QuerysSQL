
/*********************************************************************************************

Ultima ejecucion: 12/08/2022
Registros encontrados: 52

*********************************************************************************************/

SELECT				IH.Company, IH.InvoiceNum, IH.InvoiceDate, IH.LegalNumber, IH.SalesRepList, 
					ID.InvoiceLine, ID.PartNum, ID.LineDesc, ID.ProdCode, ID.UnitPrice, ID.DiscountPercent, 
					ID.OrderNum, ID.OrderLine, ID.OrderRelNum, 
					OD.QuoteNum, OD.QuoteLine, 
					QH.Reference
FROM				[CORPEPIDB].EpicorErp.Erp.InvcHead				IH			WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcDtl				ID			WITH(NoLock)
	ON				IH.Company					=				ID.Company
	AND				IH.InvoiceNum				=				ID.InvoiceNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.OrderDtl				OD			WITH(NoLock)
	ON				ID.Company					=				OD.Company
	AND				ID.OrderNum					=				OD.OrderNum 
	AND				ID.OrderLine				=				OD.OrderLine 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.QuoteHed				QH			WITH(NoLock)
	ON				OD.Company					=				QH.Company
	AND				OD.QuoteNum					=				QH.QuoteNum 

WHERE				ID.DiscountPercent			<				0
ORDER BY			ID.InvoiceNum, ID.InvoiceLine

