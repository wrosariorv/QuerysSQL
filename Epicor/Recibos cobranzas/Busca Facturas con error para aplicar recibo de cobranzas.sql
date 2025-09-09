use EpicorERP
SELECT                Company, OpenInvoice, CreditMemo, UnappliedCash, CheckRef, InvoiceSuffix, InvoiceNum, InvoiceAmt, DocInvoiceAmt,
                    InvoiceBal, DocInvoiceBal, UnpostedBal, DocUnpostedBal, LegalNumber
FROM                [CORPEPIDB].EpicorERP.Erp.InvcHead                    ID        WITH (NoLock)
WHERE                InvoiceBal                <>                0
    AND                InvoiceBal                <>                UnpostedBal
    AND                OpenInvoice                =                1
ORDER BY            Company, InvoiceNum





/*



UPDATE                [CORPEPIDB].EpicorERP.Erp.InvcHead            
SET                    UnpostedBal                =            InvoiceBal,
                    DocUnpostedBal            =            DocInvoiceBal
WHERE                Company                    =            'CO01'
    AND                InvoiceNum                =            330936
    AND                UnpostedBal                =            0



*/