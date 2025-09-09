

/*********************************************************************************************

Ultima ejecucion: 12/08/2022
Registros encontrados: 89

*********************************************************************************************/

SELECT				QH.Company, QH.QuoteNum, QH.EntryDate, QH.TerritoryID, QH.ActiveTaskID, QH.ReasonType, 
					QD.QuoteLine, QD.PartNum, QD.LineDesc, QD.ProdCode, QD.ListPrice, QD.DiscountPercent 

FROM				[CORPEPIDB].EpicorErp.Erp.QuoteHed				QH			WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.QuoteDtl				QD			WITH(NoLock)
	ON				QH.Company					=				QD.Company
	AND				QH.QuoteNum					=				QD.QuoteNum 

WHERE				QD.DiscountPercent			<				0
ORDER BY			QD.QuoteNum, QD.QuoteLine 

