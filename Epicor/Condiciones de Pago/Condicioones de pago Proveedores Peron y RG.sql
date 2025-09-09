select V.Company, V.VendorID, V.[Name],V.TermsCode,* from erp.Vendor  V WITH (NoLock) 
where
TermsCode	=''



SELECT					V.Company, 
						V.VendorID, 
						V.[Name], 
						ISNULL(VA.AttrCode,'')								AS		AttrCode,
						--ISNULL (A.AttrCode,'')								AS		AttrCode, 
						ISNULL(A.AttrDescription,'')						AS		AttrDescription,
						V.TermsCode,
						--PT.[Description],
						ISNULL (PT.[Description],'')						AS		[Description]  
						--,V.* 
FROM					[CORPEPIDB].EpicorERP.[Erp].[Vendor]				V WITH (NoLock) 

LEFT OUTER JOIN			[CORPEPIDB].EpicorERP.[Erp].[VendAttr]				VA WITH (NoLock) 
	ON					V.Company			=			VA.Company
	AND					V.VendorNum			=			VA.VendorNum

LEFT OUTER JOIN			(
							SELECT		Company, AttrCode, AttrDescription
							FROM		[CORPEPIDB].EpicorErp.Erp.Attribut				WITH (NoLock) 
							GROUP BY	Company,AttrCode, AttrDescription

						) AS A
	ON					VA.Company			=			A.Company
	AND					VA.AttrCode			=			A.AttrCode
LEFT OUTER JOIN			[CORPEPIDB].EpicorERP.[Erp].PurTerms					PT
	ON					V.Company			=			PT.Company
	AND					V.TermsCode			=			PT.TermsCode
--[CORPEPIDB].EpicorERP.[Erp].[Attribut]				A WITH (NoLock) 

WHERE					
						V.Inactive			<>			1
--AND						V.Company			=			'CO01'
--ORDER BY 2



Select * from [CORPEPIDB].EpicorERP.[Erp].PurTerms					T
where
TermsCode='00'



--Select			W.VendorID,
--				COUNT(*) AS Repetidos

--FROM			(
					
--					SELECT					V.Company, 
--											V.VendorID, 
--											V.[Name], 
--											A.AttrCode, 
--											A.AttrDescription,
--											V.TermsCode,
--											--PT.[Description],
--											ISNULL (PT.[Description],'') AS [Description]  
--											--,V.* 
--					FROM					[CORPEPIDB].EpicorERP.[Erp].[Vendor]				V WITH (NoLock) 

--					LEFT OUTER JOIN			[CORPEPIDB].EpicorERP.[Erp].[VendAttr]				VA WITH (NoLock) 
--						ON					V.Company			=			VA.Company
--						AND					V.VendorNum			=			VA.VendorNum
--					LEFT OUTER JOIN			[CORPEPIDB].EpicorERP.[Erp].PurTerms					PT
--						ON					V.Company			=			PT.Company
--						AND					V.TermsCode			=			PT.TermsCode
--					INNER JOIN				(
--												SELECT		Company, AttrCode, AttrDescription
--												FROM		[CORPEPIDB].EpicorErp.Erp.Attribut				WITH (NoLock) 
--												GROUP BY	Company,AttrCode, AttrDescription

--											) AS A
--					--[CORPEPIDB].EpicorERP.[Erp].[Attribut]				A WITH (NoLock) 
--						ON					VA.Company			=			A.Company
--						AND					VA.AttrCode			=			A.AttrCode
--					WHERE					
--											V.Inactive			<>			1
--					AND						V.Company			=			'CO03'
----ORDER BY 2

--				) AS W
--GROUP BY		W.VendorID
--HAVING			COUNT(*)>1