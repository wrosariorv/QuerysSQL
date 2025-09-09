
SELECT					Company, PartNum, SerialNumber, TranNum, TranType, EntryPerson, TranDate, JobNum, WareHouseCode, BinNum, 
						TFPackNum, TFPackLine, SNStatus  
FROM					[CORPEPIDB].EpicorErp.Erp.SNTran					WITH(NoLock)
WHERE					PartNum				=				'T671E1-FALCAR11'
	AND					BinNum				=				'18171H'
	AND					TranType			=				'STK-PLT'
ORDER BY				Company, PartNum, SerialNumber

----------------------------------------

SELECT					TSH.Company, TSH.PackNum, TSH.ShipDate, TSH.Plant, TSH.ToPlant, TSH.LegalNumber, TSH.TranDocTypeID 
FROM					[CORPEPIDB].EpicorErp.Erp.TFShipHead		TSH			WITH(NoLock)
WHERE					TSH.PackNum			=				9928

SELECT					TSD.Company, TSD.PackNum, TSD.PackLine, TSD.PartNum, TSD.LineDesc, TSD.WarehouseCode, TSD.BinNum, TSD.TFOrdLine, TSD.OurStockQty, 
						TSDU.ShortChar02 
FROM					[CORPEPIDB].EpicorErp.Erp.TFShipDtl			TSD			WITH(NoLock)
INNER JOIN				[CORPEPIDB].EpicorErp.Erp.TFShipDtl_UD		TSDU		WITH(NoLock)
	ON					TSD.SysRowID		=				TSDU.ForeignSysRowID
WHERE					TSD.PackNum			=				9928	

----------------------------------------

SELECT					Company, PackNum, ShipDate, CustNum, ShipToNum, LegalNumber, TranDocTypeID  
FROM					[CORPEPIDB].EpicorErp.Erp.MscShpHd						WITH(NoLock)
WHERE					PackNum 			=				6674

SELECT					MSD.Company, MSD.PackNum, MSD.PackLine, MSD.PartNum, MSD.LineDesc, MSD.Plant, MSD.Quantity, 
						MSDU.ShortChar01
FROM					[CORPEPIDB].EpicorErp.Erp.MscShpDt			MSD			WITH(NoLock)
INNER JOIN				[CORPEPIDB].EpicorErp.Erp.MscShpDt_UD		MSDU		WITH(NoLock)
	ON					MSD.SysRowID		=				MSDU.ForeignSysRowID
WHERE					MSD.PackNum 		=				6674

SELECT					Company, Key1, Key2, Key3, Key4, Key5, ShortChar01 
FROM					[CORPEPIDB].EpicorErp.Ice.UD40
WHERE					Key2				=				'6674'
ORDER BY				Company, Key1, Key2, Key3, Key4, Key5 

----------------------------------------