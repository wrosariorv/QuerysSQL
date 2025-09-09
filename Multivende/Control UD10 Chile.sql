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
--Character01 like 'La PO%'
-- ShortChar17 ='PDT'
/*Character02 <>''
AND*/ /*Key4 in ('2000005411580582')
--AND ShortChar18='6899'
--ShortChar17<>'PDO'
AND */--Date01 >= '2024-06-11'
Key4 in ('22720028601-A','22717674802-A')
order by 1


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


From [EpicorPilot11100].[ICE].[UD10]	
where 

	CAST(Character02 as date)='2024-10-28 '
--Key3='FP'
----Character01 like 'La PO%'
----AND ShortChar17 ='ERR'
----Character02 <>''
--AND Key4 in ('2070072838')
----ShortChar17<>'PDO'
----AND Date01 >= '2022-12-31'

order by 1, 7


Select 

					ShortChar16		AS CodigoProducto,
					COunt(ShortChar16)		AS Cantidad


From [EpicorPilot11100].[ICE].[UD10]	
where 
    Number05 =8550
	and 
	CAST(Character02 as date)='2024-10-28 '
group by ShortChar16

order by 1

EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8542
EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8543
EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8544
EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8545
EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8546
EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8547
EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8548
EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	8549

select FechaVenta,ShippingMode,* from [CORPSQLMULT2019].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]
where 
canalentrada in  ('shopify')
and NumeroOC in ('2783')

Select * from [RV_Chile].dbo.[Control_Ejecucion_Servicio_Pedido]

Select * from [RV_Chile].dbo.[Control_Ejecucion_Servicio_Pedido_Piloto]


select 
			COUNT(Number05) AS CantidadPedidoPorGrupo,
			Number05		AS GroupID
From [EpicorLive11100].[ICE].[UD10]	
where 
Date01 > '2022-05-30'
group by Number05
order by 1 DESC

select Number05,ShortChar17,ShortChar18,CheckBox03,Date01,* from [EpicorLive11100].[ICE].[UD10]	
where Number05>18

select * 

from [RV_Chile].dbo.RVF_TBL_API_VENTAS_WEB
where NumeroOC='PRUEBA01'



--delete from [EpicorPilot11100].[ICE].[UD10]
where 

Key3='SP'
--Character01 like 'La PO%'
--AND ShortChar17 ='ERR'
--Character02 <>''
AND Key4 in ('1005')

order by 1

select FechaVenta,ShippingMode,* from [CORPSQLMULT2019].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]
where 
NumeroOC in ('22717674802-A','22720028601-A')
canalentrada in  ('shopify','fcom')
convert (date, FechaVenta) between '2022-04-14' and '2022-04-10'
