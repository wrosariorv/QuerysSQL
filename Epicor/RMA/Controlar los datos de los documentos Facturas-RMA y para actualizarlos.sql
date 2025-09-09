SELECT Company, LegalNumber, Posted, InvoiceNum, InvoiceDate, EntryPerson, InvoiceComment, InvoiceAmt, SalesRepList, Plant, GroupID, TranDocTypeID, RMANum,
AGDocumentLetter, AGInvoicingPoint, AGLegalnumber
FROM [CORPEPIDB].EpicorErp.Erp.InvcHead IH WITH(Nolock)
WHERE Company = 'CO02'
AND (
LegalNumber LIKE 'NCr%0049-0000000%'
OR
InvoiceNum IN (11381)
OR
RMANum IN (15, 16, 21)
)

ORDER BY 2 DESC


/*

UPDATE [CORPEPIDB].EpicorErp.Erp.InvcHead
SET TranDocTypeID = 'NCCr'
WHERE TranDocTypeID <> 'NCCr'
AND Company = 'CO02'
AND InvoiceNum = 11374
AND Posted = 0


UPDATE [CORPEPIDB].EpicorErp.Erp.InvcHead
SET AGInvoicingPoint = '0049'
WHERE AGInvoicingPoint <> '0049'
AND Company = 'CO02'
AND InvoiceNum = 11374
AND Posted = 0


*/