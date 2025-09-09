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
WHERE			PB.Company			in			('CO01','CO02','CO03')		
	--AND			W.Plant				in			(/*SERVICE*/'FRA640',/*OUTLET*/ 'PER2823')
	
	AND			(
				PB.WareHouseCode	in			('SJDESV','GR-FRA')
	OR			PB.WareHouseCode	=			'GR-OUT'
	OR			PB.WareHouseCode	like		'OUT-%'
				)
	AND			(
				PB.BinNum	=			'DEPRECT'
	OR			PB.BinNum	=			'99-99-99'
				)
	
	--AND			P.PartNum			in ('6102A-FALCAR11','5102B-BALCAR11')
	
	AND			P.PartNum			in ('6065A1-FAOFAR11','L55P735-F','TS9030','EB-95 NEGRO','KB-90 SLIM')
	--AND			P.PartNum			in	( 
	--										Select		DISTINCT
	--													ID.PartNum

	--										From		[CORPE11-EPIDB].[EpicorERP].Erp.InvcHead             IH      WITH(NoLock)
	--									INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.InvcDtl             ID      WITH(NoLock)
	--										ON          IH.Company              =       ID.Company
	--										AND         IH.InvoiceNum           =       ID.InvoiceNum 
	--									INNER JOIN      [CORPE11-EPIDB].EpicorErp.Erp.Part                   P       WITH(NoLock)
	--										ON          ID.Company              =       P.Company
	--										AND         ID.PartNum              =       P.PartNum
	--										where		P.TrackSerialNum		=		0
	--										AND         IH.Company              =       'CO01'
	--										--AND         IH.InvoiceDate BETWEEN '2023-04-30' AND GETDATE()
	--										AND         ID.PartNum NOT LIKE '%-SK%'
	--										AND         P.ClassID IN ('PTF', 'PTCO', 'SK', 'SKCO', 'REVI', 'REVN')
	
	--									)
	--and			PartNum = 'TS9030'

	--select * from [CORPL11-EPIDB].[EpicorERPTest].Erp.PartBin
	--where	
	--			PArtNum='5102B-BALCAR11'
	--			WareHouseCode =''



--Verifica transfencia realizada
select 
		EntryPerson,TranReference,TranDocTypeID,* from [CORPL11-EPIDB].[EpicorERPTest].ERP.PartTran
where 
			/*EntryPerson='Usr_TRANSFER'
AND			*/SysDate='2025-06-05'--SysDate='2025-04-03'
AND			PartNum			in ('EB-95 NEGRO')
--and PartNum			in ('6065A1-FAOFAR11','L55P735-F','EB-95 NEGRO')
and tranNum>13492282
order by	TranNum, 2 ASC

select * from TP.RV_TBL_SIP_LOG_TRANSFERENCIA_X_PLANTAS
--Verifica estado de la seriey letra
	SELECT	UD.Character02, A.company,A.partnum,A.SerialNumber,A.RawSerialNum,A.SNReference,A.WareHouseCode,A.BinNum,A.SNReference,A.Voided/*,C.CustID*/,A.CUSTNum,A.SNStatus
		--,CAST(SUBSTRING(SNReference, LEN(SNReference) - CHARINDEX('-', REVERSE(SNReference)) + 2, 11) AS INT) AS TranNum
--*
FROM			[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo			AS A	WITH (NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
inner join		[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo_UD			AS UD	WITH (NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
on				A.sysRowID			=			UD.ForeignSysRowID
--inner join		[CORPL11-EPIDB].[EpicorERPTest].ERP.Customer			AS c	WITH(NoLock) 
--ON				A.Company			=			C.Company
--AND				A.CustNum			=			C.CustNum
WHERE	

--A.PartNum			in ('6102A-FALCAR11','5102B-BALCAR11') and 
A.PartNum			 in ('6065A1-FAOFAR11','L55P735-F','TS9030','EB-95 NEGRO','KB-90 SLIM') and
A.Company='CO01' AND 
A.SNStatus='INVENTORY' AND  -- SHIPPED	ADJUSTED	INVENTORY
A.SNReference='TP-FRA640-PER2823-00000000118' AND
A.SerialNumber in (

'RT3286946727014',
'RT3286946725430',
'RT3286946744653',
'RA5014246585192',
'RA5014246579700',
'RA5014256849090'
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
	from		[CORPL11-EPIDB].[EpicorERPTest].Erp.PartWhse			
	where		PartNum			in ('5102B-BALCAR11')
	AND			(
					WareHouseCode	=			'SJDESV'
	OR				WareHouseCode	=			'GR-OUT'
				)

	SELECT		* 
	FROM		[CORPL11-EPIDB].[EpicorERPTest].Erp.PartPlant			
	where		PartNum			in ('5102B-BALCAR11')
	AND			Plant			in ('PER2823','FRA640')
	AND			(
					PrimWhse		=			'SJDESV'
	OR				PrimWhse		=			'GR-OUT'
				)			



	select *  FROM			Erp.PartBin			PB		
	where Company='CO01'
	AND		PartNum			in ('T610P2-FBLCAR11')

	select * from [CORPL11-EPIDB].[EpicorERPTest].ERP.Plant



select --top 1000
		EntryPerson,TranReference,* from [CORPL11-EPIDB].[EpicorERPTest].ERP.PartTran
where /*TranDate='28-10-2022'
AND		*/EntryPerson='Usr_TRANSFER'
--AND			TranReference='CD-MP-00000554'
AND			SysDate='2025-06-11'
order by TranNum, 2 ASC

SET DATEFORMAT DMY
select top 1000 EntryPerson,TranReference,* from [CORPL11-EPIDB].[EpicorERPTest].ERP.PartTran
where TranDate='27-10-2022'

--STK-PLT Despacho
--PLT-STK Re


select top 3000* from [CORPL11-EPIDB].[EpicorERPTest].ERP.PartTran
where PartNum ='TACA-3300FCSA/EL UI'
order by TranDate DESC



select			Company,  EntryPerson,TranReference, PartNum, TranType, SUM(TranQty) AS TotalTrasnferido , WareHouseCode,WareHouse2,BinNum,BinNum2
from			[CORPL11-EPIDB].[EpicorERPTest].ERP.PartTran
where			EntryPerson='Usr_TRANSFER'
AND				TranReference='CD-MP-00000554'
--AND				SysDate='2023-12-28'
Group by		Company,  EntryPerson,TranReference, PartNum, TranType, WareHouseCode,WareHouse2,BinNum,BinNum2




select * from TP.RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_X_PLANTAS
where TranNum>101

select * from TP.RV_TBL_SIP_SERIES_TRANSFERENCIA
where TranNum>101


select * from [CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo
where
	SerialNumber in (

'RT3286946727014',
'RT3286946725430',
'RT3286946744653',
'RA5014246585192',
'RA5014246579700',
'RA5014256849090'
)
	
begin tran
update TP.RV_TBL_SIP_SERIES_TRANSFERENCIA
set Estado='Pendiente'
where TranNum=76

rollback tran