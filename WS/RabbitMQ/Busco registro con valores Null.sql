SELECT 
        [ID]
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
      ,[JsonResponse]
      ,[Fecha]
      ,[Timestamp]
      ,[ProdCode]
  FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
  WHERE ot IN ('RV288050', 'RV913025', 'RV965011', 'RV680011')
  ORDER BY FechaAlta DESC

 SELECT 
        [ID]
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
      ,[JsonResponse]
      ,[Fecha]
      ,DATEADD(HOUR, -3, DATEADD(SECOND, Fecha, '19700101'))  AS FechaDateTime
      ,[Timestamp]
      ,[ProdCode]
  FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
  where 
  CAST(FechaAlta as date)=  CAST(GETDATE() as date)
  --CAST(FechaAlta as date) between '2025-12-18' and  CAST(GETDATE() as date)
  
  --and OT is null
  AND PseudoLinea is null
  order by FechaDateTime desc


  EXEC RF.[RV_PRC_Datos_OT] 'RV904005'