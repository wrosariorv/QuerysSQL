

SELECT				*
FROM				[CORPEPIDB].EpicorErp.Erp.Vendor
WHERE				[Name]				LIKE			'%Epicor%'
	OR				[Name]				LIKE			'%TCP%'

----------------------------------

SELECT				AP.Company, AP.OpenPayable, AP.VendorNum, AP.InvoiceNum, AP.InvoiceDate, AP.GroupID, AP.InvoiceRef, AP.EntryPerson, 
					AP.InvoiceAmt, AP.InvoiceBal, AP.DocInvoiceAmt, AP.DocInvoiceBal, AP.[Description], 
					V.VendorID, V.[Name] 
FROM				[CORPEPIDB].EpicorErp.Erp.APInvHed			AP				WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Vendor			V				WITH(NoLock)
	ON				AP.Company			=				V.Company
	AND				AP.VendorNum		=				V.VendorNum
WHERE				AP.Company			=				'CO01'
	AND				AP.VendorNum		IN				(4881, 1199, 5313) 
	AND				AP.OpenPayable		=				1

----------------------------------
