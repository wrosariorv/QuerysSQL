
--------------------------------------------------------------------------------------------

SELECT				RH.Company, RH.RlsClassCode, RH.TopCustNum, RH.CustNum, RH.TierLevelNum, 
					C.CustID, C.[Name]
FROM				[CORPEPIDB].EpicorErp.Erp.RlsHead			RH		WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer			C		WITH (NoLock)
	ON				RH.Company				=			C.Company
	AND				RH.CustNum				=			C.CustNum
WHERE				RH.TierLevelNum			=			1

--------------------------------------------------------------------------------------------

DECLARE				@CustNum INT			=			8343

SELECT				IH.Company, IH.InvoiceNum, IH.InvoiceDate, IH.LegalNumber, IH.PONum,  
					ID.InvoiceLine, ID.PartNum, ID.LineDesc, ID.OurShipQty, ID.UnitPrice, ID.ExtPrice, ID.TotalMiscChrg, 
					IT.TaxAmt, 
					(ID.ExtPrice + ID.TotalMiscChrg + IT.TaxAmt)			AS		Total, 
					C.CustID, 
					C.[Name]												AS		CustName,  
--					RH.TopCustNum, 
					C2.CustID												AS		TopCustID, 
					C2.[Name]												AS		TopCustName

FROM				[CORPEPIDB].EpicorErp.Erp.InvcHead			IH		WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcDtl			ID		WITH (NoLock)
	ON				ID.Company				=			IH.Company
	AND				ID.InvoiceNum			=			IH.InvoiceNum
INNER JOIN			(
					SELECT				Company, InvoiceNum, InvoiceLine, SUM(TaxAmt)		TaxAmt
					FROM				[CORPEPIDB].EpicorErp.Erp.InvcTax					WITH (NoLock)
					GROUP BY			Company, InvoiceNum, InvoiceLine
					)											IT
	ON				ID.Company				=			IT.Company
	AND				ID.InvoiceNum			=			IT.InvoiceNum
	AND				ID.InvoiceLine			=			IT.InvoiceLine
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer			C		WITH (NoLock)
	ON				IH.Company				=			C.Company
	AND				IH.CustNum				=			C.CustNum
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.RlsHead			RH		WITH (NoLock)
	ON				RH.Company				=			C.Company
	AND				RH.CustNum				=			C.CustNum
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer			C2		WITH (NoLock)
	ON				RH.Company				=			C2.Company
	AND				RH.TopCustNum			=			C2.CustNum

WHERE				RH.TopCustNum			=			@CustNum

ORDER BY			IH.Company, IH.InvoiceDate, IH.InvoiceNum

