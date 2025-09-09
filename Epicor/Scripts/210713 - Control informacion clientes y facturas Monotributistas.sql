
SELECT			Company, CustID, [Name], AGAFIPResponsibilityCode, TaxRegionCode 
FROM			[CORPEPIDB].EpicorErp.Erp.Customer						C				WITH(NoLock)
WHERE			AGAFIPResponsibilityCode				IN				('M', 'MS')
ORDER BY		Company, CustID

		
SELECT			Company, CreditMemo, InvoiceSuffix, Posted, InvoiceNum, LegalNumber, EntryPerson, InvoiceDate, InvoiceComment, InvoiceAmt 
FROM			[CORPEPIDB].EpicorErp.Erp.InvcHead						IH				WITH(NoLock)
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead_UD					IHU				WITH(NoLock)
	ON			IH.SysRowID				=			IHU.ForeignSysRowID
WHERE			Character03				LIKE		'%MON%'
	AND			InvoiceSuffix			NOT IN		('UR')
ORDER BY		Company, InvoiceDate DESC


/*
		
SELECT			*
FROM			[CORPEPIDB].EpicorErp.Erp.TaxRgnSalesTax						C				WITH(NoLock)
WHERE			TaxRegionCode			=				'C52'
ORDER BY		Company, Taxnum 

*/




