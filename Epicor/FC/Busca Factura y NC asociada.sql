select		UD.PAC_InvoiceRef_c, UD.PAC_InvRefLegNum_c, HD.* 
from		[CORPE11-EPIDB].[EpicorERP].dbo.InvcHead HD

INNER JOIN	[CORPE11-EPIDB].[EpicorERP].ERP.InvcHead_ud UD
ON			HD.SysRowID		= UD.ForeignSysRowID
WHERE
			HD.InvoiceNum=188331
		OR
			UD.PAC_InvoiceRef_c='184178'