use EpicorERP

--		Outlet --> Character02 (numeros no letras) y WareHouseCode (TRA-REV)
SELECT	company,partnum,SerialNumber,RawSerialNum,SNReference,WareHouseCode,BinNum,SNReference,Voided,SNStatus,OrderNum
--*
FROM			SerialNo				WITH(NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
--where tfpacknum=4823
WHERE	
--SNReference='CD-MP-00000429'
--Voided = 0 AND  --  0 ok	1 anulado
--PartNum IN ('9317G-2BOFAR1') AND
Company='CO01' AND 
--SNStatus in ('INVENTORY','SHIPPED')AND  -- SHIPPED	ADJUSTED	INVENTORY
--SNStatus in ('INVENTORY')AND
Warehousecode  in ('STG') and -- TRA-REV		STG
--BinNum  in ('STGDESP') and --	STGRECEP	STGDESP		DISPVTA		GENERAL		GR-UFL		DESP-UNF	99-99-99	EMBMAS
--SNReference in ('DMT 20 11 2019') and
 SerialNumber in (--/*
 
 ''
)
ORDER BY			SerialNumber asc



