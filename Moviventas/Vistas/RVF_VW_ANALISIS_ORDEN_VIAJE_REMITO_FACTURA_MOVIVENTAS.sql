USE [RVF_Local]
GO

/****** Object:  View [dbo].[RVF_VW_ANALISIS_ORDEN_VIAJE_REMITO_FACTURA_MOVIVENTAS]    Script Date: 1/22/2021 10:37:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







 /*

ALTER VIEW			[dbo].[RVF_VW_ANALISIS_ORDEN_VIAJE_REMITO_FACTURA_MOVIVENTAS]
AS

 */

---------------------------------------------------
-- Ordenes con viaje asignado
---------------------------------------------------

SELECT				UDA.Company, 
					LTRIM(RTRIM(CAST(CAST(UDA.Number01 AS INTEGER) AS VARCHAR(15))))	AS NroOrden,
					ISNULL(IH.AGInvoicingPoint, '')										AS PtoDeVenta,
					ISNULL(IH.SalesRepList, '')											AS CodVendedor,
--					UDA.Key1, UDA.Key2, 
					UDA.Key3															AS NroViaje, 
					UDA.ShortChar07														AS NroRemito, 
					UDA.ShortChar09														AS NroLegal, 
					LTRIM(RTRIM(CAST(CAST(UDA.Number08 AS INTEGER) AS VARCHAR(15))))	AS NroInterno, 
					LTRIM(RTRIM(CAST(CAST(UDA.Number06 AS INTEGER) AS VARCHAR(15))))	AS NroEmpaque, 
					UDA.ShortChar06														AS Producto, 
					ROUND(ISNULL(SD.OurInventoryShipQty,0),2)							AS Cantidad,
					ISNULL(PR.ReservedQty, 0)											AS ReservedQty,  
					LTRIM(RTRIM(CAST(CAST(UDA.Number04 AS INTEGER) AS VARCHAR(15))))	AS CantidadOrden, 
					LTRIM(RTRIM(CAST(CAST(UDA.Number02 AS INTEGER) AS VARCHAR(15))))	AS Linea, 
					UDA.CheckBox02														AS Conforme, 
					UD.Date01															AS FechaViaje, 
--					, UDA.Key4, UDA.Key5, UDA.Childkey1, UDA.ChildKey2  
--					, UDA.Number03, UDA.Number05, UDA.Number07, UDA.Number09, UDA.Number10 
--					, UDA.ShortChar01, UDA.ShortChar02, UDA.ShortChar03, UDA.ShortChar04, UDA.ShortChar05, UDA.ShortChar08, UDA.ShortChar10 
					ISNULL(IH.InvoiceDate, '')											AS InvoiceDate, 
					ISNULL(IH.CustNum, '')												AS CustNum, 
					ISNULL(CU.Name, '')													AS Name,  
					ISNULL(OD.OpenLine, 0)												AS OpenLine

FROM				(
					SELECT				*
					FROM				[CORPEPIDB].EpicorERP.Ice.UD110		WITH (NoLock)
					WHERE				Key1			=		'ViajeCab'
					)										UD
INNER JOIN			(
					SELECT				*
					FROM				[CORPEPIDB].EpicorERP.Ice.UD110A		WITH (NoLock)
					WHERE				Key1			=		'ViajeCab'
					)										UDA		
	ON				UD.Company		=		UDA.Company
	AND				UD.Key1			=		UDA.Key1
	AND				UD.Key2			=		UDA.Key2
	AND				UD.Key3			=		UDA.Key3
	AND				UD.Key4			=		UDA.Key4
	AND				UD.Key5			=		UDA.Key5

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.InvcHead			IH		WITH (NoLock)
	ON				UDA.Company		=		IH.Company
	AND				UDA.Number08	=		IH.InvoiceNum
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.Customer			CU		WITH (NoLock)
	ON				IH.Company		=		CU.Company
	AND				IH.CustNum		=		CU.CustNum
LEFT OUTER JOIN		RVF_TBL_ANALISIS_ORDEN_VIAJE_REMITO_FACTURA_CANTIDADES_ENVIADAS
					/*(
					SELECT					Det.Company, Det.OrderNum, Det.OrderLine, Det.PartNum, Det.OurInventoryShipQty
					FROM					[CORPEPIDB].EpicorERP.Erp.ShipDtl	Det		WITH (NoLock)
					INNER JOIN				[CORPEPIDB].EpicorERP.Erp.ShipHead	Hea		WITH (NoLock)
						ON					Det.Company		=	Hea.Company
						AND					Det.PackNum		=	Hea.PackNum
					WHERE					Hea.ShipStatus	=	'SHIPPED'
					)*/										SD		
	ON				UDA.Company		=		SD.Company
	AND				UDA.Number01	=		SD.OrderNum
	AND				UDA.Number02	=		SD.OrderLine
	AND				UDA.ShortChar06	=		SD.PartNum

LEFT OUTER JOIN		RVF_VW_STCOM_PEDRES_MOVIVENTAS						PR		WITH (NoLock)
	ON				UDA.Company		=		PR.Company
	AND				UDA.Number01	=		PR.OrderNum
	AND				UDA.Number02	=		PR.OrderLine
	AND				UDA.ShortChar06	=		PR.PartNum
LEFT OUTER JOIN		(
					SELECT				OD.Company, OD.OpenLine, OD.VoidLine, OD.OrderNum, OD.OrderLine 
					FROM				[CORPEPIDB].EpicorERP.Erp.OrderDtl		OD		WITH (NoLock)
					WHERE				OD.OpenLine		=		1
					)										OD
	ON				UDA.Company		=		OD.Company
	AND				UDA.Number01	=		OD.OrderNum
	AND				UDA.Number02	=		OD.OrderLine

---------
UNION ALL
---------

---------------------------------------------------
-- Ordenes sin viaje asignado
---------------------------------------------------

SELECT				OH.Company,
					OH.OrderNum										AS NroOrden,
					ISNULL(IV.AGInvoicingPoint, '')					AS PtoDeVenta,
					ISNULL(IV.SalesRepList, '')						AS CodVendedor,
					0												AS NroViaje, 
					ISNULL(SH.LegalNumber, '')						AS NroRemito, 
					ISNULL(IV.LegalNumber, '')						AS NroLegal, 
					ISNULL(IV.InvoiceNum, 0)						AS NroInterno,  
					ISNULL(SH.PackNum, 0)							AS NroEmpaque, 
					OD.PartNum										AS Producto, 
					ISNULL(IV.SellingShipQty, 0)					AS Cantidad, 
					0												AS ReservedQty, 
					OD.OrderQty										AS CantidadOrden, 
					OD.OrderLine									AS Linea, 
					0												AS Conforme, 
					''												AS FechaViaje, 
					ISNULL(IV.InvoiceDate, '')						AS InvoiceDate, 
					OH.CustNum, 
					C.Name, 
					OD.OpenLine
					
FROM				[CORPEPIDB].EpicorERP.Erp.OrderHed				OH		WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.OrderDtl				OD		WITH (NoLock)
	ON				OH.Company		=		OD.Company
	AND				OH.OrderNum		=		OD.OrderNum
LEFT OUTER JOIN		(
					SELECT				H.Company, H.PackNum, H.LegalNumber, 
										D.PackLine, D.OrderNum, D.OrderLine, 
										HUD.Character02 
					FROM				[CORPEPIDB].EpicorERP.Erp.ShipHead				H		WITH (NoLock)
					INNER JOIN			[CORPEPIDB].EpicorERP.Erp.ShipDtl					D		WITH (NoLock)
						ON				H.Company			=			D.Company
						AND				H.PackNum			=			D.PackNum
					-------------------------------------------------------------
					INNER JOIN			[CORPEPIDB].EpicorERP.Erp.ShipHead_UD				HUD		WITH (NoLock)
						ON				H.SysRowID			=			HUD.ForeignSysRowID
					-------------------------------------------------------------
					)											SH		
	ON				OD.Company		=		SH.Company
	AND				OD.OrderNum		=		SH.OrderNum
	AND				OD.OrderLine	=		SH.OrderLine
LEFT OUTER JOIN		(
					SELECT				H.Company, H.InvoiceNum, H.LegalNumber, H.InvoiceDate, 
										D.InvoiceLine, D.OrderNum, D.OrderLine, D.SellingShipQty,
										H.AGInvoicingPoint, H.SalesRepList
					FROM				[CORPEPIDB].EpicorERP.Erp.InvcHead				H		WITH (NoLock)
					INNER JOIN			[CORPEPIDB].EpicorERP.Erp.InvcDtl					D		WITH (NoLock)
						ON				H.Company			=			D.Company
						AND				H.InvoiceNum		=			D.InvoiceNum
					)											IV		
	ON				OD.Company		=		IV.Company
	AND				OD.OrderNum		=		IV.OrderNum
	AND				OD.OrderLine	=		IV.OrderLine
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.Customer				C		WITH (NoLock)
	ON				OH.Company		=		C.Company
	AND				OH.CustNum		=		C.CustNum

WHERE NOT EXISTS	(
					SELECT				*
					FROM				[CORPEPIDB].EpicorERP.Ice.UD110A			UD		WITH (NoLock)
					WHERE				Key1				=			'ViajeCab'
						AND				UD.Company			=			OD.Company
						AND 			UD.Number01			=			OD.OrderNum
						AND				UD.Number02			=			OD.OrderLine
					)



GO


