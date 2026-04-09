select top 1000 * from RV_TBL_SIP_LOG_TP
where Estado<>'Completado'
order by [Fecha] desc

select top 1000 * from [TP].RV_TBL_SIP_LOG_TRANSFERENCIA_X_PLANTAS
order by [Fecha] desc


SELECT *
  FROM [WS].[dbo].[RV_VW_SIP_OT_SERIES_PENDIENTES]

  SELECT * FROM [RF].RV_TBL_SIP_RFID_SERIE

  select * 
  --delete
  from [WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P 
  where
            Estado<>'Integrado'
  order by TranNum desc
  

--  select *  from [WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P 
--WHERE TranNum NOT IN (SELECT TranNum FROM RV_TBL_SIP_ITEM_TP)

  SELECT * 
  --DELETE
  FROM RV_TBL_SIP_ITEM_TP
  where
            Serie in (
            'RT3297410002446',
'RT3297410002439',
'RT3297410002447',
'RT3297410002445',
'RT3297410002442',
'RT3297410002443',
'RT3297410002444',
'RT3297410002441',
'RT3297410002440',
'RT3297410002448'
            )
            Estado<>'Integrado'
  order by TranNum desc

  select * from [PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas]
  where Serie  in (
    SELECT Serie   
    FROM RV_TBL_SIP_ITEM_TP
    where [TranNum] Between 52997 and 53005
  )

  SELECT 
       *
  FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
  WHERE SerialNumber in (
            'RT3297410002446',
'RT3297410002439',
'RT3297410002447',
'RT3297410002445',
'RT3297410002442',
'RT3297410002443',
'RT3297410002444',
'RT3297410002441',
'RT3297410002440',
'RT3297410002448'
            )
    SELECT Serie   
    FROM RV_TBL_SIP_ITEM_TP
    where TranNum in (52677)
  )
  ORDER BY FechaAlta DESC

  --update [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
  --SET Estado='Procesando'
  --WHERE ot IN ('RV288050')

  select * from [WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P 
  where OT IN ('RV288050')

SELECT * FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
where
        SerialNumber in (

                          SELECT Serie FROM RV_TBL_SIP_ITEM_TP

                          WHERE [TranNum] Between 52997 and 53005

                        )


  select * from [WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P 
WHERE TranNum = 174

  SELECT * FROM RV_TBL_SIP_ITEM_TP

                          WHERE TranNum = 174

SELECT          UD. imei_c, SN.company,SN.partnum,SN.SerialNumber,SN.SNReference,SN.WareHouseCode,SN.BinNum,SN.SNReference,SN.Voided,SN.SNStatus,SN.OrderNum
FROM			[CORPE11-EPIDB].[EpicorERP].erp.SerialNo    SN WITH (NOLOCK)
LEFT JOIN      [CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD     UD WITH (NOLOCK)
      ON            SN.SysRowID        =             UD.ForeignSysRowID
INNER JOIN      (
                    SELECT Company, PartNum, TranNum, Serie 
                    
                    FROM RV_TBL_SIP_ITEM_TP

                    WHERE [TranNum] Between 52997 and 53005
                ) AS W
ON              SN.Company          =           W.Company
ANd             SN.PartNum          =           W.PartNum
AND             SN.SerialNumber            =           W.Serie
where 
        /*Company ='CO01'
        AND PartNum = '55C655A-F'
        AND*/ SN.SerialNumber in ('RT3297410001687','RT3297410001690')
        
        (SELECT Serie   
    FROM RV_TBL_SIP_ITEM_TP
    where TranNum in (52677))

-- Esto ahora debería borrar también los items
--DELETE FROM dbo.RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P
WHERE TranNum in (180,179);

EXEC RV_PRC_SIP_ENCABEZADO_ITEM_PENDIENTE


select  [ID]
      ,[Company]
      ,[OT]
      ,[PartNum]
      ,[ClassID]
      ,[SerialNumber]
      ,[ItemTag]
      ,[PseudoLinea]
      ,[ItemNumeroSerie]
      ,[Estado]
      ,[FechaAlta]
      , DATEADD(HOUR, -3, DATEADD(SECOND, Fecha, '19700101')) AS FechaUTC
      ,[JsonResponse]
      ,[Fecha]
      ,[Timestamp]
      ,[ProdCode]
        
from    RF.RV_TBL_SIP_RFID_SERIE
where
        CAST(FechaAlta as DATE) = CAST (GETDATE() as DATE)
AND     Estado='ERROR'
--AND     [OT] is null
AND     PseudoLinea is null

select ProdCode,* from [CORPE11-EPIDB].[EpicorERP].Erp.Part
where
PartNum='6125A-BALCAR11'

EXEC sp_rename 'RV_TBL_SIP_LOG_TP.JsonData', 'JsonRequest', 'COLUMN';

alter table [dbo].[RV_TBL_SIP_LOG_TP] add [JsonResponse] [nvarchar](max) NULL




SELECT Company, OT, PartNum,SerialNumber, PseudoLinea, estado
,Count(*) as Catidad

FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]

where PseudoLinea  in ('TV1','TV2','TV3','TV4','AAUI1')

Group by Company, OT, PartNum,SerialNumber, PseudoLinea, estado

having Count(*)>1

SELECT *
FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE] AS t1
WHERE PseudoLinea in ('TV1','TV2','TV3','TV4','AAUI1')
  AND FechaAlta < (
      SELECT MAX(FechaAlta)
      FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE] AS t2
      WHERE t1.Company = t2.Company
        AND t1.OT = t2.OT
        AND t1.PartNum = t2.PartNum
        AND t1.SerialNumber = t2.SerialNumber
        AND t1.PseudoLinea = t2.PseudoLinea
        AND t1.estado = t2.estado
  );


  select A.Estado, B.Estado, A.* from [WS].[RF].[RV_TBL_SIP_RFID_SERIE] A
inner join RV_TBL_SIP_ITEM_TP b
ON		A.Company		= b.Company
AND		A.PartNum		=		B.PartNum
AND		A.SerialNumber	=		B.Serie
where 
		B.Estado	='Integrado'
--and		a.Estado	<> B.Estado 



SELECT      B.Estado, A.Estado, B.* 
FROM        RV_TBL_SIP_ITEM_TP AS A
RIGHT JOIN (

				SELECT * FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
				where 
				Estado	='Integrado'

			) as B
ON		B.Company		=		A.Company
AND		B.PartNum		=		A.PartNum
AND		B.SerialNumber	=		A.Serie
WHERE
		PseudoLinea<>'TVERROR'

SELECT      B.Estado, A.Estado, B.* 
FROM        RV_TBL_SIP_ITEM_TP AS A
INNER JOIN   (

				SELECT * FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
				--where 
				--Estado	='Integrado'

			) as B
ON		B.Company		=		A.Company
AND		B.PartNum		=		A.PartNum
AND		B.SerialNumber	=		A.Serie
WHERE
		PseudoLinea     <>      'TVERROR'
AND     A.Estado        =       'Integrado'
AND     A.Estado        <>      B.Estado
