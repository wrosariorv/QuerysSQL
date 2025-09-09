SET DATEFORMAT dmy
Select 
					Convert (DATETIMEOFFSET,SUBSTRING (Character01,1,24),103) AS [FechaLog],
					Date01			AS FechaVenta,
					Key4			AS NumeroOC,
					Company,
					Key1			AS ProjectID,
					Key2			AS ID,
					Number05		AS GroupID,
					Key3			AS CanalEntrada,
					Key4			AS NumeroOC,
					Key5			AS NumeroDocumento,
					Character01		AS [Log],
					Date02			AS FechaAltaOV,
					ShortChar17		AS Estado,
					ShortChar18		AS NumeroOV,
					CheckBox02		AS Integrado,
					CheckBox03		AS IntegradoRV,
					ShortChar01		AS Nombre,
					ShortChar02		AS Domicilio,
					ShortChar03		AS Ciudad,
					ShortChar05		AS CP,
					ShortChar06		AS CodigoProvincia,
					ShortChar07		AS Entrega_Nombre,
					ShortChar08		AS Entrega_Domicilio1,
					ShortChar09		AS Entrega_Domicili2,
					ShortChar10		AS Entrega_Domicilio3,
					ShortChar11		AS Entrega_Ciudad,
					ShortChar12		AS Entrega_Provincia,
					ShortChar13		AS Entrega_CP,
					ShortChar14		AS Entrega_documento,
					ShortChar15		AS Comentario,
					Date01			AS FechaVenta,
					Number01		AS Linea,
					ShortChar16		AS CodigoProducto,
					Number02		AS Cantidad,
					Number03		AS PrecioUnitario,
					CheckBox01		AS RequiereFactura,
					Number04		AS CostoEnvio,
					ShortChar19		AS CustNum


From [EpicorLive11100].[ICE].[UD10]	
where 
--Key4 in ('2000003645968004','2000003645961966')
--ShortChar17<>'PDO'
Date01 between '2022-05-30' and '2022-06-03'
AND Convert (date,SUBSTRING (Character01,1,9),103) != Date01

order by Key4 ASC

set DATEFORMAT dmy
Select 
					Convert (DATETIMEOFFSET,SUBSTRING (Character01,1,24),103) AS [FechaLog],
					SUBSTRING (Character01,1,24),
					Date01			AS FechaVenta,
					Convert (date ,Date01, 103	)		AS FechaVenta
					--CAST (SUBSTRING (Character01,1,8) AS datetime2)

From [EpicorLive11100].[ICE].[UD10]