SELECT TOP (1000) [Company]
      ,[TranNum]
      ,[PlantaFrom]
      ,[PlantaTo]
      ,[WareHousFrom]
      ,[WareHousTo]
      ,[BinNumFrom]
      ,[BinNumTo]
      ,[Reference]
      ,[Fecha]
  FROM [WS].[TP].[RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_X_PLANTAS]
  where TranNum=51
  
  select * FROM [WS].[TP].RV_TBL_SIP_SERIES_TRANSFERENCIA
  where TranNum=51