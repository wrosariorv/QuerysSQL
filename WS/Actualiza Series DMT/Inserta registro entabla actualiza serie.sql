SELECT		*
--DELETE
FROM		WS.[AS].RV_TBL_SIP_ACTUALIZA_SERIE
WHERE		GroupID IN (20)
and			Estado not in ('Pendiente','Validado')


DECLARE @NewGroupID INT;
SET @NewGroupID = NEXT VALUE FOR [AS].RV_TBL_SIP_GROUPID_SEQ;

INSERT INTO [AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 
(GroupID, Company, Plant, PartNum, SerialNumber, WareHouse, BinNum, Letra, SNReference)
VALUES 
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549270', 'STG', 'EMBMAS', NULL, 'DMT-20250312'),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549279', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549276', 'STG', 'EMBMAS', 'D', 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549279W', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549275', 'STG', 'Pepito', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549273', 'STGdsada', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549272', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR11', 'RA5008725549271', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR1w', 'RA5008725549279A', 'STGsda', 'Pepito', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', '5061A-FAOFAR1w', 'RA5008725549279Z', 'STG', 'Pepito', 'X', 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', 'L32S61E-F', 'RT3285346393154', 'STG', 'EMBMAS', 'A', 'DMT-20250312' )

DECLARE @NewGroupID INT;
SET @NewGroupID = NEXT VALUE FOR [AS].RV_TBL_SIP_GROUPID_SEQ;
INSERT INTO [AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 
(GroupID, Company, Plant, PartNum, SerialNumber, WareHouse, BinNum, Letra, SNReference)
VALUES 
(@NewGroupID, 'CO01', 'CDEE', 'CDH-LE504KSMART26-F', 'RF1006360154758', 'STG', 'EMBMAS', NULL, 'DMT-20250312'),
(@NewGroupID, 'CO01', 'CDEE', 'AND50FXUHD-F', 'RO2505846703890', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', 'HSA2500FCECOHI-EF UE', 'RF08287HB285148', 'STG', 'EMBMAS', 'D', 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', 'HSA2500FCECOHI-EF UE', 'RF08287HB285149', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', 'HSA2500FCECOHI-EF UI', 'RF08287HB290910', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', 'HSA2500FCECOHI-EF UI', 'RF08287HB290911', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'CDEE', 'X39SM', 'RO2503316094727', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'Mplace', 'T671E1-FALCAR11', 'RT3371236112553', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'Mplace', 'AND42Y-F', 'RO2506135672200', 'STG', 'EMBMAS', NULL, 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'PER2823', '5102B-FALCAR11', 'RT3357525647621', 'STG', 'EMBMAS', 'A', 'DMT-20250312' ),
(@NewGroupID, 'CO01', 'PER2823', '6159A-FALCAR11', 'RT3372646541816', 'STG', 'EMBMAS', 'A', 'DMT-20250312' )

DECLARE @NewGroupID INT;
SET @NewGroupID = NEXT VALUE FOR [AS].RV_TBL_SIP_GROUPID_SEQ;
--'STGRECEP','EMBMAS'
INSERT INTO [AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 
(GroupID, Company, Plant, PartNum, SerialNumber, WareHouse, BinNum, Letra, SNReference)
SELECT	@NewGroupID, 
		Company, Plant, PartNum, SerialNumber, WareHouse, 'EMBMAS', Letra
		, concat('Prueba Grupo ',@NewGroupID)
FROM	[AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 
WHERE	GroupID=10


TRUNCATE TABLE [AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 

ALTER SEQUENCE [AS].RV_TBL_SIP_GROUPID_SEQ RESTART WITH 1;

--ALTER TABLE [AS].[RV_TBL_SIP_ACTUALIZA_SERIE]  DROP COLUMN [SNStatus]


alter table [AS].[RV_TBL_SIP_ACTUALIZA_SERIE]  ADD  [Detalles] nvarchar(max) null

select * from [AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 

exec [AS].RVF_PRC_SIG_VALIDA_SERIE

begin tran

delete [CORPLAB-DB-01].[WS].[AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 
where GroupID >2

ALTER SEQUENCE [AS].RV_TBL_SIP_GROUPID_SEQ RESTART WITH 11;

rollback tran
commit tran


--/*
ALTER PROCEDURE [AS].[RV_PRC_SEQUENCE]
AS
--*/
SELECT CAST ( NEXT VALUE FOR [AS].RV_TBL_SIP_GROUPID_SEQ as int) AS Valor

GO

EXEC [AS].[RV_PRC_SEQUENCE]


SELECT	 A.company, A.partnum,A.SerialNumber,A.RawSerialNum,A.SNReference,A.WareHouseCode,A.BinNum,A.SNReference,A.Voided,C.CustID,A.CUSTNum,B.Character02,A.SNStatus
		--,CAST(SUBSTRING(SNReference, LEN(SNReference) - CHARINDEX('-', REVERSE(SNReference)) + 2, 11) AS INT) AS TranNum
--*
FROM			[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo			AS A	WITH (NoLock)
INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo_UD			AS B	WITH (NoLock)
ON				a.SysRowID			=			b.ForeignSysRowID
left outer join		[CORPL11-EPIDB].[EpicorERPTest].ERP.Customer			AS c	WITH(NoLock) 
ON				A.Company			=			C.Company
AND				A.CustNum			=			C.CustNum

where			A.SerialNumber in (

			select SerialNumber from [AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 
			where GroupID in ( 7)

)




SELECT 
	A.Company,
	A.PartNum,
	A.SerialNumber,
	A.RawSerialNum,
	A.SNReference,
	A.WareHouseCode,
	A.BinNum,
	A.SNReference,
	A.Voided,
	C.CustID,
	A.CUSTNum,
	B.Character02,
	A.SNStatus
FROM 
	[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo AS A WITH (NOLOCK)
INNER JOIN 
	[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo_UD AS B WITH (NOLOCK)
	ON A.SysRowID = B.ForeignSysRowID
LEFT JOIN 
	[CORPL11-EPIDB].[EpicorERPTest].ERP.Customer AS C WITH (NOLOCK)
	ON A.Company = C.Company 
	AND A.CustNum = C.CustNum
INNER JOIN 
	[WS].[AS].[RV_TBL_SIP_ACTUALIZA_SERIE] AS S WITH (NOLOCK)
	ON A.Company = S.Company
	AND A.PartNum = S.PartNum
	AND A.SerialNumber = S.SerialNumber
WHERE 
	S.GroupID = 20


select * from [CORPL11-EPIDB].[EpicorERPTest].ERP.Plant AS A WITH (NOLOCK)

select * from [AS].[RV_TBL_SIP_ACTUALIZA_SERIE] 
			where GroupID in ( 10)
			AND ESTADO <>'Validado'

update [AS].[RV_TBL_SIP_ACTUALIZA_SERIE]
set estado = 'Pendiente', fechaActualizacion = null
where GroupID=11