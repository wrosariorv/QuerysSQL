----------------------------------------
---Encabezado de Cotizacion
----------------------------------------
Select					
					MQH.Company												AS Company,
					MQH.QuoteNum											AS QuoteNum,
					convert (date,MQH.EntryDate)							AS EntryDate,
					MQH.CustNum												AS CustNum,
					MQH.ShipToNum											AS ShipToNum,
					ISNULL(MQH.PONum,'')									AS PONum,
					MQH.MktgCampaignID										AS MktgCampaignID,
					MQH.TermsCode											AS TermsCode,
					ISNULL(convert (date,MQH.RequestDate),'')				AS RequestDate,
					C.CustID												AS CustID,
					MQH.TerritoryID,
					M.Direccion
						 
FROM			[CORPEPIDB].EpicorERP.Erp.QuoteHed	MQH
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.Customer	C
ON				MQH.Company		=		C.Company
AND				MQH.Custnum		=		c.Custnum
INNER JOIN		RVF_VW_MOVI_DOMICILIO_DE_CLIENTE M	
ON				M.Compania		=		MQH.Company
AND				M.CodigoCliente =		C.CustID
WHERE
				MQH.QuoteNum>123000
and				MQH.TerritoryID IN ('HIT08')
AND				MQH.Company		='CO01'

Select					
					MQH.Company												AS Company,
					MQH.QuoteNum											AS QuoteNum,
					convert (date,MQH.EntryDate)							AS EntryDate,
					MQH.CustNum												AS CustNum,
					MQH.ShipToNum											AS ShipToNum,
					ISNULL(MQH.PONum,'')									AS PONum,
					MQH.MktgCampaignID										AS MktgCampaignID,
					MQH.TermsCode											AS TermsCode,
					ISNULL(convert (date,MQH.RequestDate),'')				AS RequestDate,
					C.CustID												AS CustID,
					MQH.TerritoryID,
					M.Direccion
						 
FROM			[CORPEPIDB].EpicorERP.Erp.QuoteHed	MQH
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.Customer	C
ON				MQH.Company		=		C.Company
AND				MQH.Custnum		=		c.Custnum
INNER JOIN		RVF_VW_MOVI_DOMICILIO_DE_CLIENTE M	
ON				M.Compania		=		MQH.Company
AND				M.CodigoCliente =		C.CustID
WHERE

				MQH.TerritoryID IN ('ALC_R08')
AND				MQH.QuoteNum	IN (
		'121013',
'121102',
'121107',
'121638',
'121680',
'121683',
'121684',
'121685',
'121686',
'121703',
'121757',
'122585',
'122984',
'122986',
'122988',
'122990',
'122995',
'122996',
'122997',
'122999',
'123001',
'123003',
'123005',
'123113',
'123116',
'123117',
'123120',
'123188',
'123194',
'123197',
'123597',
'123598',
'123599',
'123600',
'123604',
'123613',
'123627',
'123667',
'123674',
'123679',
'123706',
'123707',
'123764',
'123808'





)



----------------------------------------
---Detalle de Cotizacion
----------------------------------------
Select			TOP 2000
				MQD.Company																					AS Company,
				MQD.QuoteNum																				AS QuoteNum,
				MQD.QuoteLine																				AS QuoteLine,
				--[dbo].[RVF_FNC_Calcula_NroLinea] (MQD.[compania], MQD.[nroCotizacion], MQD.[nroLinea])	AS QuoteLine, 
				MQD.PartNum																					AS PartNum,
				MQD.SellingExpectedQty																		AS SellingExpectedQty,
				P.Precio																					AS ListPrice,
				ISNULL(MQD.DiscountPercent,0)																AS DiscountPercent,
				MQD.ProdCode
				--MQD.PartDescription
				 
from			[CORPEPIDB].EpicorERP.Erp.QuoteDtl	MQD
INNER JOIN		RVF_VW_MOVI_LISTAS_DE_PRECIO		P
ON				MQD.company				=			P.Compania
AND				MQD.PARTNUM			=			P.CodigoProducto
WHERE
				MQD.QuoteNum>121000
--AND				MQD.PartNum  not like '%UI'
--OR				MQD.PartNum not like '%UE'
and				MQD.TerritoryID LIKE	'ALC_R08'

GROUP BY		MQD.Company,MQD.QuoteNum,MQD.QuoteLine,MQD.PartNum,	MQD.SellingExpectedQty,P.Precio,ISNULL(MQD.DiscountPercent,0),MQD.ProdCode--,MQD.PartDescription



Select			TOP 2000
				MQD.Company																					AS Company,
				MQD.QuoteNum																				AS QuoteNum,
				MQD.QuoteLine																				AS QuoteLine,
				--[dbo].[RVF_FNC_Calcula_NroLinea] (MQD.[compania], MQD.[nroCotizacion], MQD.[nroLinea])	AS QuoteLine, 
				MQD.PartNum																					AS PartNum,
				MQD.SellingExpectedQty																		AS SellingExpectedQty,
				P.Precio																					AS ListPrice,
				ISNULL(MQD.DiscountPercent,0)																AS DiscountPercent,
				MQD.ProdCode
				--MQD.PartDescription
				 
from			[CORPEPIDB].EpicorERP.Erp.QuoteDtl	MQD
INNER JOIN		RVF_VW_MOVI_LISTAS_DE_PRECIO		P
ON				MQD.company				=			P.Compania
AND				MQD.PARTNUM			=			P.CodigoProducto
WHERE
				
--AND				MQD.PartNum  not like '%UI'
--OR				MQD.PartNum not like '%UE'
				MQD.TerritoryID IN	('ALC14')
AND				MQD.QuoteNum	IN	(
'123041',
'123066',
'123149',
'123083',
'123070',
'123147',
'123162',
'123262',
'123258',
'123241'

)

GROUP BY		MQD.Company,MQD.QuoteNum,MQD.QuoteLine,MQD.PartNum,	MQD.SellingExpectedQty,P.Precio,ISNULL(MQD.DiscountPercent,0),MQD.ProdCode--,MQD.PartDescription