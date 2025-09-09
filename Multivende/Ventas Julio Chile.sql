SET DATEFORMAT dmy
/*****************************************************
******************************************************/
--Cantidad de Pedidos TCL Store Julio
Select	COUNT(*) AS CantidadPedidosTC
FROM
		(	Select 
					Key4				AS NumeroOC,
					MIN(Number01)		AS Linea,
					Number02			AS Cantidad
			From [EpicorLive11100].[ICE].[UD10]	
			where 
			Key3 = 'TC'
			and Date02 between '2022-04-01' and '2022-04-30'
			Group by Key4, Number02

			--order by 1
		) AS W
--Cantidad de Productos vendidos del TCLStore Julio
SELECT		Convert (int,SUM(X.CantidadProducto)) AS CantidadProductoVedidosTC
FROM
		(			
				Select 
						Key4				AS NumeroOC,
						Number01			AS Linea,
						Number02			AS CantidadProducto
				From [EpicorLive11100].[ICE].[UD10]	
				where 
				Key3 = 'TC'
				and Date02 between '2022-04-01' and '2022-04-30'
				Group by Key4, Number01,Number02

				--order by 1
		) AS X
/*****************************************************
******************************************************/
/*****************************************************
******************************************************/
--Cantidad de Pedidos Multivende 
Select	COUNT(*)	AS CantidadPedidosMultivende
FROM
		(	Select 
					Key3				AS CanalEntrada,
					Key4				AS NumeroOC,
					MIN(Number01)		AS Linea,
					Number02			AS Cantidad
			From [EpicorLive11100].[ICE].[UD10]	
			where 
			Key3 <> 'TC'
			and Date02 between '2022-04-01' and '2022-04-30'
			Group by Key3, Key4, Number02

			--order by 1
		) AS W
--Cantidad de Productos vendidos de Multivende Julio
SELECT		Convert (int,SUM(X.CantidadProducto))AS CantidadProductoVedidosMultivende
FROM
		(			
				Select 
						Key3				AS CanalEntrada,
						Key4				AS NumeroOC,
						Number01			AS Linea,
						Number02			AS CantidadProducto
				From [EpicorLive11100].[ICE].[UD10]	
				where 
				Key3 <> 'TC'
				and Date02 between '2022-04-01' and '2022-04-30'
				Group by Key3 ,Key4, Number01,Number02

				--order by 1
		) AS X
/*****************************************************
******************************************************/