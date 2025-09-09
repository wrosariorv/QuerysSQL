
/*

SELECT				IH.Company, IH.InvoiceNum, IH.InvoiceDate, IH.LegalNumber, IH.DueDate  
FROM				[CORPEPIDB].EpicorERP.Erp.InvcHead			IH				WITH (NoLock)
WHERE				LegalNumber				LIKE		'%0233%009985'

*/
------------------------------------------------

DECLARE				@InvoiceNum	INT				=			270934


SELECT				IH.Company, IH.InvoiceNum, IH.InvoiceDate, IH.LegalNumber, IH.DueDate, 
					ID.OrderNum, ID.OrderLine, ID.OrderRelNum 
FROM				[CORPEPIDB].EpicorERP.Erp.InvcHead			IH				WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.InvcDtl			ID				WITH (NoLock)
	ON				IH.Company				=			ID.Company
	AND				IH.InvoiceNum			=			ID.InvoiceNum
WHERE				IH.InvoiceNum			=			@InvoiceNum


SELECT				ISC.Company, ISC.InvoiceNum, ISC.PaySeq, ISC.PayDays, ISC.PayDueDate, 
					ISCU.RV_FechaVtoOrig_c, ISCU.RV_DiasVtoOrig_c
FROM				[CORPEPIDB].EpicorERP.Erp.InvcSched			ISC				WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.InvcSched_UD		ISCU			WITH (NoLock)
	ON				ISC.SysRowID			=			ISCU.ForeignSysRowID
WHERE				ISC.InvoiceNum			=			@InvoiceNum


SELECT				SH.Company, SH.PackNum, SH.LegalNumber, SH.ShipDate, 
					SHU.RV_FechaConforme_c 
FROM				[CORPEPIDB].EpicorERP.Erp.InvcDtl			ID				WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.ShipDtl			SD				WITH (NoLock)
	ON				ID.Company				=			SD.Company
	AND				ID.OrderNum				=			SD.OrderNum
	AND				ID.OrderLine			=			SD.OrderLine
	AND				ID.OrderRelNum			=			SD.OrderRelNum
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.ShipHead			SH				WITH (NoLock)
	ON				SH.Company				=			SD.Company
	AND				SH.PackNum				=			SD.PackNum
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.ShipHead_UD		SHU				WITH (NoLock)
	ON				SH.SysRowID				=			SHU.ForeignSysRowID

WHERE				ID.InvoiceNum			=			@InvoiceNum


SELECT				ID.Company, ID.OrderNum, ID.OrderLine, ID.OrderRelNum, 
					OD.QuoteNum, OD.QuoteLine
FROM				[CORPEPIDB].EpicorERP.Erp.InvcDtl			ID				WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.OrderDtl			OD				WITH (NoLock)
	ON				ID.Company				=			OD.Company
	AND				ID.OrderNum				=			OD.OrderNum
	AND				ID.OrderLine			=			OD.OrderLine
WHERE				ID.InvoiceNum			=			@InvoiceNum

