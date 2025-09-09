
SET DATEFORMAT DMY

DECLARE			@FechaDesde	DATE			=		'01/05/2021'

SELECT			IH.Company, IH.InvoiceNum, IH.InvoiceDate, IH.Posted, IH.LegalNumber, IH.InvoiceType, IH.RMANum, IH.EntryPerson,  
				IHU.PAC_InvoiceRef_c, IHU.PAC_InvRefLegNum_c, 
				IH2.LegalNumber
FROM			[CORPEPIDB].EpicorErp.Erp.InvcHead				IH						WITH(NoLock)
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead_UD			IHU						WITH(NoLock)
	ON			IH.SysRowID					=				IHU.ForeignSysRowID
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead				IH2						WITH(NoLock)
	ON			IH.Company					=				IH2.Company
	AND			IHU.PAC_InvoiceRef_c		=				IH2.InvoiceNum
WHERE			(
				IH.LegalNumber				LIKE			'NC-%'
				OR
				IH.LegalNumber				LIKE			'ND-%'
				)
	AND			IH.InvoiceDate				>=				@FechaDesde
ORDER BY		IH.InvoiceDate DESC
