
/*****************************************************

RMAs con recepciones registradas, pendientes de facturacion

*****************************************************/

SELECT				RH.Company, RH.RMANum, RH.OpenRMA, RH.RMADate, RH.ShipToNum, 
					RD.OpenDtl, RD.RMALine, RD.PartNum, RD.LineDesc, RD.ReturnQty, 
					RR.RMAReceipt, RR.RcvDate, RR.OpenReceipt, RR.ReceivedQty, RR.DisposedQty, RR.ChangeDate, 
					ID.InvoiceNum 
FROM				[CORPEPIDB].EpicorErp.Erp.RMAHead			RH					WITH(NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.RMADtl			RD					WITH(NoLock)
	ON				RH.Company			=					RD.Company
	AND				RH.RMANum			=					RD.RMANum 
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.RMARcpt			RR					WITH(NoLock)
	ON				RD.Company			=					RR.Company
	AND				RD.RMANum			=					RR.RMANum 
	AND				RD.RMALine			=					RR.RMALine
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcDtl			ID					WITH(NoLock)
	ON				RD.Company			=					ID.Company
	AND				RD.RMANum			=					ID.RMANum 
	AND				RD.RMALine			=					ID.RMALine

WHERE				ID.InvoiceNum		IS NULL
	AND				RR.RcvDate			IS NOT NULL 

ORDER BY			RH.Company, RH.RMANum, RD.RMALine 


/*****************************************************

RMAs sin recepciones registradas 

*****************************************************/

SELECT				RH.Company, RH.RMANum, RH.OpenRMA, RH.RMADate, RH.ShipToNum, 
					RD.OpenDtl, RD.RMALine, RD.PartNum, RD.LineDesc, RD.ReturnQty, 
					RR.RMAReceipt, RR.RcvDate, RR.OpenReceipt, RR.ReceivedQty, RR.DisposedQty, RR.ChangeDate, 
					ID.InvoiceNum 
FROM				[CORPEPIDB].EpicorErp.Erp.RMAHead			RH					WITH(NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.RMADtl			RD					WITH(NoLock)
	ON				RH.Company			=					RD.Company
	AND				RH.RMANum			=					RD.RMANum 
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.RMARcpt			RR					WITH(NoLock)
	ON				RD.Company			=					RR.Company
	AND				RD.RMANum			=					RR.RMANum 
	AND				RD.RMALine			=					RR.RMALine
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcDtl			ID					WITH(NoLock)
	ON				RD.Company			=					ID.Company
	AND				RD.RMANum			=					ID.RMANum 
	AND				RD.RMALine			=					ID.RMALine

WHERE				ID.InvoiceNum		IS NULL
	AND				RR.RcvDate			IS NULL 
	AND				RH.OpenRMA			=					1
	AND				RD.OpenDtl			=					1

ORDER BY			RH.Company, RH.RMANum, RD.RMALine 

