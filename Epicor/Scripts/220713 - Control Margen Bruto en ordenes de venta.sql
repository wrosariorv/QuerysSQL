
SELECT				TOP 100
					OH.OrderDate, 
					OD.OrderNum, OD.QuoteNum, OD.PartNum, OD.OrderQty, OD.UnitPrice, OD.DiscountPercent, OD.Discount, 
					ODU.Number02										AS Acuerdo, 
					ODU.Number03										AS Costo, 
					ODU.Number04										AS MargenBruto, 
					ODU.Number05										AS PorcentajeMargen, 
					ODU.Number06										AS MontoIngreso, 
					ODU.Number07										AS VentaTotal, 
					ODU.Number08										AS PrecioNegociadoUnitario, 
--					ODU.Number09										AS Number09,  
					ODU.Number10										AS TotalFinanciacion,  
					ODU.Number11										AS TotalAcuerdo  
--					, OD.* 
--					, ODU.*
FROM				[CORPEPIDB].EpicorErp.Erp.OrderDtl				OD
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.OrderHed				OH
	ON				OH.Company			=				OD.Company
	AND				OH.OrderNum			=				OD.OrderNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.OrderDtl_UD			ODU
	ON				OD.SysRowID			=				ODU.ForeignSysRowID
WHERE				OD.PartNum			=				'CDH-LE32SMART19' --'ZTE A7030-B'
	AND				OD.OrderNum			IN				(189227, 189912, 190365, 191978, 193926)
ORDER BY			OD.OrderNum DESC
