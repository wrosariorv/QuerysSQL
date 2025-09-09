
SELECT				P.Company, P.PartNum, P.SearchWord, P.PartDescription, P.ClassID, P.ProdCode, 
					PL.WarehouseCode, PL.Plant, PL.OnHandQty, 
					ISNULL(PS.ConvFactor, 0)					AS		PS_ConvFactor, 
					ISNULL(PT.ConvFactor, 0)					AS		PT_ConvFactor
FROM				[CORPEPIDB].EpicorErp.Erp.Part						P	
INNER JOIN			(
					SELECT				PB.Company, PB.PartNum, PB.WarehouseCode, 
										SUM(OnHandQty)										AS		OnHandQty, 
										PW.Plant 
					FROM				[CORPEPIDB].EpicorErp.Erp.PartBin					PB				WITH(NoLock)
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.WareHse					PW				WITH(NoLock)
						ON				PB.Company			=				PW.Company
						AND				PB.WarehouseCode	=				PW.WarehouseCode
					WHERE				PW.Plant			IN				('CDEE', 'MPlace')
					GROUP BY			PB.Company, PB.PartNum, PB.WarehouseCode, PW.Plant 
					)	PL
	ON				P.Company			=				PL.Company
	AND				P.PartNum 			=				PL.PartNum
LEFT OUTER	JOIN	(
					SELECT				Company, PartNum, UOMCode, ConvFactor 
					FROM				[CORPEPIDB].EpicorErp.Erp.PartUOM		
					WHERE				UOMCode				IN				('PS')
						AND				ConvFactor			<>				0
					)	PS
	ON				P.Company			=				PS.Company
	AND				P.PartNum 			=				PS.PartNum
LEFT OUTER	JOIN	(
					SELECT				Company, PartNum, UOMCode, ConvFactor 
					FROM				[CORPEPIDB].EpicorErp.Erp.PartUOM		
					WHERE				UOMCode				IN				('PT')
						AND				ConvFactor			<>				0
					)	PT
	ON				P.Company			=				PT.Company
	AND				P.PartNum 			=				PT.PartNum

ORDER BY			PL.Company, PL.Plant, PL.WarehouseCode, P.ProdCode, P.PartNum

