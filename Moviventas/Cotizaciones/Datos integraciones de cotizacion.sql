/************************************
**Sin Forzar Territorio y Vendedor **
*************************************/

--Encabezado
select * from [CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cotizaciones] WITH(NOLOCK)
where nroCotizacion in (
'55051',
'55053',
'55052')

--Detalle
select * from [CORPSQLMULT2019].[moviventas_test].[dbo].[vw_detalle_cotizacion] AS MQD 
where nroCotizacion in (
'55051',
'55053',
'55052')

select * from RVF_TBL_IMP_QUOTE_LOG
where Cotizacion in (
'55051',
'55053',
'55052')

/************************************
**Forzando Territorio y Vendedor **
*************************************/

--Encabezado
select * from [dbo].RVF_TBL_IMP_QUOTE_HEADER
where
		QuoteNum	in (
'55058',
'55059',
'55060',
'55061')

--Detalle
select * from dbo.RVF_TBL_IMP_QUOTE_DETAIL
where
		QuoteNum	in (
'55058',
'55059',
'55060',
'55061')

select * from RVF_TBL_IMP_QUOTE_LOG
where Cotizacion in (
'55058',
'55059',
'55060',
'55061')