
SET DATEFORMAT DMY

/*

SELECT				*
FROM				[CORPEPIDB].EpicorErp.Erp.Customer 
WHERE				Company				=				'CO01'
	AND				CustID				IN				('49614', '49995', '263')

*/

/*

SELECT				*
FROM				[CORPEPIDB].EpicorErp.Erp.TaxExempt					WITH (NoLock) 
WHERE				Company					=				'CO01'
	AND				RelatedToFile			=				'Customer'
	AND				TaxCode					=				'C09'
	AND				Key1					IN				(
															2,133,226,249,372,511,512,622,657,681,930,971,1064,1158,1461,1960,
															4028,4090,6287,6919,7111,7186,7311,74677667,7746,7787,8020,8588,8664
															)
	AND				YEAR(EffectiveFrom)		<=				2021
	AND				MONTH(EffectiveFrom)	<=				11
	AND				(
						(
						YEAR(EffectiveTo)		=				2021
						AND
						MONTH(EffectiveTo)		>=				11
						)
						OR
						(
						YEAR(EffectiveTo)		>				2021
						)
					)

*/

----------------------------------------------------------------------

SELECT				IT.Company, IT.InvoiceNum, IT.InvoiceLine, IT.TaxCode, IT.TaxableAmt, IT.[Percent], IT.TaxAmt, IT.[Manual], IT.ExemptType, 
					IT.ExemptPercent, IT.ResolutionNum, IT.ResolutionDate, 
					IH.LegalNumber, IH.CustNum, IH.InvoiceDate, 
					C.CustNum, C.CustID, C.[Name], 
					TE.TaxCode, TE.EffectiveFrom, TE.EffectiveTo, TE.ExemptType, TE.ExemptPercent, TE.ResolutionNum, TE.ResolutionDate 

FROM				[CORPEPIDB].EpicorErp.Erp.InvcTax					IT					WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcHead					IH					WITH (NoLock)
	ON				IT.Company			=				IH.Company
	AND				IT.InvoiceNum		=				IH.InvoiceNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer					C					WITH (NoLock)
	ON				IH.Company			=				C.Company
	AND				IH.CustNum			=				C.CustNum 

LEFT OUTER JOIN		(
					SELECT				*
					FROM				[CORPEPIDB].EpicorErp.Erp.TaxExempt					WITH (NoLock) 
					WHERE				RelatedToFile			=				'Customer'
						AND				TaxCode					=				'C09'
						AND				(
											(
											YEAR(EffectiveTo)		=				2021
											AND
											MONTH(EffectiveTo)		>=				11
											)
											OR
											(
											YEAR(EffectiveTo)		>				2021
											)
										)
					)		TE																
	ON				TE.Company			=				IH.Company
	AND				TE.Key1				=				IH.CustNum 

WHERE				IT.Company 			=				'CO01'
	AND				IT.TaxCode			=				'C09'
	AND				IH.InvoiceDate		>=				'01/11/2021'

