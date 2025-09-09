

DECLARE					@GroupCode	VARCHAR(8)			=			'FIE', 
						@FechaDesde	DATE				=			'01/01/2019'


SELECT					G.CustID, G.[Name], 
						IH.InvoiceNum, IH.InvoiceDate, IH.LegalNumber, IH.CurrencyCode, IH.Plant,  
						ID.ProdCode, ID.InvoiceLine, ID.PartNum, ID.LineDesc, ID.ExtPrice, ID.Discount, ID.SellingShipQty, 
						IT.TaxAmt,   
						(ID.ExtPrice - ID.Discount + IT.TaxAmt)		AS		TotalLinea, 
						IHU.Character07								AS		UnNeg,   
						YEAR(IH.InvoiceDate)						AS		Ejercicio, 	
						MONTH(IH.InvoiceDate)						AS		Mes

FROM					[CORPEPIDB].EpicorErp.Erp.InvcHead		IH		WITH(NoLock)
INNER JOIN				[CORPEPIDB].EpicorErp.Erp.InvcHead_UD	IHU		WITH(NoLock)
	ON					IH.SysRowID					=				IHU.ForeignSysRowID
INNER JOIN				[CORPEPIDB].EpicorErp.Erp.InvcDtl		ID		WITH(NoLock)
	ON					IH.Company					=				ID.Company
	AND					IH.InvoiceNum				=				ID.InvoiceNum
LEFT OUTER JOIN			(
						SELECT					Company, InvoiceNum, InvoiceLine, SUM(TaxAmt) AS TaxAmt
						FROM					[CORPEPIDB].EpicorErp.Erp.InvcTax				WITH(NoLock)
						GROUP BY				Company, InvoiceNum, InvoiceLine
						)			IT
	ON					ID.Company					=				IT.Company
	AND					ID.InvoiceNum				=				IT.InvoiceNum
	AND					ID.InvoiceLine				=				IT.InvoiceLine

INNER JOIN				(
						SELECT					*
						FROM					[CORPEPIDB].EpicorErp.Erp.Customer				WITH (NoLock)
						WHERE					GroupCode					=				@GroupCode
						)	G
	ON					IH.Company					=				G.Company
	AND					IH.CustNum					=				G.CustNum

WHERE					IH.Company					=				'CO01'
	AND					IH.Posted					=				1
	AND					IH.InvoiceDate				>=				@FechaDesde
	AND					IH.InvoiceSuffix			NOT IN			('UR')
	AND					ID.ExtPrice					<>				0
	AND					ID.ProdCode					IN				(
																	'AA-PORT',	'AA-SPLIT', 'ACC-AV', 'ACC-INF', 'ASP', 'AUPERS', 'CEL', 'HORELEC', 
																	'HTEAT', 'MICSIST', 'MONIT', 'MWO', 'PEQELEC', 'TAB', 'TV-LED'
																	)