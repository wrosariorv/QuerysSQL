Select * from RVF_TBL_IMP_QUOTE_LOG

Select * from RVF_VW_IMP_QUOTE_HEADER_TEST

Select * from RVF_VW_IMP_QUOTE_DETAIL_TEST
---------------------------------------
--Borrar Una cotizacion
---------------------------------------
Select * from RVF_VW_IMP_QUOTE_HEADER

Select * from RVF_VW_IMP_QUOTE_DETAIL
where QuoteNum in ('2024','2025','2026','2027','2028','2029')
ORDER BY QuoteNum,QuoteLine

Select * from RVF_TBL_IMP_QUOTE_LOG
where 
Cotizacion in ('2024','2025','2026','2027','2028','2029')
Order By Cotizacion


--delete RVF_TBL_IMP_QUOTE_LOG where Cotizacion in ('1080','1081')


---------------------------------------
--Analisis
---------------------------------------

Select * from [CORPEPIDB].EpicorErp.Erp.QuoteHed
where QuoteNum >'123000'
AND PoNum ='PRUEBA'

SELECT Reference,QuoteNum from [CORPEPIDB].EpicorErp.Erp.QuoteHed
where QuoteNum >'123000'
AND Reference > '1000'
AND Reference <>''
Order by Reference,QuoteNum

-----------------
--Analisis de cotizacion
-----------------
select * from RVF_VW_MOVI_ENCABEZADO_COTIZACION
where
NCotizacion in ('124088','124090','124422','124417','124607')

Select * from [CORPEPIDB].EpicorErp.Erp.QuoteHed
where QuoteNum in ('124088','124090','124422','124417','124607')

Begin tran
update [CORPEPIDB].EpicorErp.Erp.QuoteHed
set DateQuoted=null	,ExpirationDate=null
where
QuoteNum='124607'
rollback tran
commit tran


----------------------------------

-----------------
--Analisis de OV
-----------------

select * from [CORPEPIDB].EpicorERP.Erp.OrderHed
where
OrderNum	in  ('148883','148884',     '147901','145671',		'149062','149060',		'149011')
ORDER by OrderNum

select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS
where
NOrden		in  ('148883','148884',     '147901','145671',		'149062','149060',		'149011')
ORDER by NOrden

select * from RVF_VW_MOVI_ENCABEZADO_COTIZACION
where NCotizacionMovi='1048'


select * from [CORPEPIDB].EpicorERP.Erp.OrderHed
where
OrderNum	in ('149113','149114','149115')
ORDER by OrderNum

select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS
where
NOrden		in ('149113','149114','149115')
ORDER by NOrden
----------------------------------

Select Quoted,Expired,* from [CORPEPIDB].EpicorErp.Erp.QuoteHed
where
/*QuoteNum >'123000'
and*/ Quoted = 1 and Expired =1

1	0--> Avanzo
0	1--> Rechazo
1	1-->Rechazado
SELECT Reference,* from [CORPEPIDB].EpicorErp.Erp.QuoteHed
where QuoteNum >'123000'
AND Reference > '1047'

Select * from RVF_TBL_IMP_QUOTE_LOG
where 
Cotizacion > '1047'

SELECT   Company, QuoteNum, QuoteLine, PartNum, SellingExpectedQty, ListPrice, DiscountPercent   
FROM   [CORPEPIDB].EpicorErp.Erp.QuoteDtl   QD  WITH(NoLock)  
WHERE   QuoteNum   IN   (120106, 120097, 120087, 120080, 120063)  
And QD.KitFlag <> 'C'  

SELECT   Company, QuoteNum, QuoteLine, PartNum, SellingExpectedQty, ListPrice, DiscountPercent   
FROM   [CORPEPIDB].EpicorErp.Erp.QuoteDtl   QD  WITH(NoLock)  
where
QD.QuoteNum ='120106'

SELECT   Company, QuoteNum, QuoteLine, PartNum, SellingExpectedQty, ListPrice, DiscountPercent   
FROM   [CORPEPIDB].EpicorErp.Erp.QuoteDtl   QD  WITH(NoLock)  
where
QD.QuoteNum >'123000'
ORDER BY Company,QuoteNum,QuoteLine

select * from RVF_VW_MOVI_ARTICULOS
where CodigoArticulo like '%SK'

select * from RVF_VW_MOVI_ARTICULOS
where CodigoArticulo like 'TACA-5100FCSA/EL-SK'