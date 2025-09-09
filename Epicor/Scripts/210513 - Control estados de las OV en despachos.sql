
/*********************************************
Ordenes procesadas en la cola de materiales
*********************************************/

SELECT			PA.Company, PA.PartNum, PA.WareHouseCode, PA.BinNum, PA.OrderNum, PA.OrderLine, PA.OrderRelNum, PA.ReservedQty, PA.AllocatedQty, 
				PA.PickingQty, PA.PickedQty, PA.DistributionType, PA.WaveNum, 
				UD.Key3 
FROM			[CORPEPIDB].EpicorErp.Erp.PartAlloc						PA		WITH(NoLock)
INNER JOIN		(
				SELECT			Company, Key1, Key2, Key3, Key4, Key5, Number01, Number02, Number03 
				FROM			[CORPEPIDB].EpicorErp.Ice.UD110A								WITH(NoLock)
				WHERE			Key1				=				'ViajeCab'
				)			UD
	ON			PA.Company				=				UD.Company
	AND			PA.OrderNum				=				UD.Number01
	AND			PA.OrderLine			=				UD.Number02
	AND			PA.OrderRelNum			=				UD.Number03

WHERE			PA.OrderNum				IN					(144556, 136474, 142509)


SELECT			Company, SysDate, Plant, PartNum, PartDescription, Quantity, TranType, ReferencePrefix, Reference, OrderNum, OrderLiNe, OrderRelNum, 
				WaveNum 
FROM			[CORPEPIDB].EpicorErp.Erp.MtlQueue														WITH(NoLock)
WHERE			OrderNum 				IN					(
															'142509', '142790', '142831', '143278', '144490', 
															'144553', '144553', '144554', '144554', '144556'
															)
	OR			WaveNum					IN					('26618', '26619')


SELECT			Company, WaveNum, OrderNum, OrderLine, OrderRelNum, WaveQty 
FROM			[CORPEPIDB].EpicorErp.Erp.WaveOrder														WITH(NoLock)
WHERE			WaveNum					IN					('26618', '26619')



SELECT			*
FROM			[CORPEPIDB].EpicorErp.Erp.OrderRel						PA		WITH(NoLock)
WHERE			PA.OrderNum				IN					(144556, 136474, 142509)


SELECT			*
FROM			[CORPEPIDB].EpicorErp.Erp.ShipDtl						PA		WITH(NoLock)
WHERE			PA.OrderNum				IN					(144556, 136474, 142509)


SELECT			DocumentPrinted, *
FROM			[CORPEPIDB].EpicorErp.Erp.ShipHead						PA		WITH(NoLock)
WHERE			PA.PackNum				IN					(181321, 180219, 182944)