

SET DATEFORMAT DMY


SELECT				C.Company, C.CustID, C.[Name], 
					TE.TaxCode, TE.RateCode, TE.EffectiveFrom, TE.EffectiveTo, TE.TextCode, TE.ResolutionNum, TE.ResolutionDate 
FROM				[CORPEPIDB].EpicorErp.Erp.TaxExempt				TE			WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer				C			WITH (NoLock)
	ON				C.Company							=						TE.Company
	AND				C.CustNum							=						TE.Key1
WHERE				TE.RelatedToFile					=						'Customer'
	AND				(
					/*
					(
					TE.EffectiveFrom					=						'01/06/2021'
					AND		
					TE.EffectiveTo						<>						'30/06/2021'
					)
					OR
					(
					TE.EffectiveFrom					=						'01/07/2021'
					AND		
					TE.EffectiveTo						<>						'31/07/2021'
					)
					OR
					*/
					(
					TE.EffectiveFrom					=						'01/08/2021'
					AND		
					TE.EffectiveTo						<>						'31/08/2021'
					)
					OR
					(
					TE.EffectiveFrom					=						'01/09/2021'
					AND		
					TE.EffectiveTo						<>						'30/09/2021'
					)
					)
	
	AND				(
					TE.ResolutionNum 					IN						('Padron')
					/*
					OR
					TE.ResolutionNum 					IN						('Convenio Activo')
					*/
					)
ORDER BY			C.Company, C.CustID, C.[Name], TE.TaxCode 

