Select * from RVF_TBL_IMP_QUOTE_LOG

Select * from RVF_VW_IMP_QUOTE_HEADER

Select * from RVF_VW_IMP_QUOTE_DETAIL

---------------------------------------
--Borrar Una cotizacion
---------------------------------------
Select * from RVF_VW_IMP_QUOTE_HEADER

Select * from RVF_VW_IMP_QUOTE_DETAIL
where QuoteNum in ('26067','26068')
ORder by QuoteNum

select top 1* from RVF_TBL_IMP_QUOTE_LOG
where Cotizacion='49877'

begin tran
Select *
--delete 
from RVF_TBL_IMP_QUOTE_LOG
where 
/*
Cotizacion in (
--'50112'
--'49877'
'49891',
'50112'
)*/
Cotizacion in (
select distinct nroCotizacion
												from [CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]
												where  codProducto in ('TACA-6400FCSD/TPRO INV3-SK')
												and nroCotizacion <>'49877'
)
--AND		CAST(FechaProceso AS date)	> '2023-07-12'
--ORder by Cotizacion

commit tran

Select Count(*) Registros from RVF_TBL_IMP_QUOTE_LOG_TEST
where Company = 'CO01' And Cotizacion = 26067 

select * from RVF_TBL_IMP_QUOTE_LOG_TEST
Select * from RVF_TBL_IMP_QUOTE_LOG

Select * from RVF_TBL_IMP_QUOTE_LOG
where 
Cotizacion in ('10699','10740','10723','10714','10713','10708','10707','10706','10705','10703','10702')
ORder by Cotizacion

Select * from RVF_TBL_IMP_QUOTE_LOG
where 
Cotizacion =33768
ORder by Cotizacion

select * from RVF_VW_MOVI_CONDICION_DE_VENTAS
where CodigoTelefono='AH'

Select *  from RVF_TBL_IMP_QUOTE_LOG
where Company = 'CO01' And CotizacionEpicor in ('159610' ,'159611')

select * FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones] MQH
where nroCotizacion in (20146,20147)

--delete RVF_TBL_IMP_QUOTE_LOG_TEST where Cotizacion ='26067'



---------------------------------------
--Analisis
---------------------------------------

Select * from [CORPE11-EPIDB].EpicorErp.Erp.QuoteHed
where QuoteNum in ('120249','120250','120251','120087','122706')



SELECT   Company, QuoteNum, QuoteLine, PartNum, SellingExpectedQty, ListPrice, DiscountPercent   
FROM   [CORPE11-EPIDB].EpicorErp.Erp.QuoteDtl   QD  WITH(NoLock)  
WHERE   QuoteNum   IN   (120106, 120097, 120087, 120080, 120063)  
And QD.KitFlag <> 'C'  

SELECT   Company, QuoteNum, QuoteLine, PartNum, SellingExpectedQty, ListPrice, DiscountPercent   
FROM   [CORPE11-EPIDB].EpicorErp.Erp.QuoteDtl   QD  WITH(NoLock)  
where
QD.QuoteNum ='120106'

SELECT   Company, QuoteNum, QuoteLine, PartNum, SellingExpectedQty, ListPrice, DiscountPercent   
FROM   [CORPE11-EPIDB].EpicorErp.Erp.QuoteDtl   QD  WITH(NoLock)  
where
QD.QuoteNum ='120063'

select * from RVF_VW_MOVI_ARTICULOS
where CodigoArticulo like '%SK'

select * from RVF_VW_MOVI_ARTICULOS
where CodigoArticulo like 'TACA-5100FCSA/EL-SK'

select * from RVF_VW_MOVI_ENCABEZADO_COTIZACION
where 
CotizacionComentario =''
NCotizacionMovi in ('2021','2022','2023')

selec * from 
select * from RVF_VW_MOVI_LISTAS_DE_PRECIO
where CodigoProducto in ('TACA-5100FCSA/EL-SK','TACA-6400FCSA/EL-SK')


select * FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones] MQH		WITH(NoLock)


where 
nroCotizacion =10726

select * FROM [CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]	
where 
nroCotizacion =10726


select		a.Company,a.PartNum,a.PartDescription,a.ProdCode,a.CostMethod,a.TaxCatID,a.NetVolume,a.GrossWeight,a.CreatedBy,b.Character02,b.ShortChar03,b.ShortChar04,b.ShortChar10
from		[CORPE11-EPIDB].EpicorERP.Erp.Part a
inner join	[CORPE11-EPIDB].EpicorERP.Erp.Part_ud b
on		a.SysRowID	= b.ForeignSysRowID
where PartNum in (
'TACA-6500FCSD/EL4 UE',
'TACA-6500FCSD/EL4 UI',
'TACA-6500FCSD/EL4-SK',
'TACA-6400FCSD/TPRO INV3-SK', 'TACA-6400FCSD/TPRO INV3 UI', 'TACA-6400FCSD/TPRO INV3 '
)