USE [RVF_Local]
GO

/****** Object:  View [dbo].[RVF_VW_STCOM_PEDRES_MOVIVENTAS]    Script Date: 1/22/2021 10:37:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- /*

ALTER VIEW			[dbo].[RVF_VW_STCOM_PEDRES_MOVIVENTAS]
AS

-- */


/************************************
Lista el detalle del stock comprometido por las ordenes de venta pendientes
************************************/

SELECT				Company, PartNum, OrderNum, Orderline, OrderRelNum, 
					MIN(WareHouseCode)											AS WareHouseCode, 
					SUM(ReservedQty)											AS ReservedQty, 
					SUM(AllocatedQty)											AS AllocatedQty, 
					SUM(PickingQty)												AS PickingQty, 
					SUM(PickedQty)												AS PickedQty, 
					SUM(ReservedQty + AllocatedQty + PickingQty + PickedQty)	AS Enviadas
FROM				[CORPEPIDB].EpicorERP.Erp.PartAlloc		WITH (NoLock)

GROUP BY			Company, PartNum, OrderNum, Orderline, OrderRelNum 











GO


