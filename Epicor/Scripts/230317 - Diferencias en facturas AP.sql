
SELECT			APIH.Company, APIH.GroupID, APIH.VendorNum, APIH.InvoiceDate, APIH.InvoiceNum, APIH.InvoiceAmt, APIH.Posted, 
--				APIH.InvoiceVendorAmt, 
--				APIH.TaxAmt																				AS		TaxAmtHeader, 	
--				Det.ExtCost																				AS		ExtCostLinea,
				Det.TotalTax																			AS		TotalTaxLinea, 
				ISNULL(Tax.TaxAmt, 0)																	AS		TaxAmtLinea, 
				ISNULL(Mi.MiscAmt, 0)																	AS		MiscAmtLinea, 
				(Det.ExtCost + ISNULL(Mi.MiscAmt, 0) + ISNULL(Tax.TaxAmt, 0))							AS		TotalLinea,	
--				APIH.InvoiceAmt	- (Det.ExtCost + ISNULL(Mi.MiscAmt, 0) + ISNULL(Tax.TaxAmt, 0))			AS		Diferencia, 
				V.VendorID, V.[Name]

FROM			[CORPEPIDB].EpicorERP.Erp.APInvHed								APIH		WITH(NoLock)
LEFT OUTER JOIN	(
				SELECT			Company, VendorNum, InvoiceNum, 
								SUM(ExtCost)							AS		ExtCost, 
								SUM(TotalTax)							AS		TotalTax, 
								SUM(ExtCost + TotalTax)					AS		TotalLinea
				FROM			[CORPEPIDB].EpicorERP.Erp.APInvDtl							WITH(NoLock)
				GROUP BY		Company, VendorNum, InvoiceNum 
				)																Det
	ON			APIH.Company				=				Det.Company
	AND			APIH.VendorNum				=				Det.VendorNum
	AND			APIH.InvoiceNum 			=				Det.InvoiceNum 
LEFT OUTER JOIN	(
				SELECT			APIT.Company, APIT.VendorNum, APIT.InvoiceNum, SUM(APIT.TaxAmt)			AS		TaxAmt 
				FROM			[CORPEPIDB].EpicorERP.Erp.APInvTax					APIT
				LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.SalesTax					ST
					ON			APIT.Company			=			ST.Company
					AND			APIT.TaxCode			=			ST.TaxCode 
				WHERE			ST.CollectionType		=			0
				GROUP BY		APIT.Company, APIT.VendorNum, APIT.InvoiceNum
				)																Tax
	ON			APIH.Company				=				Tax.Company
	AND			APIH.VendorNum				=				Tax.VendorNum
	AND			APIH.InvoiceNum 			=				Tax.InvoiceNum 

LEFT OUTER JOIN	(
				SELECT			APIM.Company, APIM.VendorNum, APIM.InvoiceNum, SUM(APIM.MiscAmt)			AS		MiscAmt 
				FROM			[CORPEPIDB].EpicorERP.Erp.APInvMsc					APIM
				GROUP BY		APIM.Company, APIM.VendorNum, APIM.InvoiceNum
				)																Mi
	ON			APIH.Company				=				Mi.Company
	AND			APIH.VendorNum				=				Mi.VendorNum
	AND			APIH.InvoiceNum 			=				Mi.InvoiceNum 

LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.Vendor								V			WITH(NoLock)
	ON			APIH.Company				=				V.Company
	AND			APIH.VendorNum				=				V.VendorNum			

WHERE			Det.TotalTax				<>				ISNULL(Tax.TaxAmt, 0)
	AND			Det.TotalTax				<>				0
	AND			APIH.GroupID				<>				'StartUp.'
--	OR			APIH.InvoiceNum				=				'A-0007-00006734'

ORDER BY		APIH.Company, V.VendorID, APIH.InvoiceDate, APIH.InvoiceNum 

