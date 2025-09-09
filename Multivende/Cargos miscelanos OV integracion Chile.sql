SET DATEFORMAT dmy
Select 
					Character02,
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
Key3 in ('ML')
AND Date02 >= '2022-09-16'
--Character01 like 'La PO%'
--AND ShortChar17 ='ERR'
--Character02 <>''
--AND Key4 in ('20636943601-A','258385733 ')
--ShortChar17<>'PDO'
--AND Date01 >= '2022-12-31'
AND Number04 <>0

order by 5

--Select * from Erp.OrderHed
--where OrderNum='2583'

--select * from erp.OrderMsc
--where OrderNum='2583'

Select			A.* 
from			Erp.OrderHed	a
Inner Join		Erp.OrderMsc	b
ON				a.Company		=		b.Company
AND				a.OrderNum		=		b.OrderNum
WHERE
A.orderdate >='2022-09-16'


Select			a.* 
from			Erp.OrderHed	a
Inner Join		Erp.OrderMsc	b
ON				a.Company		=		b.Company
AND				a.OrderNum		=		b.OrderNum
WHERE EXISTS	
				(
					SELECT	UD.ShortChar18
					From [EpicorLive11100].[ICE].[UD10]	UD
					where 
					UD.Key3 not in ('ML')
					AND UD.Number04 <>0
					AND	a.OrderNum	=	UD.ShortChar18

				)

Select * from Erp.OrderMsc

/*********************************************************
		Ultima OV con cargo miscelaneo
*********************************************************/
Select			b.* 
from			[EpicorLive11100].Erp.OrderHed	a
Inner Join		[EpicorLive11100].Erp.OrderMsc	b
ON				a.Company		=		b.Company
AND				a.OrderNum		=		b.OrderNum
WHERE EXISTS	
				(
					SELECT	UD.ShortChar18
					From [EpicorLive11100].[ICE].[UD10]	UD
					where 
					UD.Key3 not in ('ML')
					AND UD.Number04 <>0
					AND	a.OrderNum	=	UD.ShortChar18

				)
ORder by 2


/*********************************************************
		Todas las OV con cargo miscelaneo en UD10
*********************************************************/

Select 
					Character02,
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


					From [EpicorLive11100].[ICE].[UD10]	UD
					where 
					UD.Key3 not in ('ML')
					AND UD.Number04 <>0
					ORder by Date01