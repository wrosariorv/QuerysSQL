/****** Script for SelectTopNRows command from SSMS  ******/
SELECT[idIMEI]
      ,[IMEI]
      ,[MSN]
      ,[Test_Site]
      ,[Test_Bench]
      ,[Slot_Number]
      ,[Test_Mode]
      ,[Start_Time]
      ,[Test_Time]
      ,[Error_Code_Group]
      ,[Error_Index]
      ,[Fecha]
      ,[NombreArchivo]
  FROM [SIP].[dbo].[CIMEI]
  where
  Fecha		>	'2025-09-03 011:42:00.320'
		--CAST(Fecha AS date)>'2025-09-01'

		order by Fecha desc

SELECT [ID]
      ,[NombreArchivo]
      ,[IMEI]
      ,[MSN]
      ,[Fecha]
      ,[Error_Code_Group]
      ,[Error_Index]
  FROM [SIP].[dbo].[CIMEI_Error]
  where 
		Fecha		>	'2025-09-03 011:42:00.320'--'2025-09-02 00:49:51.040'

		order by Fecha desc