USE [RV_Chile]
GO




--/*

ALTER VIEW		[dbo].[RVF_VW_API_NOTIFICACION_PEDIDOS_MULTIVENDE]
AS

--*/
/*****************************************************************
						NOTAS
******************************************************************/
/*****************************************************************
->PEDIDOS INTEGRADOS
(Pedidos de origen de Multivende que hayan generado OV en Epicor)
Parametros fijos:
-DeliveryOrderStatusId:
510a864b-2385-11e7-8642-2c56dc130c0d
-DeliveryOrderStatusCode:
_delivery_order_status_pending_

->PEDIDOS FACTURADOS
(Pedidos de origen de Multivende que hayan generado Factura en Epicor y la misma este posteada)
Parametros fijos:
-DeliveryOrderStatusId:
232d1d01-2386-11e7-8642-2c56dc130c0d
-DeliveryOrderStatusCode:
_delivery_order_status_shipped_

*******************************************************************/




SELECT			*
FROM			(



							/*************************************************************
										Pedidos de ventas integrados
							*************************************************************/

							SELECT			
											--UD.Key3									AS		CanalEntrada,
											--UD.ShortChar18							AS		NumeroOV,
											UD.Key4									AS		NumeroOC,
											ID.DeliveryOrderId,
											getdate()								AS		[Date],
											--Date01									AS		FechaVenta,
											'510a864b-2385-11e7-8642-2c56dc130c0d'	AS		DeliveryOrderStatusId,
											'_delivery_order_status_pending_'		AS		DeliveryOrderStatusCode

							FROM			[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
							INNER JOIN		[EpicorLive11100].[Erp].[OrderHed]		OH		WITH(NoLock)
								ON 			UD.Company			=				OH.Company	
								AND			UD.ShortChar18 		=				OH.OrderNum 
							LEFT JOIN		[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]	ID
								ON			ID.NumeroOC			=				UD.Key4
							WHERE
							-- Registros de la UD10 no integrados como pedidos de venta en Epicor
							UD.ShortChar18				<>				0						
							-- Se excluyen los pedidos que no son del  TCLStore
							AND				UD.Key3<>'TC'


							AND				Convert (date,UD.Date01)>'2022-09-28'

							AND			NOT EXISTS		(
																SELECT				NumeroOC
																FROM				[CORPSQLMULT01].[Multivende].dbo.[RVF_TBL_API_ESTADO_PEDIDOS_MULTIVENDE] B
																WHERE				UD.Key4		=		B.NumeroOC
						
														)

							--Order by UD.Date01
							----------------
							UNION ALL 
							----------------
							/*************************************************************
										Pedidos de ventas Facturados
							*************************************************************/

							SELECT			--UD.Key3									AS		CanalEntrada,
											--UD.ShortChar18							AS		NumeroOV,
											--IH.InvoiceNum							AS		NuneroFactura,
											--UD.Date01								AS		FechaVenta,
											--IH.Posted,
											UD.Key4									AS		NumeroOC,
											I.DeliveryOrderId						AS		DeliveryOrderId,
											GETDATE()								AS		[Date],
											'232d1d01-2386-11e7-8642-2c56dc130c0d'	AS		DeliveryOrderStatusId,

				
											'_delivery_order_status_shipped_'		AS		DeliveryOrderStatusCode

							FROM			[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
							INNER JOIN		[EpicorLive11100].[Erp].[InvcDtl]		ID		WITH(NoLock)
								ON 			UD.Company			=				ID.Company	
								AND			UD.ShortChar18		=				CAST(ID.OrderNum AS VARCHAR (50))
							INNER JOIN		[EpicorLive11100].[Erp].[InvcHead]		IH		WITH(NoLock)
								ON 			ID.Company			=				IH.Company	
								AND			ID.InvoiceNum 		=				IH.InvoiceNum 
							INNER JOIN		[EpicorLive11100].[Erp].[OrderHed]		OH		WITH(NoLock)
								ON 			UD.Company			=				OH.Company	
								AND			UD.ShortChar18		=				CAST(OH.OrderNum AS VARCHAR (50))
							LEFT JOIN		[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]	I
								ON			I.NumeroOC			=				UD.Key4
							WHERE			
							-- Se excluyen los registros de la UD10 no integrados como pedidos de venta en Epicor
							UD.ShortChar18				<>				0	
							-- Se excluyen las facturas no posteadas
							AND	IH.Posted				=				1
							-- Se excluyen los pedidos que no son del  TCLStore
							AND				UD.Key3<>'TC'

							-- Se excluyen los regsitro previo a la puesta en marcha
							AND				Convert (date,UD.Date01)>'2022-09-28'
							-- Se excluyen los regristro ya informados a Multivende
							AND			NOT EXISTS		(
																SELECT				NumeroOC
																FROM				[CORPSQLMULT01].[Multivende].dbo.[RVF_TBL_API_ESTADO_PEDIDOS_MULTIVENDE] B
																WHERE				UD.Key4		=		B.NumeroOC
						
														)
							GROUP BY /*UD.Key3, UD.ShortChar18,IH.InvoiceNum,UD.Date01,IH.Posted,*/UD.Key4,I.DeliveryOrderId
					) AS W
--ORDER BY W.NumeroOC,DeliveryOrderStatusCode


-----------------------------------------------------------------------------------------------------------

--select ClientID,DeliveryOrderId,* from [CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]
--where numeroOC='255456680'
--AND		DeliveryOrderId='51533e23-5d8e-4a3d-acbc-898fe7599a28'



--Select * from [CORPSQLMULT01].[Multivende].dbo.[RVF_TBL_API_ESTADO_PEDIDOS_MULTIVENDE]
--order by [date]


GO


