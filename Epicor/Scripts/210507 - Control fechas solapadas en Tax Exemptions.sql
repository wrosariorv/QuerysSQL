
SET DATEFORMAT DMY


SELECT			A.*, 
				C.CustID, C.[Name], 
				B.*
FROM			(
				SELECT			Company, RelatedToFile, Key1, Key2, TaxCode, RateCode, EffectiveFrom, EffectiveTo, 
								ExemptType, ExemptPercent, ResolutionNum, ResolutionDate   
				FROM			[CORPEPIDB].EpicorErp.Erp.TaxExempt						WITH(NoLock)
				WHERE			RelatedToFile				=				'Customer'
				)		A

LEFT OUTER JOIN	(
				SELECT			Company, RelatedToFile, Key1, Key2, TaxCode, RateCode, EffectiveFrom, EffectiveTo, 
								ExemptType, ExemptPercent, ResolutionNum, ResolutionDate   
				FROM			[CORPEPIDB].EpicorErp.Erp.TaxExempt						WITH(NoLock)
				WHERE			RelatedToFile				=				'Customer'
				)		B
	ON			A.Company			=			B.Company
	AND			A.Key1				=			B.Key1
	AND			A.Key2				=			B.Key2
	AND			A.TaxCode			=			B.TaxCode
	AND			A.RateCode			=			B.RateCode

LEFT OUTER JOIN	[CORPEPIDB].EpicorErp.Erp.Customer		C				WITH(NoLock)
	ON			A.Company			=			C.Company
	AND			A.Key1				=			C.CustNum

WHERE			(
				B.EffectiveFrom		BETWEEN		A.EffectiveFrom		AND		A.EffectiveTo
				OR	
				B.EffectiveTo		BETWEEN		A.EffectiveFrom		AND		A.EffectiveTo
				)
	AND			B.EffectiveFrom		<>			A.EffectiveFrom	
	AND			B.EffectiveTo		<>			A.EffectiveTo	
--	AND			B.ExemptPercent		<>			A.ExemptPercent

	AND			A.ResolutionDate	>=			'01/01/2022'

ORDER BY		A.Company, C.CustId, A.EffectiveFrom	DESC
