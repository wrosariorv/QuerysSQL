SET DATEFORMAT DMY

--verifica estado de stock
SELECT			PB.Company, W.Plant	, PB.PartNum, PB.WareHouseCode, PB.BinNum, PB.OnHandQty, 								
				W.Plant, 							
				PU.Character02 							
FROM			[CORPE11-EPIDB].[EpicorERP].Erp.PartBin			PB					
INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.Warehse			W						
	ON			PB.Company			=			W.Company	
	AND			PB.WareHouseCode	=			W.WareHouseCode			
INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.Part				P					
	ON			PB.Company			=			P.Company	
	AND			PB.PartNum			=			P.PartNum	
INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.Part_UD			PU						
	ON			P.SysRowID			=			PU.ForeignSysRowID	
WHERE			PB.Company			in			('CO01','CO02','CO03')		
	AND			W.Plant				in			(/*SERVICE*/'FRA640',/*OUTLET*/ 'PER2823')
	
	AND			(
				PB.WareHouseCode	in			('GR-FRA')
	OR			PB.WareHouseCode	=			'GR-OUT'
	OR			PB.WareHouseCode	like		'OUT-%'
				)
	AND			(
				PB.BinNum	=			'DEPRECT'
	OR			PB.BinNum	=			'99-99-99'
				)
	--AND			P.PartNum			in ('6102A-FALCAR11','5102B-BALCAR11')
	
	AND			P.PartNum			in (
	'HSPE3200FCINV-F UE',
	'HSPE3200FCINV-F UI',

	'K3200FCP-F UE',
	'K3200FCP-F UI',
	'TACA-3100FCSA/TPRO2 INV-F UE',
	'TACA-3100FCSA/TPRO2 INV-F UI'
	)

	SELECT		
				P.PartNum

	FROM		[CORPE11-EPIDB].[EpicorERP].Erp.Part                   P       WITH(NoLock)
													
	WHERE		P.TrackSerialNum		=		0																									
	AND         P.PartNum				NOT LIKE '%-SK%'
	AND         P.ClassID				IN ('REVI'/*,'PTF', 'PTCO', 'SK', 'SKCO',  'REVN','MPI','MPN'*/)

	--select * from [CORPE11-EPIDB].[EpicorERP].Erp.PartBin
	--where	
	--			PArtNum='5102B-BALCAR11'
	--			WareHouseCode =''
--Verifica transfencia realizada
select 
		EntryPerson,TranReference,TranDocTypeID,* from [CORPE11-EPIDB].[EpicorERP].ERP.PartTran
where 
			/*EntryPerson='Usr_TRANSFER'
AND			*/SysDate='2025-04-13'--SysDate='2025-04-03'
--AND			PartNum			in ('6102A-FALCAR11','5102B-BALCAR11')
and PartNum			in ('6065A1-FAOFAR11','L55P735-F')
and tranNum>13492282
order by	TranNum, 2 ASC


--Verifica estado de la seriey letra
	SELECT	UD.Character02, A.company,A.partnum,A.SerialNumber,A.RawSerialNum,A.SNReference,A.WareHouseCode,A.BinNum,A.SNReference,A.Voided,A.CUSTNum,A.SNStatus
		--,CAST(SUBSTRING(SNReference, LEN(SNReference) - CHARINDEX('-', REVERSE(SNReference)) + 2, 11) AS INT) AS TranNum
--*
FROM			[CORPE11-EPIDB].[EpicorERP].ERP.SerialNo			AS A	WITH (NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
inner join		[CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD			AS UD	WITH (NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
on				A.sysRowID			=			UD.ForeignSysRowID


WHERE	

--A.PartNum			in ('6102A-FALCAR11','5102B-BALCAR11') and 
---A.PartNum			 in ('6065A1-FAOFAR11','L55P735-F') and
A.Company='CO01' AND 
--A.SNStatus='INVENTORY' AND  -- SHIPPED	ADJUSTED	INVENTORY

A.SerialNumber in (

'RF11027UI100469',
'RF11027UE123506',
'RK22032UI110490',
'RK22032UE110465',
'RT32365UI109511',
'RT32365UE107501',
'RF11027UI140744',
'RF11027UE113369',
'RT32365UI106782',
'RT32365UE106754',
'RF11027UI123735',
'RF11027UE123651'

)
/*
A.SerialNumber in (

'RT3357600593574',
'RT3357635506208',
'RT3357635506390',
'RT3357635506915',
'RT3378046275471',
'RT3378046365092',
'RT3378046791897'
)

*/


	select		* 
	from		[CORPE11-EPIDB].[EpicorERP].Erp.PartWhse			
	where		PartNum			in ('5102B-BALCAR11')
	AND			(
					WareHouseCode	=			'SJDESV'
	OR				WareHouseCode	=			'GR-OUT'
				)

	SELECT		* 
	FROM		[CORPE11-EPIDB].[EpicorERP].Erp.PartPlant			
	where		PartNum			in ('5102B-BALCAR11')
	AND			Plant			in ('PER2823','FRA640')
	AND			(
					PrimWhse		=			'SJDESV'
	OR				PrimWhse		=			'GR-OUT'
				)			



	select *  FROM			Erp.PartBin			PB		
	where Company='CO01'
	AND		PartNum			in ('T610P2-FBLCAR11')

	select * from [CORPE11-EPIDB].[EpicorERP].ERP.Plant



select --top 1000
		EntryPerson,TranReference,* from [CORPE11-EPIDB].[EpicorERP].ERP.PartTran
where /*TranDate='28-10-2022'
AND		*/EntryPerson='Usr_TRANSFER'
--AND			TranReference='CD-MP-00000554'
--AND			SysDate='2023-12-27'
order by TranNum, 2 ASC

SET DATEFORMAT DMY
select top 1000 EntryPerson,TranReference,* from [CORPE11-EPIDB].[EpicorERP].ERP.PartTran
where TranDate='27-10-2022'

--STK-PLT Despacho
--PLT-STK Re


select top 3000* from [CORPE11-EPIDB].[EpicorERP].ERP.PartTran
where PartNum ='TACA-3300FCSA/EL UI'
order by TranDate DESC



select			Company,  EntryPerson,TranReference, PartNum, TranType, SUM(TranQty) AS TotalTrasnferido , WareHouseCode,WareHouse2,BinNum,BinNum2
from			[CORPE11-EPIDB].[EpicorERP].ERP.PartTran
where			EntryPerson='Usr_TRANSFER'
AND				TranReference='CD-MP-00000554'
--AND				SysDate='2023-12-28'
Group by		Company,  EntryPerson,TranReference, PartNum, TranType, WareHouseCode,WareHouse2,BinNum,BinNum2




select * from TP.RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_X_PLANTAS
where TranNum>83

select * from TP.RV_TBL_SIP_SERIES_TRANSFERENCIA
where TranNum>83

update TP.RV_TBL_SIP_SERIES_TRANSFERENCIA
set Estado='Pendiente'
where TranNum=76


	Select * from [TS].RV_TBL_SIP_TRANSFERENCIA_STOCK


