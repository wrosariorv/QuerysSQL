

SELECT				P.Company, P.PartNum, P.PartDescription, P.CostMethod, P.ClassID, P.ProdCode, P.TrackLots, 
					PB.OnhandQty								AS		PB_OnhandQty, 
					PFC.OnhandQty								AS		PFC_OnhandQty, 
					PB.OnhandQty - PFC.OnhandQty				AS		Diferencia 

FROM				CORPEPIDB.EpicorErp.Erp.Part					P		WITH(NoLock)

----------------------------------------------------------------------------------------------------------------

INNER JOIN			(
					SELECT				Company, PartNum, LotNum, 
										SUM(OnhandQty)									AS		OnhandQty
					FROM				CORPEPIDB.EpicorErp.Erp.PartBin							WITH(NoLock)
					GROUP BY			Company, PartNum, LotNum  
					)			PB
	ON				P.Company				=				PB.Company
	AND				P.PartNum				=				PB.PartNum 

----------------------------------------------------------------------------------------------------------------

INNER JOIN			(
					SELECT				Company, PartNum, LotNum, 
										SUM(OnhandQty)									AS		OnhandQty
					FROM				CORPEPIDB.EpicorErp.Erp.PartFIFOCost					WITH(NoLock)
					GROUP BY			Company, PartNum, LotNum  
					)			PFC
	ON				P.Company				=				PFC.Company
	AND				P.PartNum				=				PFC.PartNum 
	AND				PB.LotNum				=				PFC.LotNum

----------------------------------------------------------------------------------------------------------------

WHERE				PB.OnhandQty			<>				PFC.OnhandQty


