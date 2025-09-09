use RVF_Local

--		Outlet --> Character02 (numeros no letras) y WareHouseCode (TRA-REV)
SELECT	company,partnum,SerialNumber,SNReference,WareHouseCode,BinNum,Voided,SNStatus,JobNum,SNFormat,CustNum,SysRowID
--*
FROM			[CORPLAB-EPIDB].[EpicorERP].Erp.SerialNo				WITH(NoLock) 
WHERE	
--Voided = 0 AND  --  0 ok	1 anulado
PartNum IN ('T766J-FALCAR11','6125A-BALCAR11') AND
--Company='CO01' AND 
--SNStatus='INVENTORY' AND  -- SHIPPED	ADJUSTED	INVENTORY
--Warehousecode in ('STG') and -- TRA-REV		STG
--BinNum in ('STGRECEP') and --	STGRECEP	STGDESP		DISPVTA		GENERAL		GR-UFL		DESP-UNF	99-99-99	EMBMAS
--SNReference in ('DMT 20 11 2019') and
SerialNumber like 'RT335620000%'
or 
SerialNumber like 'RT335890000%'

ORDER BY			SerialNumber asc




select			JobNum, TranNum, TranType,TranDocTypeID,WareHouseCode,BinNum,WareHouse2,BinNum2,UM,TranClass,* 
from			[CORPLAB-EPIDB].[EpicorERP].Erp.PartTran
where			Company		=		'CO01'
and				Plant		=		'MfgSys'
and				JobNum		like	'RV000%'
order by 1,2 ASC


select * from RV_TBL_SIP_ITEM_TP
where Estado='Procesando'

--update RV_TBL_SIP_ITEM_TP
--set SNStatus='INVENTORY', Estado='Integrado'
--where 
--TranNum=35

select	*
from	[SIP].dbo.SeriesFabricadas
where
		Company='CO01'
AND		OT='RV000049'
AND		PartNum='T766J-FALCAR11'	
AND		Estado='Pendiente'
AND		Serie in (
'RT3356200001399',
'RT3356200001400',
'RT3356200001401',
'RT3356200001402',
'RT3356200001403',
'RT3356200001404',
'RT3356200001405',
'RT3356200001406',
'RT3356200001407',
'RT3356200001408',
'RT3356200001409',
'RT3356200001410',
'RT3356200001411',
'RT3356200001412',
'RT3356200001413',
'RT3356200001414',
'RT3356200001415',
'RT3356200001416',
'RT3356200001417',
'RT3356200001418',
'RT3356200001419',
'RT3356200001420',
'RT3356200001421',
'RT3356200001422',
'RT3356200001423',
'RT3356200001424',
'RT3356200001425',
'RT3356200001426',
'RT3356200001427',
'RT3356200001428',
'RT3356200001429',
'RT3356200001430',
'RT3356200001431',
'RT3356200001432',
'RT3356200001433',
'RT3356200001434',
'RT3356200001435',
'RT3356200001436',
'RT3356200001437',
'RT3356200001438'


)

p => p.Company == encabezado.Company && p.OT == encabezado.Ot && p.PartNum == encabezado.PartNum && p.Estado == "Pendiente" && serialNumbers.Contains(p.Serie)