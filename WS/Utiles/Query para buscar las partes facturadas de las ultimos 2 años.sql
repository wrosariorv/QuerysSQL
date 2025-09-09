SELECT          DISTINCT
                IH.Company, 
                ID.PartNum 

FROM            [CORPE11-EPIDB].[EpicorERP].Erp.InvcHead             IH      WITH(NoLock)
INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.InvcDtl             ID      WITH(NoLock)
    ON          IH.Company              =       ID.Company
    AND         IH.InvoiceNum           =       ID.InvoiceNum 
INNER JOIN      [CORPE11-EPIDB].EpicorErp.Erp.Part                   P       WITH(NoLock)
    ON          ID.Company              =       P.Company
    AND         ID.PartNum              =       P.PartNum
INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.OrderDtl             OD      WITH(NoLock)
    ON          ID.Company              =       OD.Company
    AND         ID.OrderNum             =       OD.OrderNum 
    AND         ID.OrderLine            =       OD.OrderLine 
INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.QuoteHed             QH      WITH(NoLock)
    ON          OD.Company              =       QH.Company
    AND         OD.QuoteNum             =       QH.QuoteNum 
WHERE           IH.Company              =       'CO01'
    AND         IH.InvoiceDate BETWEEN '2023-04-30' AND GETDATE()
    AND         ID.PartNum NOT LIKE '%-SK%'
    AND         P.ClassID IN ('PTF', 'PTCO', 'SK', 'SKCO', 'REVI', 'REVN')
	ORDER BY	ID.PartNum