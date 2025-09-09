select * from erp.LaborDtl
where JobNum in (
'RV000011',
'RV000012',
'RV000013',
'RV000014',
'RV000016',
'RV000021',
'RV000022',
'RV000023',
'RV000024'
)

SELECT PartNum,ProdQty,* FROM ERP.JobProd
WHERE PartnUM='T766J-FALCAR11'
AND JobNum in (
'RV000011',
'RV000012',
'RV000013',
'RV000014',
'RV000016',
'RV000021',
'RV000022',
'RV000023',
'RV000024'
)

SELECT JobEngineered,JobReleased,* FROM ERP.JobHead
WHERE PartnUM='T766J-FALCAR11'
AND JobNum in (
'RV000011',
'RV000012',
'RV000013',
'RV000014',
'RV000016',
'RV000021',
'RV000022',
'RV000023',
'RV000024',
'RV137001'
)

SELECT JobComplete,AssemblySeq,* FROM ERP.JobAsmbl
WHERE PartnUM='T766J-FALCAR11'
AND JobNum in (
'RV000011',
'RV000012',
'RV000013',
'RV000014',
'RV000016',
'RV000021',
'RV000022',
'RV000023',
'RV000024',
'RV137001'
)

SELECT			Company,MtlSeq,IssuedComplete,* 
FROM			ERP.JobMtl 
WHERE			JobNum in (
'RV000011',
'RV000012',
'RV000013',
'RV000014',
'RV000016',
'RV000021',
'RV000022',
'RV000023',
'RV000024'
)


select TranType,JobNum, TranDocTypeID,WareHouseCode,BinNum,WareHouse2,BinNum2,UM,TranClass,TranType,MtlUnitCost,LbrUnitCost,BurUnitCost,SubUnitCost,MtlBurUnitCost,ExtCost,CostMethod,AssemblySeq,JobSeqType,JobSeq,
ActTranQty,ActTransUOM,InvtyUOM,InvtyUOM2,FIFOAction,FiscalYearSuffix,* from Erp.PartTran
where Company='CO01'
and Plant='MfgSys'
and JobNum in ('RV000012',
'RV000013',
'RV000014',
'RV000015',
'RV000016',
'RV000019',
'RV000021',
'RV000022'
)
order by 2 ASC

select JobNum,ActTranQty,ActTransUOM,InvtyUOM,InvtyUOM2,FIFOAction,FiscalYearSuffix,FiscalYearSuffix,FiscalCalendarID,BinType,CCYear,* from Erp.PartTran
where Company='CO01'
and Plant='MfgSys'
and JobNum in ('RV000012',
'RV000013',
'RV000014',
'RV000015',
'RV000016',
'RV000019'
)
order by 1 ASC

SELECT --SNMask,SNFormat,SNPrefix,SNBaseNumber,XRefPartNum,XRefPartType,SNMask,*
			company,partnum,SerialNumber,RawSerialNum,SNReference,WareHouseCode,BinNum,SNReference,Voided,SNStatus,JobNum,SNPrefix,CustNum,
			Scrapped
FROM			erp.SerialNo
where
PartNum='T766J-FALCAR11' AND
SerialNumber in (
'RT3356200000012',
'RT3356200000011'
)

select top 10* from erp.SNTran
where partnum='T766J-FALCAR11'
AND
SerialNumber in (
'RT3356200000012',
'RT3356200000011'
)

select b.* from sys.all_columns a
inner join sys.objects b
ON a.[object_id]=b.[object_id]
and a.[object_id]=b.[object_id]
where A.name like '%XRefPartNum%'

select * from sys.objects
where object_id=510623791

select *from erp.Warehse
where
WarehouseCode in ('AP','ALE')

select * from erp.WhseBin
where
Company='CO01'
and WarehouseCode in ('AP','ALE')
AND BinNum IN ('EF CEL 1','99-99-99')

select * from erp.Plant
where
Plant='MfgSys'
WareHouseCode	BinNum	WareHouse2	BinNum2
AP	99-99-99	ALE	EF CEL 1

/*Verifico el IMEI grabado en la tabla SerialNo_UD*/


SELECT TOP (1000) A.[Company]
      ,A.[OT]
      ,A.[TranNum]
      ,A.[Linea]
      ,A.[PartNum]
      ,A.[Serie]
	  ,sn.[SerialNumber]
      ,A.[HoraFabricacion]
      ,A.[Fecha]
      ,A.[Voided]
      ,A.[SNStatus]
      ,A.[Estado]
	  ,UD.[imei_c]
  FROM [WS].[dbo].[RV_TBL_SIP_ITEM_TP] A
	
  INNER JOIN [CORPE11-EPIDB].[EpicorERP].Erp.SerialNo							SN		WITH(NoLock)
	ON				SN.Company					=						A.Company
	AND				SN.PartNum					=						A.PartNum																			
	AND				SN.SerialNumber				=						A.Serie
LEFT JOIN		[CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD								UD		WITH (NoLock)
	ON				SN.SysRowID			=			UD.ForeignSysRowID
  where			A.TranNum='41760'

  select * from RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P
  where 
  Estado<>'Integrado'
  TranNum=41760

  select * from [WS].[dbo].[RV_TBL_SIP_ITEM_TP]
  where TranNum=41760


  

  SELECT		
			*
FROM		[PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas]
WHERE		Serie in (

select Serie from [WS].[dbo].[RV_TBL_SIP_ITEM_TP]
  where TranNum=41760
)

select * from RV_TBL_SIP_LOG_TP
 WHERE cast(Fecha AS date)  = CAST(GETDATE() AS date) 