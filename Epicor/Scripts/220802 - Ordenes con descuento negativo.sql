

/*********************************************************************************************

Ultima ejecucion: 12/08/2022
Registros encontrados: 71

*********************************************************************************************/

SELECT				OH.Company, OH.OrderNum, OH.OrderDate, OH.SalesRepList, OH.OpenOrder, 
					OD.OrderLine, OD.PartNum, OD.LineDesc, OD.ProdCode, OD.UnitPrice, OD.DiscountPercent, 
					ORe.OrderRelNum 

FROM				[CORPEPIDB].EpicorErp.Erp.OrderHed				OH			WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.OrderDtl				OD			WITH(NoLock)
	ON				OH.Company					=				OD.Company
	AND				OH.OrderNum					=				OD.OrderNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.OrderRel				ORe			WITH(NoLock)
	ON				OD.Company					=				ORe.Company
	AND				OD.OrderNum					=				ORe.OrderNum 
	AND				OD.OrderLine				=				ORe.OrderLine 

WHERE				OD.DiscountPercent			<				0
ORDER BY			OD.OrderNum, OD.OrderLine

