USE [RVF_Local]
GO

/****** Object:  View [dbo].[RVF_VW_STCOM_PEDRES_SIN_VIAJE_MOVIVENTAS]    Script Date: 1/22/2021 10:36:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




 /*

ALTER VIEW			[dbo].[RVF_VW_STCOM_PEDRES_SIN_VIAJE_MOVIVENTAS]
AS

 */

SELECT				RES.Company,RES.OrderNum ,C.CustID, C.Name, V.PtoDeVenta, V.CodVendedor , OH.OrderDate, OH.TermsCode, T.[Description] AS TermDescription , 
					OH.OrderComment,OH.DocTotalDiscount,OH.DocOrderAmt,
					-----------------------------------------------------------------------------------------------------------------------------------------
					OD.OrderLine,P.PartNum, P.PartDescription ,OD.LineDesc,OD.UnitPrice,OH.CurrencyCode, OD.UnitPrice, OD.UnitPrice, ROUND(ISNULL(OD.OrderQty,0),2) AS OrderQty,  OD.IUM AS	OUnits,
					CONVERT(int,OD.SellingQuantity) AS SellingQuantity, OD.IUM, OD.OrderQty - OD.SellingQuantity As PendingQuantity, OD.IUM As PUnits,OD.OrderComment,
					
					-------------------------------------------------------------------------------------------------------------------------------------------
					RES.ReservedQty,	P.ClassID, P.ProdCode, RES.WareHouseCode, PUD.Character02, P.SearchWord, V.NroViaje

FROM				RVF_VW_STCOM_PEDRES_MOVIVENTAS								RES			With (NoLock)

INNER JOIN			[CORPEPIDB].EpicorERP.Erp.OrderHed							OH			With (NoLock)
	ON				RES.Company			=			OH.Company
	AND				RES.OrderNum		=			OH.OrderNum

INNER JOIN			[CORPEPIDB].EpicorERP.Erp.OrderDtl							OD			With (NoLock)
	ON				OH.Company			=			OD.Company	
	AND				OH.OrderNum			=			OD.OrderNum	

INNER JOIN			[CORPEPIDB].EpicorERP.Erp.Terms								T			With (NoLock)
	ON				OH.Company			=			T.Company
	AND				OH.TermsCode		=			T.TermsCode

INNER JOIN			[CORPEPIDB].EpicorERP.Erp.Part 								P			With (NoLock)
	ON				RES.Company			=			P.Company
	AND				RES.PartNum			=			P.PartNum
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.Part_UD 							PUD			With (NoLock)
	ON				P.SysRowID			=			PUD.ForeignSysRowID
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.Customer 							C			With (NoLock)
	ON				OH.Company			=			C.Company
	AND				OH.CustNum			=			C.CustNum

LEFT OUTER JOIN		RVF_VW_ANALISIS_ORDEN_VIAJE_REMITO_FACTURA_MOVIVENTAS 		V			With (NoLock)
	ON				RES.Company			=			V.Company
	AND				RES.OrderNum		=			V.NroOrden
	AND				RES.OrderLine		=			V.Linea

WHERE				RES.ReservedQty			<>			0
	AND				ISNULL(V.NroViaje, 0)	=			0
/*
	AND				V.NroOrden				=			136343
*/

GO
