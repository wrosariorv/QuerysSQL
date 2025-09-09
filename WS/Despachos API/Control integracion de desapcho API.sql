SET DATEFORMAT DMY

--verifica estado de stock
SELECT			PB.Company, W.Plant	, PB.PartNum, PB.WareHouseCode, PB.BinNum, PB.OnHandQty, 								
				W.Plant, 							
				PU.Character02 							
FROM			[CORPL11-EPIDB].[EpicorERPTest].Erp.PartBin			PB					
INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Warehse			W						
	ON			PB.Company			=			W.Company	
	AND			PB.WareHouseCode	=			W.WareHouseCode			
INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Part				P					
	ON			PB.Company			=			P.Company	
	AND			PB.PartNum			=			P.PartNum	
INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Part_UD			PU						
	ON			P.SysRowID			=			PU.ForeignSysRowID	
WHERE			
				P.PartNum			in (
											'C40AND-F'
											--select		B.PartNum
											--from		[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderHed a
											--left join	[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderDTL b
											--on		a.Company	=		b.Company
											--and		a.OrderNum	=		b.OrderNum
											--where	A.OpenOrder=1 
											--and		B.OpenLine=1
											----and		(B.PartNum like '%UE%'
											----or		B.PartNum like '%UI%'
											----)
											----order by OrderNum desc
										)
	AND			PB.Company			in			('CO01')		
	AND			W.Plant				in			('CDEE','MPLACE')
	--AND			W.Plant				in			(/*SERVICE*/'FRA640',/*OUTLET*/ 'PER2823')
	
	AND			(
				PB.WareHouseCode	in			('STG','STG-MPL')
	
	--OR			PB.WareHouseCode	like		'STG%'
				)
	AND			(
				PB.BinNum	=			'STGDESP'
				)
	--AND			P.PartNum			in ('6102A-FALCAR11','5102B-BALCAR11')
	
	


select		top 1000 
			B.OrderLine,b.OpenLine, B.PartNum,A.* 
from		[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderHed a
left join	[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderDTL b
on		a.Company	=		b.Company
and		a.OrderNum	=		b.OrderNum
where	A.OpenOrder=1 
and		B.OpenLine=1
--and		(		B.PartNum like '%UE%'
--		or		B.PartNum like '%UI%'
--)
--and PartNum='C40AND-F'
order by OrderNum desc

--		Outlet --> Character02 (numeros no letras) y WareHouseCode (TRA-REV)
SELECT	company,partnum,SerialNumber,RawSerialNum,SNReference,WareHouseCode,BinNum,SNReference,Voided,SNStatus, OrderNum
--*
FROM			[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo				WITH(NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
--where tfpacknum=4823
WHERE	
Voided = 0 AND  --  0 ok	1 anulado
PartNum IN (
				'C40AND-F'
			) AND
--Company='CO01' AND 
--SNStatus in ('INVENTORY','SHIPPED')AND  -- SHIPPED	ADJUSTED	INVENTORY
SNStatus in ('INVENTORY')AND
Warehousecode in ('STG') and -- TRA-REV		STG
BinNum in ('STGDESP','STGRECEP') and --	STGRECEP	STGDESP		DISPVTA		GENERAL		GR-UFL		DESP-UNF	99-99-99	EMBMAS
--SNReference in ('DMT 20 11 2019') and

--OrderNum in('257881') and
SerialNumber in (
'RO2510774612255',
'RO2510774612256',
'RO2510774612257',
'RO2510774612258'
)
ORDER BY			SerialNumber asc


select		top 1000 
			B.OrderLine, B.OpenLine, B.PartNum,A.* 
from		[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderHed a
left join	[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderDTL b
on		a.Company	=		b.Company
and		a.OrderNum	=		b.OrderNum
where	A.OpenOrder=1
and		B.OpenLine=1
and PartNum='C40AND-F'
--and		(		B.PartNum like '%UE%'
--		or		B.PartNum like '%UI%'
--)
order by OrderNum desc



SELECT	company,partnum,WareHouseCode,BinNum,Voided,SNStatus, OrderNum, COUNT(OrderNum)
--*
FROM			[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo				WITH(NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
--where tfpacknum=4823
WHERE	
Voided = 0 AND  --  0 ok	1 anulado
PartNum IN (
				select			distinct
								B.PartNum
				from		[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderHed a
				inner join	[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderDTL b
				on		a.Company	=		b.Company
				and		a.OrderNum	=		b.OrderNum
				where	A.OpenOrder=1 
			) AND
--Company='CO01' AND 
--SNStatus in ('INVENTORY','SHIPPED')AND  -- SHIPPED	ADJUSTED	INVENTORY
SNStatus in ('INVENTORY')AND
Warehousecode in ('STG') and -- TRA-REV		STG
BinNum in ('STGDESP')

group by company,partnum,WareHouseCode,BinNum,Voided,SNStatus, OrderNum


select * from 

ShipHead.PackNum




SELECT	A.company,A.partnum,A.SerialNumber,A.RawSerialNum,A.SNReference,A.WareHouseCode,A.BinNum,A.SNReference,A.Voided,A.SNStatus, A.OrderNum, B.OpenOrder, B.OpenLine
--*
FROM			[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo				A --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
Right join		(
					select			distinct
									B.Company, A.OrderNum, B.PartNum,A.OpenOrder,B.OpenLine
					from		[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderHed a
					inner join	[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderDTL b
					on		a.Company	=		b.Company
					and		a.OrderNum	=		b.OrderNum
					where	A.OpenOrder=1 
					and		B.OpenLine=1
				) AS B
on			a.Company			= b.Company
and			A.PartNum			= B.PartNum
--where tfpacknum=4823
WHERE	
A.Voided = 0 AND  --  0 ok	1 anulado

--PartNum IN (
				
--			) AND
--Company='CO01' AND 
--SNStatus in ('INVENTORY','SHIPPED')AND  -- SHIPPED	ADJUSTED	INVENTORY
A.SNStatus in ('INVENTORY')AND
A.Warehousecode in ('STG') and -- TRA-REV		STG
A.BinNum in ('STGDESP')


select			
				B.Company, A.OrderNum, B.PartNum,A.OpenOrder,B.OpenLine, C.SerialNumber,C.WareHouseCode,C.BinNum,C.SNStatus
from		[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderHed a
inner join	[CORPL11-EPIDB].[EpicorERPTest].ERP.OrderDTL b
on		a.Company	=		b.Company
and		a.OrderNum	=		b.OrderNum
left join	(
				SELECT	A.company,A.partnum,A.SerialNumber,A.WareHouseCode,A.BinNum,A.Voided,A.SNStatus, A.OrderNum
				--*
				FROM			[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo				A --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
				
				--where tfpacknum=4823
				WHERE	
				A.Voided = 0 AND  --  0 ok	1 anulado				
				A.SNStatus in ('INVENTORY')AND
				A.Warehousecode in ('STG') and -- TRA-REV		STG
				A.BinNum in ('STGDESP')
			) AS C
on			A.Company			= C.Company
AND			B.PartNum		=		C.PartNum
AND			A.OrderNum			=C.OrderNum
where	A.OpenOrder=1 
and		B.OpenLine=1

AND C.SerialNumber is not null