SELECT                Company, InvoiceNum, LegalNumber, InvoiceDate, CreditMemo, 
                    InvoiceAmt, DocInvoiceAmt, InvoiceBal, DocInvoiceBal, UnpostedBal, DocUnpostedBal, RepComm1, RepSales1 
FROM                CORPEPIDB.EpicorErp.Erp.InvcHead
WHERE                InvoiceNum                IN                (332755, 357089, 357756) 


Select					*

FROM					CORPEPIDB.EpicorErp.Erp.InvcTax

WHERE                InvoiceNum                IN                (332755, 357089, 357756) 


/* UPDATE                CORPEPIDB.EpicorErp.Erp.InvcHead
SET                    InvoiceAmt            =        ABS(InvoiceAmt), 
                    DocInvoiceAmt        =        ABS(DocInvoiceAmt), 
                    InvoiceBal            =        ABS(InvoiceBal), 
                    DocInvoiceBal        =        ABS(DocInvoiceBal), 
                    UnpostedBal            =        ABS(UnpostedBal), 
                    DocUnpostedBal        =        ABS(DocUnpostedBal), 
                    RepComm1            =        ABS(RepComm1), 
                    RepSales1            =        ABS(RepSales1)
WHERE                InvoiceNum            =        357756
    AND                InvoiceBal            <        0 */


SELECT                Company, InvoiceNum, LegalNumber, InvoiceDate, CreditMemo, 
                    InvoiceAmt, DocInvoiceAmt, InvoiceBal, DocInvoiceBal, UnpostedBal, DocUnpostedBal, RepComm1, RepSales1 
FROM                CORPEPIDB.EpicorErp.Erp.InvcHead
WHERE                InvoiceNum                IN                ('360993','350762')

SELECT                Company, InvoiceNum, LegalNumber, InvoiceDate, CreditMemo, 
                    InvoiceAmt, DocInvoiceAmt, InvoiceBal, DocInvoiceBal, UnpostedBal, DocUnpostedBal, RepComm1, RepSales1 
FROM                CORPEPIDB.EpicorErp.Erp.InvcHead
WHERE                InvoiceNum                IN                ('212255','207861')

SELECT                Company, InvoiceNum, LegalNumber, InvoiceDate, CreditMemo, 
                    InvoiceAmt, DocInvoiceAmt, InvoiceBal, DocInvoiceBal, UnpostedBal, DocUnpostedBal, RepComm1, RepSales1 
FROM                CORPEPIDB.EpicorErp.Erp.InvcHead
WHERE                InvoiceNum                IN                ('7761','129537')







Select					*

FROM					CORPEPIDB.EpicorErp.Erp.InvcTax

WHERE                InvoiceNum                IN                ('360993','350762')

