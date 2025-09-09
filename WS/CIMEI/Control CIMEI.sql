USE [SIP]
GO



/****** Script for SelectTopNRows command from SSMS  ******/
SELECT CheckIMEI,
	[Marca]
      ,[IdModelo]
      ,[ComRef]
      ,[ModeloRV]
      ,[CNCid]
      ,[EAN13]
      ,[EAN14]
      ,[CodProd]
      ,[Nom_Comercial]
      ,[Ruta_Device]
      ,[Ruta_Gift]
      ,[Ruta_Master]
      ,[CantMaster]
      ,[PreSerial]
      ,[Color]
      ,[PesoNeto]
      ,[PesoBruto]
      ,[EANOperador]
      ,[Redes2G]
      ,[FCCid]
      ,[Accesorios]
      ,[Redes4G]
      ,[Redes3G]
      ,[BT_id]
      ,[Activo]
      ,[Rate]
      ,[Operador]
      ,[Produciendo]
      ,[Fabricante]
      ,[Ruta_Series]
      ,[Modelo_etiq]
      ,[CheckIMEI]
      ,[Tipo]
      ,[ClassID]
      ,[ProdCode]
  FROM [SIP].[dbo].[Modelo]
  where ModeloRV='T803E-FBLCAR11'

  select CheckIMEI,* from [SIP].[dbo].[Modelo]
  where CheckIMEI=0

  select		top 1000
				IMEI_1,MSN
				,* 
	from [SIP].[dbo].[HDT]
  where 
  --ComRef ='5033A-FATLAR1'--Tiene IMEI y MSN
  /*ComRef ='T613P1-FALCAR11'
  AND */IMEI_1='356502470177531'

    select		top 1000
				IMEI_1,MSN
				,* 
	from [SIP].[dbo].[HDT]
  where 
  --ComRef ='5033A-FATLAR1'--Tiene IMEI y MSN
  IMEI_1 =''
  or
  IMEI_1 =null
  begin tran
--alter table [dbo].[CIMEI] add [NombreArchivo] nvarchar(max) not null default ''
--alter table [dbo].[CIMEI] drop column [NombreArchivo]

commit tran
rollback tran

 
select		 * 
from		[dbo].[CIMEI]
where		
			--IMEI='358626843207309'
		--Fecha between '2024-11-27 12:57:24.000' and '2024-11-27 15:55:18.000'
			--CAST(Fecha as date) >'2024-11-26'
			Fecha  > '2024-12-27 7:40:00'
order by Fecha

select * from [dbo].[CIMEI_Error]
where		Fecha  > '2024-12-27 7:40:00'
--and NombreArchivo ='HDT2#XXXXXXXXXXXXXXXXXXX##CIMEI01L220240826(120319)#5#10.8.7.RPT'
order by IMEI desc


select	
		--LTRIM(SUBSTRING(Descripcion, 
  --         CHARINDEX('El archivo ', Descripcion) + LEN('El archivo '),
  --         CHARINDEX(' ya existe', Descripcion) - (CHARINDEX('El archivo ', Descripcion) + LEN('El archivo '))
		--	)) AS NombreArchivo,
		* 
from	dbo.RV_TBL_SIP_LOG
where 
		Fecha  > '2024-12-27 7:40:00'
		
		--and Codigo in ('COD:PA020','COD:PA021')
--delete from		[dbo].[CIMEI_test]
--where		CAST(Fecha as date) ='2024-11-27'
------and idIMEI=448033

/*
DELETE dbo.RV_TBL_SIP_LOG
where 
		Fecha  > '2024-12-27 7:40:00'
		and Codigo in ('COD:PA011')
*/

select * from [dbo].[CIMEI_Error]
where		Fecha  > '2024-12-16 09:00:00'
order by IMEI desc

select	LTRIM(SUBSTRING(Descripcion, 
           CHARINDEX('El archivo ', Descripcion) + LEN('El archivo '),
           CHARINDEX(' ya existe', Descripcion) - (CHARINDEX('El archivo ', Descripcion) + LEN('El archivo '))
			)) AS NombreArchivo,
		* 
from	dbo.RV_TBL_SIP_LOG
where 
		CAST(Fecha as date) between '2024-12-16' and GETDATE()
and Codigo='COD:PA017'
order by Fecha desc

SELECT *
FROM dbo.RV_TBL_SIP_LOG
where
CAST(Fecha as date) between '2024-12-16' and GETDATE()
and Estado in ('WARNING','ERROR')
and Codigo = 'COD:PA017'
SELECT *
FROM dbo.RV_TBL_SIP_LOG
WHERE 
    Estado = 'ERROR'
    OR (
        Estado = 'WARNING' 
        AND Codigo = 'COD:PA017'
        AND (
            SELECT COUNT(*) 
            FROM dbo.RV_TBL_SIP_LOG
            WHERE Codigo = 'COD:PA017' AND Estado = 'WARNING'
        ) > 100
    );

select NombreArchivo, COUNT(*) as Total
from (
			select	LTRIM(SUBSTRING(Descripcion, 
					   CHARINDEX('El archivo ', Descripcion) + LEN('El archivo '),
					   CHARINDEX(' ya existe', Descripcion) - (CHARINDEX('El archivo ', Descripcion) + LEN('El archivo '))
						)) AS NombreArchivo,
						Fecha
		
			from	dbo.RV_TBL_SIP_LOG
			where 
					CAST(Fecha as date) between '2024-12-12' and '2024-12-16'
			and Codigo='COD:PA017'
			order by Fecha desc
		) W
Group by NombreArchivo

--delete from [dbo].[CIMEI_Error]
--where		CAST(Fecha as date) ='2024-11-27'



--sp_who2
select top 1000* from  dbo.HDT
where imei_1='358453341314960'


select	* 
from	dbo.RV_TBL_SIP_LOG
where 
		CAST(Fecha as date) >'2024-12-10'
--and		Codigo='COD:PA014'--'COD:PA001'
order by Fecha desc

select Codigo
from	dbo.RV_TBL_SIP_LOG
where 
		CAST(Fecha as date) >'2024-12-02'
--and		Codigo='COD:PA011'
group by Codigo


--delete from	dbo.RV_TBL_SIP_LOG
--where 
--		CAST (Fecha as date)='2024-11-15'
--and Estado ='WARNING'

select 
		Tabla,
		COUNT(*) Registros,
		CASE
			WHEN COUNT(*) > 1 THEN DATEDIFF(MINUTE, MIN(Fecha), MAX(Fecha))
			ELSE 0 
		END AS Minutos,
   
		CASE 
			WHEN COUNT(*) > 1 THEN CAST(DATEDIFF(SECOND, MIN(Fecha), MAX(Fecha)) AS DECIMAL(10,2)) / (COUNT(*) )
			ELSE 0 
		END AS SegundosPorArchivo

from (

SELECT 
    'CIMEI' AS Tabla,
    --COUNT(*) AS Registros,
	Fecha
	--CASE
	--	WHEN COUNT(*) > 1 THEN DATEDIFF(MINUTE, MIN(Fecha), MAX(Fecha))
 --       ELSE 0 
	--END AS Minutos,
   
 --   CASE 
 --       WHEN COUNT(*) > 1 THEN CAST(DATEDIFF(SECOND, MIN(Fecha), MAX(Fecha)) AS DECIMAL(10,2)) / (COUNT(*) )
 --       ELSE 0 
 --   END AS SegundosPorArchivo
FROM 
    [dbo].[CIMEI_TEST]
WHERE 
    --CAST(Fecha AS date) = '2024-12-12'
	Fecha  > '2024-12-16 09:00:00'

UNION ALL

SELECT 
    'CIMEI_Error' AS Tabla,
    --COUNT(*) AS Registros,
	Fecha
	--CASE
	--	WHEN COUNT(*) > 1 THEN DATEDIFF(MINUTE, MIN(Fecha), MAX(Fecha))
 --       ELSE 0 
	--END AS Minutos,
   
 --   CASE 
 --       WHEN COUNT(*) > 1 THEN CAST(DATEDIFF(SECOND, MIN(Fecha), MAX(Fecha)) AS DECIMAL(10,2)) / (COUNT(*) )
 --       ELSE 0 
 --   END AS SegundosPorArchivo
FROM 
    [dbo].[CIMEI_Error]
WHERE 
    --CAST(Fecha AS date) = '2024-12-12'
	Fecha  > '2024-12-16 09:00:00'
	) W
	group by W.Tabla




--truncate table [dbo].[CIMEI_Error]