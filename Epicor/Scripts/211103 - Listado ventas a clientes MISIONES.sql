
-- Facturas generadas a clientes con domicilio o jurisdiccion MISIONES

SELECT				C.Company, C.CustID, C.[Name], C.ResaleID, C.AGGrossIncomeTaxID, 
					ST.ShipToNum, ST.Address1, ST.City, ST.[State], ST.AGProvinceCode, 
					IH.InvoiceDate, IH.CreditMemo, IH.InvoiceNum, IH.LegalNumber, IH.GroupID, IH.InvoiceType, IH.InvoiceAmt, 
					ID.PartNum, ID.LineDesc, 
					ISNULL(IT.TaxCode, '')							AS		TaxCode, 
					ISNULL(IT.[Percent], 0)							AS		[Percent],
					ISNULL(IT.TaxAmt, 0)							AS		TaxAmt 

FROM				[CORPEPIDB].EpicorErp.Erp.Customer					C		WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.ShipTo					ST		WITH(NoLock)
	ON				C.Company					=				ST.Company
	AND				C.CustNum					=				ST.CustNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcDtl					ID		WITH(NoLock)
	ON				ID.Company					=				ST.Company
	AND				ID.CustNum					=				ST.CustNum 
	AND				ID.ShipToNum				=				ST.SHipToNum
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcHead					IH		WITH(NoLock)
	ON				ID.Company					=				IH.Company
	AND				ID.InvoiceNum				=				IH.InvoiceNum 
LEFT OUTER JOIN		(
					SELECT				Company, InvoiceNum, InvoiceLine, TaxCode, [Percent], TaxAmt 
					FROM				[CORPEPIDB].EpicorErp.Erp.InvcTax							WITH(NoLock)
					WHERE				TaxCode					=				'C19'
					)			IT
	ON				ID.Company					=				IT.Company
	AND				ID.InvoiceNum				=				IT.InvoiceNum
	AND				ID.InvoiceLine				=				IT.InvoiceLine

WHERE				IH.Company					=				'CO01'
	AND				IH.Posted					=				1
	AND				ST.ShipToNum				<>				''		
	AND				(
					ST.[State]					=				'Misiones'
					OR
					ST.AGProvinceCode			=				'19'
					)
	AND				(
					ID.PartNum					NOT LIKE		'%UE'
					AND
					ID.PartNum					NOT LIKE		'%UI'
					)

ORDER BY			IH.Company, IH.InvoiceDate, IH.InvoiceNum, ID.InvoiceLine 


