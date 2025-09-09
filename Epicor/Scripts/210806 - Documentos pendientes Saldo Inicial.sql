

SELECT				COUNT(*)
FROM				[CORPEPIDB].EpicorErp.Erp.InvcHead
WHERE				GroupID				=			'StartUp'



SELECT				IH.Company, IH.GroupID, IH.CustNum, IH.InvoiceNum, IH.LegalNumber, IH.InvoiceDate, IH.InvoiceAmt, IH.InvoiceBal, IH.InvoiceComment, 
					IH.CurrencyCode, 
					C.CustID, C.[Name] 
FROM				[CORPEPIDB].EpicorErp.Erp.InvcHead				IH			WITH(NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Customer				C			WITH(NoLock)
	ON				IH.Company				=			C.Company
	AND				IH.CustNum				=			C.CustNum 
WHERE				IH.GroupID				=			'StartUp'
	AND				IH.InvoiceBal			<>			0
ORDER BY			IH.Company, C.CustID, IH.InvoiceNum
