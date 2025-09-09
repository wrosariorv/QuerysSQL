

SELECT			IH.Company, IH.CreditMemo, IH.InvoiceDate, IH.InvoiceNum, IH.LegalNumber, IH.InvoiceType, IH.Plant, 
				ID.InvoiceLine, ID.PartNum, ID.LineDesc, ID.ProdCode, ID.OurShipQty, ID.UnitPrice, ID.DiscountPercent, ID.Discount,  
				P.ClassID, 
				IHU.CheckBox02, IHU.CheckBox03, IHU.Number12, IHU.Number13, IHU.Number14 

FROM			[CORPEPIDB].EpicorERP.Erp.InvcHead				IH				WITH (NoLock)
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.InvcHead_UD			IHU				WITH (NoLock)
	ON			IH.SysRowID				=				IHU.ForeignSysRowID 
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.InvcDtl				ID				WITH (NoLock)
	ON			IH.Company				=				ID.Company
	AND			IH.InvoiceNum			=				ID.InvoiceNum 
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.Part					P				WITH (NoLock)
	ON			ID.Company				=				P.Company
	AND			ID.PartNum				=				P.PartNum 
WHERE			(
				IH.LegalNumber			LIKE			'FC-B%'
				OR	
				IH.LegalNumber			LIKE			'B%'
				)
--	AND			P.ClassID				=				'REVI'
--	AND			IHU.Number14			<>				0

ORDER BY		IH.InvoiceDate DESC, IH.InvoiceNum DESC 

