SELECT
								DISTINCT 
								PO.Company, PO.ORDERNUM, PO.ORderLine, PO.orderLine, PO.ORderRelNum, PO.WareHouseCode, PO.BinNum

FROM							CORPEPIDB.EpicorErp.Erp.PickedOrders PO WITH(NoLock)
INNER JOIN						CORPEPIDB.EpicorErp.Erp.Customer C WITH(NoLock)
	ON							PO.Company		=		C.Company
	AND							PO.CustNum		=		 C.CustNum
INNER JOIN						CORPEPIDB.EpicorErp.Erp.OrderHed OH WITH(NoLock)
	ON							PO.Company		=		OH.Company
	AND							PO.OrderNum		=		OH.OrderNum
INNER JOIN						CORPEPIDB.EpicorErp.Erp.OrderDtl OD WITH(NoLock)
	ON							PO.Company		=		OD.Company
	AND							PO.OrderNum		=		OD.OrderNum
	AND							PO.OrderLine	=		OD.OrderLine
INNER JOIN						CORPEPIDB.EpicorErp.Erp.Part P WITH(NoLock)
	ON							PO.Company		=		P.Company
	AND							PO.PartNum		=		P.PartNum
INNER JOIN						CORPEPIDB.EpicorErp.Erp.PartPlant PP WITH(NoLock)
	ON							PO.Company		=		PP.Company
	AND							PO.PartNum		=		PP.PartNum
	AND							PO.Plant		=		PP.Plant
INNER JOIN						CORPEPIDB.EpicorErp.Erp.PlantWhse PW WITH(NoLock)
	ON				 			PO.Company		=		PW.Company
	AND							PO.PartNum		=		PW.PartNum
	AND							PO.Plant		=		PW.Plant
	AND							PO.WareHouseCode =		PW.WareHouseCode
INNER JOIN						CORPEPIDB.EpicorErp.Erp.Company Co WITH(NoLock)
	ON							PO.Company		=		Co.Company
INNER JOIN						CORPEPIDB.EpicorErp.Erp.Plant Pl WITH(NoLock)
	ON							PO.Company		=		Pl.Company
	AND							PO.Plant		=		Pl.Plant
----------------------------------------------------------------------
INNER JOIN						CORPEPIDB.EpicorErp.Erp.PlantConfCtrl PCC
	ON							PO.Company		=		PCC.Company
	AND							PO.Plant		=		PCC.Plant
----------------------------------------------------------------------
WHERE							PO.OrderNum		 =		 '158619'

