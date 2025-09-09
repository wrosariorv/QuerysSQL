select * from RVF_VW_MOVI_LISTAS_DE_PRECIO where CodigoProducto not in (select CodigoArticulo from RVF_VW_MOVI_ARTICULOS)

select * from RVF_VW_MOVI_DETALLE_PEDIDOS  where CodigoArticulo not in (select CodigoArticulo from RVF_VW_MOVI_ARTICULOS)

------------
--OV
------------
select * from RVF_VW_MOVI_DETALLE_PEDIDOS  where NOrden not in (select NOrden from RVF_VW_MOVI_ENCABEZADO_PEDIDOS)

select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS  where NOrden not in (select NOrden from RVF_VW_MOVI_DETALLE_PEDIDOS)

Select  count (*) FROM RVF_VW_MOVI_ENCABEZADO_PEDIDOS a
where
TotalOrden>0 and not exists (
									Select * from RVF_VW_MOVI_DETALLE_PEDIDOS b
									Where b.NOrden = a.NOrden
								)

SELECT NOrden, count (*) FROM RVF_VW_MOVI_ENCABEZADO_PEDIDOS
Group by NOrden
having  count (*)>1

------------
--OV TEST
------------

select * from RVF_VW_MOVI_DETALLE_PEDIDOS_NEW  where NOrden not in (select NOrden from RVF_VW_MOVI_ENCABEZADO_PEDIDOS_NEW)

select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS_NEW  where NOrden not in (select NOrden from RVF_VW_MOVI_DETALLE_PEDIDOS_NEW)

Select  count (*) FROM RVF_VW_MOVI_ENCABEZADO_PEDIDOS_NEW a
where
TotalOrden>0 and not exists (
									Select * from RVF_VW_MOVI_DETALLE_PEDIDOS_NEW b
									Where b.NOrden = a.NOrden
								)

SELECT NOrden, count (*) FROM RVF_VW_MOVI_ENCABEZADO_PEDIDOS_NEW
Group by NOrden
having  count (*)>1

select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS_NEW  where NumeroCotizacion not in (select NCotizacion from RVF_VW_MOVI_ENCABEZADO_COTIZACION)

select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS_NEW  where NumeroCotizacion not in (select NCotizacion from RVF_VW_MOVI_DETALLE_COTIZACION)

select * from RVF_VW_MOVI_ENCABEZADO_COTIZACION
WHERE NCotizacion= 99486

------------
--Cotizacion
------------

select * from RVF_VW_MOVI_DETALLE_COTIZACION  where NCotizacion not in (select NCotizacion from RVF_VW_MOVI_ENCABEZADO_COTIZACION)

select * from RVF_VW_MOVI_ENCABEZADO_COTIZACION  where NCotizacion not in (select NCotizacion from RVF_VW_MOVI_DETALLE_COTIZACION)

Select  count (*) FROM RVF_VW_MOVI_ENCABEZADO_COTIZACION a
where
totalcotizacion>0 and not exists (
									Select * from RVF_VW_MOVI_DETALLE_COTIZACION b
									Where b.NCotizacion = a.NCotizacion
								)

SELECT NCotizacion, count (*) FROM RVF_VW_MOVI_ENCABEZADO_COTIZACION
Group by NCotizacion
having  count (*)>1
------------------------------
select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS  where NOrden not in (select NOrden from RVF_VW_MOVI_DETALLE_PEDIDOS)

select NOrden from RVF_VW_MOVI_DETALLE_PEDIDOS
group by NOrden
select NOrden from RVF_VW_MOVI_ENCABEZADO_PEDIDOS