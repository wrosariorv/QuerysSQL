

SET DATEFORMAT DMY

SELECT				QH.Company, QH.QuoteNum, QH.EntryDate, QH.Reference, QH.TerritoryID, 
					LEFT(QH.TerritoryID, 3)					AS				UnNeg, 
					CASE	
						WHEN	QH.Reference				<>				''
						THEN												'Moviventas'
						ELSE												'Epicor'
					END										AS				Origen, 
					SR.[Name] 
FROM				[CORPEPIDB].EpicorErp.Erp.QuoteHed							QH		WITH(NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.SalesRep							SR		WITH(NoLock)
	ON				QH.Company						=				SR.Company
	AND				QH.TerritoryID					=				SR.SalesRepCode

WHERE				QH.EntryDate					>=				'01/10/2021'
