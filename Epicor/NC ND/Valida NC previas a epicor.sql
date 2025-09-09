SELECT            *
FROM            [CORPEPIDB].EpicorErp.Erp.Customer                                    WITH(NoLock)
WHERE            CustID                =                '40957'



SELECT            Company, OpenInvoice, CreditMemo, InvoiceSuffix, GroupID, Posted, InvoiceNum, InvoiceDate, LegalNumber, InvoiceBal,
                InvoiceComment, InvoiceAmt, InvoiceBal, TranDocTypeID  
FROM            [CORPEPIDB].EpicorErp.Erp.InvcHead                                    WITH(NoLock)
WHERE            CustNum                =                210
    AND            OpenInvoice            =                1
    AND            InvoiceBal            <                0
ORDER BY        7



/***************************************************



UPDATE            [CORPEPIDB].EpicorErp.Erp.InvcHead
SET                CreditMemo            =                1,
                TranDocTypeID        =                'NC'
WHERE            CustNum                =                210
    AND            OpenInvoice            =                1
    AND            InvoiceBal            <                0
    AND            TranDocTypeID        =                'FC'



***************************************************/


------------------------------------------------------------------------------------------------------------------------------



SELECT            *
FROM            [CORPEPIDB].EpicorErp.Erp.Customer                                    WITH(NoLock)
WHERE            CustID                =                '48072'



SELECT            Company, OpenInvoice, CreditMemo, InvoiceSuffix, GroupID, Posted, InvoiceNum, InvoiceDate, LegalNumber, InvoiceBal,
                InvoiceComment, InvoiceAmt, InvoiceBal, TranDocTypeID  
FROM            [CORPEPIDB].EpicorErp.Erp.InvcHead                                    WITH(NoLock)
WHERE            CustNum                =                1637
    AND            OpenInvoice            =                1
    AND            InvoiceBal            <                0
ORDER BY        7


begin tran

/***************************************************



UPDATE            [CORPEPIDB].EpicorErp.Erp.InvcHead
SET                CreditMemo            =                1,
                TranDocTypeID        =                'NC'
WHERE            CustNum                =                1637
    AND            OpenInvoice            =                1
    AND            InvoiceBal            <                0
    AND            TranDocTypeID        =                'FC'



***************************************************/
Rollback tran
--commit tran