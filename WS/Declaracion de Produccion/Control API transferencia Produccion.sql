SELECT *
FROM RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P
WHERE 
--TranNum=39609
		--Estado='Integrado'
		Estado<>'Integrado'
		--CAST(Fecha as date) = '2025-05-30'


SELECT *
FROM RV_TBL_SIP_ITEM_TP
WHERE 
		TranNum=39518
		Estado='Procesando'
WHERE OT='RV000008'
AND		TranNum=145

SELECT *
FROM RV_TBL_SIP_LOG_TP
WHERE OT='RV000008'
AND		TranNum=145

SELECT *
FROM SIP.DBO.SeriesFabricadas
WHERE OT='RV000008'
and		Serie in 
(
		SELECT Serie
		FROM RV_TBL_SIP_ITEM_TP
		WHERE OT='RV000008'
		AND		TranNum=145
)


SELECT *
FROM			SIP.DBO.SeriesFabricadas A
INNER JOIN		RV_TBL_SIP_ITEM_TP	B
ON				A.Company	=	B.Company
AND				A.OT		=	B.OT
AND				A.PartNum	=	B.PartNum
AND				A.Serie		=	B.Serie
WHERE
				A.Estado	<>	'Procesando'
AND				A.OT		=	'RV000008'

Select		A.Company,A.partnum,A.SerialNumber,a.SNReference,A.WareHouseCode,A.BinNum,A.SNReference,A.Voided,SNStatus,A.OrderNum,A.JobNum ,B.IMEI_c
from		[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo				as A
inner join	[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo_UD				as b WITH(NoLock)
ON			A.SysRowID		=			 B.ForeignSysRowID
where		
			/*A.JobNum='RV675001'--'RV650020'--'RV675001'
AND			*/A.SerialNumber in
(
'RT3397710001979',
'RT3397710001980',
'RT3397710001981',
'RT3397710001982'
					--SELECT Serie
					--FROM RV_TBL_SIP_ITEM_TP
					--WHERE OT='RV675001'--'RV650020'--'RV675001'
					--AND		TranNum=39611--39609--39550--39608
					----and		Serie=

)

SELECT 
					*
FROM				[CORPE11-EPIDB].[EpicorERP].Erp.PartTran
WHERE				
									
					TranType		=		'MFG-STK'
AND					JobNum			=		'RV000008'


select company,partnum,SerialNumber,RawSerialNum,SNReference,WareHouseCode,BinNum,SNReference,Voided,SNStatus,OrderNum,PackNum

from

[CORPE11-EPIDB].[EpicorERP].[Erp].SerialNo				SN		WITH(NoLock)

where 

SerialNumber in 
(
'RT3388560198058'

)



SELECT		a.* 
FROM		RV_TBL_SIP_ITEM_TP	A
INNER JOIN	(
				SELECT		*
				FROM		[PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas] SF
				where
							HoraFabricacion  > '2025-05-30 07:00:00'--'2025-05-30 14:00:00'
				--and			Estado='Procesando'
			) AS B
ON			A.Company		=	B.Company
and			A.OT			=	B.OT
AND			A.PartNum		=	B.PartNum
and			A.Serie			=	b.Serie
where		a.Estado='Procesando'

Select		A.Company,A.partnum,A.SerialNumber,a.SNReference,A.WareHouseCode,A.BinNum,A.SNReference,A.Voided,a.SNStatus,A.OrderNum,A.JobNum ,B.IMEI_c,c.TranNum, c.Fecha, C.Estado
from		[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo				as A
inner join	[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo_UD				as b WITH(NoLock)
ON			A.SysRowID		=			 B.ForeignSysRowID
inner join
(

					SELECT		a.* 
					FROM		RV_TBL_SIP_ITEM_TP	A
					INNER JOIN	(
									SELECT		*
									FROM		[PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas] SF
									where
												HoraFabricacion  > '2025-05-30 07:00:00'--'2025-05-30 14:00:00'
									--and			Estado='Procesando'
								) AS B
					ON			A.Company		=	B.Company
					and			A.OT			=	B.OT
					AND			A.PartNum		=	B.PartNum
					and			A.Serie			=	b.Serie
					--where		a.Estado='Integrado'

)	as c
on		a.Company			=			c.Company
and		a.PartNum			=			c.PartNum
and		a.SerialNumber		=			c.Serie
where	c.Estado			=			'Procesando'
and		a.SNStatus			=			'INVENTORY'