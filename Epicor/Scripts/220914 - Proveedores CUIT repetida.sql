
------------------------------------------------

SELECT			B.Company, B.VendorID, B.[Name], B.TaxPayerID, B.GroupCode 
FROM			(
				SELECT			Company, TaxPayerID, COUNT(*) AS Cantidad 
				FROM			[CORPEPIDB].EpicorErp.Erp.Vendor				WITH(NoLock)
				GROUP BY		Company, TaxPayerID
				HAVING			COUNT(*)		>				1 
				)		A
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Vendor			B					WITH(NoLock)
	ON			A.Company			=			B.Company
	AND			A.TaxPayerID		=			B.TaxPayerID
ORDER BY		B.Company, B.TaxPayerID, B.VendorID


------------------------------------------------

SELECT			AP.Company, AP.InvoiceNum, AP.InvoiceDate, AP.InvoiceAmt, AP.InvoiceBal, AP.EntryPerson, AP.[Description], 
				V.VendorID, V.[Name], V.TaxPayerID, V.GroupCode 
FROM			[CORPEPIDB].EpicorErp.Erp.APInvHed			AP					WITH(NoLock)
INNER JOIN		(
				SELECT			B.Company, B.VendorID, B.[Name], B.TaxPayerID, B.GroupCode, B.VendorNum  
				FROM			(
								SELECT			Company, TaxPayerID, COUNT(*) AS Cantidad 
								FROM			[CORPEPIDB].EpicorErp.Erp.Vendor				WITH(NoLock)
								GROUP BY		Company, TaxPayerID
								HAVING			COUNT(*)		>				1 
								)		A
				INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Vendor			B					WITH(NoLock)
					ON			A.Company			=			B.Company
					AND			A.TaxPayerID		=			B.TaxPayerID
				)		V
	ON			AP.Company			=			V.Company
	AND			AP.VendorNum		=			V.vendorNum
WHERE			AP.InvoiceBal		<>			0

