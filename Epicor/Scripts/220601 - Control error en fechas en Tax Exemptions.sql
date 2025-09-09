
SET DATEFORMAT DMY

SELECT			TE.Company, TE.RelatedToFile, TE.Key1, TE.Key2, TE.TaxCode, TE.RateCode, TE.EffectiveFrom, TE.EffectiveTo, 
				TE.ExemptType, TE.ExemptPercent, TE.ResolutionNum, TE.ResolutionDate, 
				C.CustID, C.[Name], 
				EOMONTH(TE.EffectiveFrom)						AS		New_EffectiveFrom
FROM			[CORPEPIDB].EpicorErp.Erp.TaxExempt				TE		WITH(NoLock)
LEFT OUTER JOIN	[CORPEPIDB].EpicorErp.Erp.Customer				C		WITH(NoLock)
	ON			TE.Company						=				C.Company
	AND			TE.Key1							=				C.CustNum
WHERE			TE.RelatedToFile				=				'Customer'
	AND			TE.EffectiveTo					<				TE.EffectiveFrom
	AND			TE.EffectiveFrom				>=				'01/01/2022'
--	AND			TE.Key1							=				'4302'
--	AND			TE.TaxCode						=				'C01' 
ORDER BY		C.CustID, TE.ResolutionDate DESC


/*

UPDATE 		[CORPEPIDB].EpicorErp.Erp.TaxExempt		
SET			EffectiveTo				=			EOMONTH(EffectiveFrom)
WHERE		Company					=			'CO01' 
	AND		RelatedToFile			=			'Customer' 
	AND		Key1					=			'4302' 
	AND		Key2					=			'' 
	AND		TaxCode					=			'C01' 
	AND		RateCode				=			'C01' 
	AND		EffectiveFrom			>=			'2016-01-01' 
	AND		EffectiveTo				=			'2013-12-31' 

*/



/*

UPDATE 		[CORPEPIDB].EpicorErp.Erp.TaxExempt		
SET			EffectiveTo				=			'2022-03-20'
WHERE		Company					=			'CO01' 
	AND		RelatedToFile			=			'Customer' 
	AND		Key1					=			'4302' 
	AND		Key2					=			'' 
	AND		TaxCode					=			'C01' 
	AND		RateCode				=			'C01' 
	AND		EffectiveFrom			>=			'2022-03-01' 
	AND		EffectiveTo				=			'2022-03-31' 

*/