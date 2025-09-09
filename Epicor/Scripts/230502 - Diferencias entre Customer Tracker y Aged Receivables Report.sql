

SELECT				IH.Company, IH.OpenInvoice, IH.Creditmemo, IH.Checkref, IH.InvoiceSuffix, IH.Posted, IH.InvoiceNum, IH.InvoiceDate, 
					IH.InvoiceAmt, IH.DocInvoiceAmt, IH.InvoiceBal, IH.DocInvoiceBal, IH.UnpostedBal, IH.DocUnpostedBal, 
					CD.TranAmt, CD.DocTranAmt, 
					ABS(IH.InvoiceAmt - IH.InvoiceBal) - ABS(CD.TranAmt)						AS Diferencia, 
					C.CustID, C.[Name] 
FROM				CORPEPIDB.EpicorErp.Erp.InvcHead					IH			WITH(NoLock)
LEFT OUTER JOIN		(
					SELECT				Company, InvoiceNum, SUM(ABS(TranAmt)) AS TranAmt, SUM(ABS(DocTranAmt)) AS DocTranAmt
					FROM				CORPEPIDB.EpicorErp.Erp.CashDtl									WITH(NoLock)
					GROUP BY			Company, InvoiceNum 
					)	CD
	ON				IH.Company							=				CD.Company
	AND				IH.InvoiceNum						=				CD.InvoiceNum 
LEFT OUTER JOIN		CORPEPIDB.EpicorErp.Erp.Customer					C			WITH(NoLock)	
	ON				IH.Company							=				C.Company
	AND				IH.CustNum							=				C.CustNum
WHERE				IH.InvoiceSuffix												=				'UR'
	AND				ABS(IH.InvoiceAmt - IH.InvoiceBal)								<>				ABS(CD.TranAmt)
	AND				IH.OpenInvoice													=				1
	AND				ABS(ABS(IH.InvoiceAmt - IH.InvoiceBal) - ABS(CD.TranAmt))		>				1


/************************************************************************************************************

SELECT				*
FROM				CORPEPIDB.EpicorErp.Erp.InvcHead					IH			WITH(NoLock)
WHERE				Company								=				'CO01'
	AND				InvoiceNum							IN				(364492, 332203, 355049, 283329, 92381, 234985, 370191)
ORDER BY			Company, InvoiceNum 


SELECT				*
FROM				CORPEPIDB.EpicorErp.Erp.CashDtl						CD			WITH(NoLock)
WHERE				Company								=				'CO01'
	AND				InvoiceNum							IN				(364492, 332203, 355049, 283329, 92381, 234985, 370191)
ORDER BY			Company, InvoiceNum 


************************************************************************************************************/