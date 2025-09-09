

SELECT				IH.Company, IH.InvoiceNum, IH.InvoiceDate, IH.GroupID, IH.TermsCode, IH.InvoiceAmt, IH.SalesRepList, IH.Plant, IH.LegalNumber, 
					ID.Plant, ID.InvoiceLine, ID.PartNum, ID.LineDesc, ID.ProdCode, ID.TaxCatID, ID.UnitPrice, ID.TotalMiscChrg 
FROM				[CORPEPIDB].EpicorErp.Erp.InvcHead						IH		WITH(NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcDtl						ID		WITH(NoLock)
	ON				IH.Company					=						ID.Company
	AND				IH.InvoiceNum				=						ID.InvoiceNum
WHERE				ID.Plant					IN						('CDEE', 'MPlace')
	AND				ID.TotalMiscChrg 			<>						0
ORDER BY			IH.InvoiceNum DESC 


