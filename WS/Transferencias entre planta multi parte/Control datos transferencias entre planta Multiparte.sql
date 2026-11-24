DBCC CHECKIDENT ('TP.RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_X_PLANTAS', RESEED, 6);

select * from [CORPLAB-DB-01].[WS].[TP].[RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_X_PLANTAS]

select * from [CORPLAB-DB-01].[WS].[TP].[RV_TBL_SIP_SERIES_TRANSFERENCIA]


--Consulta las transacciones de sctock realizadas
select 
		EntryPerson,TranReference,* from [CORPE11-EPIDB].[EpicorERP].ERP.PartTran
where 
			EntryPerson='Usr_TRANSFER'
AND			SysDate='2026-08-5'
--AND			PartNum			in ('6102A-FALCAR11','5102B-BALCAR11')

and TranReference='TP-FRA640-PER2823-00000000051'
order by	TranNum, 2 ASC

begin tran

delete from [TP].[RV_TBL_SIP_SERIES_TRANSFERENCIA]
where TranNum not in (1,2,3,4,5,6)

delete from  [TP].[RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_X_PLANTAS]

where TranNum not in (1,2,3,4,5,6)


commit tran
Rollback tran

[CORPSQLMULT2019].[PCDB]


SELECT	A.company,A.partnum,A.SerialNumber,A.RawSerialNum,A.SNReference,A.WareHouseCode,A.BinNum,A.SNReference,A.Voided,C.CustID,A.CUSTNum,A.SNStatus,
		CAST(SUBSTRING(SNReference, LEN(SNReference) - CHARINDEX('-', REVERSE(SNReference)) + 2, 11) AS INT) AS TranNum
--*
FROM			[CORPE11-EPIDB].[EpicorERP].ERP.SerialNo			AS A	WITH (NoLock) --EpicorBD.Epicor905.dbo.SerialNo				WITH(NoLock)
inner join		[CORPE11-EPIDB].[EpicorERP].ERP.Customer			AS c	WITH(NoLock) 
ON				A.Company			=			C.Company
AND				A.CustNum			=			C.CustNum
--where tfpacknum=4823
WHERE	


--Voided = 0 AND  --  0 ok	1 anulado
--A.PartNum			in ('6102A-FALCAR11','5102B-BALCAR11','TACA-5300FCSA/ELINV UE','TACA-5300FCSA/ELINV UI','KX5100FC UE','KX5100FC UI') and 
A.Company='CO01' AND 
A.SNStatus='INVENTORY' AND  -- SHIPPED	ADJUSTED	INVENTORY
--A.Warehousecode in ('SJDESV') and -- TRA-REV		STG
--A.BinNum in ('DEPRECT')and --	STGRECEP	STGDESP		DISPVTA		GENERAL		GR-UFL		DESP-UNF	99-99-99	EMBMAS

A.SerialNumber in (

'RF11021UE137250',
'RF11021UI139761',
'RF11028UE114312',
'RF11028UE115937',
'RF11028UI114010',
'RF11028UI117951',
'RF11037UE103986',
'RF11037UI104343',
'RO23106UE100958',
'RO23106UI101028'

)


				