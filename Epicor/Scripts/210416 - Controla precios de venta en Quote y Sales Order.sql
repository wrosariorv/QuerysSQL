
-- DECLARE			@Company			VARCHAR(15)		=		'CO02'


--------------------------------------------


SELECT			QH.Company, QH.CurrencyCode, 
				QD.QuoteNum, QD.QuoteLine, QD.PartNum, QD.LineDesc, QD.TaxCatID, QD.OrderQty, QD.ListPrice, 
				QD.DiscountPercent, QD.Discount, 
				QDU.Number11												AS		PrecioNegoc, 
				PL.ListCode, 
				PL.BasePrice												AS		NewBasePrice, 
				C.CustID, 
				C.[Name]													AS		CustName 

FROM			[CORPEPIDB].EpicorErp.Erp.QuoteDtl					QD					WITH(NoLock)
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.QuoteHed					QH					WITH(NoLock)
	ON			QD.Company			=			QH.Company
	AND			QD.QuoteNum			=			QH.QuoteNum
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Customer					C					WITH(NoLock)
	ON			QH.Company			=			C.Company
	AND			QH.CustNum			=			C.CustNum
LEFT OUTER JOIN	[CORPEPIDB].EpicorErp.Erp.QuoteDtl_UD				QDU					WITH(NoLock)
	ON			QD.SysRowID			=			QDU.ForeignSysRowID
LEFT OUTER JOIN	(
				SELECT			Company, PartNum, ListCode, BasePrice
				FROM			[CORPEPIDB].EpicorErp.Erp.PriceLstparts									WITH(NoLock)
				WHERE			ListCode		LIKE			'P159%'
				)	PL
	ON			QD.Company			=			PL.Company
	AND			QD.PartNum			=			PL.PartNum

WHERE			QD.Ordered			=			0
	AND			QH.ReasonType		NOT IN		('W', 'L')
--	AND			QD.ListPrice		<>			BasePrice
ORDER BY		QD.Company, QD.PartNum, QD.QuoteNum, QD.QuoteLine


--------------------------------------------


SELECT			OH.Company, OH.CurrencyCode, 
				OD.OrderNum, OD.OrderLine, OD.PartNum, OD.LineDesc, OD.TaxCatID, OD.OrderQty, OD.ListPrice, OD.UnitPrice, 
				OD.DiscountPercent, OD.Discount,  
				ODU.NUmber08												AS		PrecioNegoc, 
				PL.ListCode, 
				PL.BasePrice												AS		NewBasePrice, 
				C.CustID, 
				C.[Name]													AS		CustName 
FROM			[CORPEPIDB].EpicorErp.Erp.OrderDtl					OD					WITH(NoLock)
LEFT OUTER JOIN	[CORPEPIDB].EpicorErp.Erp.OrderDtl_UD				ODU					WITH(NoLock)
	ON			OD.SysRowID			=			ODU.ForeignSysRowID
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.OrderHed					OH					WITH(NoLock)
	ON			OD.Company			=			OH.Company
	AND			OD.OrderNum			=			OH.OrderNum 
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Customer					C					WITH(NoLock)
	ON			OH.Company			=			C.Company
	AND			OH.CustNum			=			C.CustNum
LEFT OUTER JOIN	(
				SELECT			Company, PartNum, ListCode, BasePrice
				FROM			[CORPEPIDB].EpicorErp.Erp.PriceLstparts									WITH(NoLock)
				WHERE			ListCode		LIKE			'P159%'
				)	PL
	ON			OD.Company			=			PL.Company
	AND			OD.PartNum			=			PL.PartNum
WHERE			OD.OpenLine			=			1
--	AND			OD.ListPrice		<>			PL.BasePrice
ORDER BY		OD.Company, OD.PartNum, OD.QuoteNum, OD.QuoteLine


--------------------------------------------


