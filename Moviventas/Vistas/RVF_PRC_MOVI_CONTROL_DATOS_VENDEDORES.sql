USE [RVF_Local]
GO

--/*
create PROCEDURE			[dbo].[RVF_PRC_MOVI_CONTROL_DATOS_VENDEDORES]	
																@CodVendedor	VARCHAR(15) 
																
															

AS
--*/	

--/*
--2 unidades de negocio
--vrosario ---> ALC_R10
--vrosario2---> ALC_R08
--1 unidad de negocio
--esuarez--->TCL08
--DECLARE				@CodVendedor	VARCHAR(15)		=		'ALC_R10' 
					
--*/

---------------------------------------------

--------------------------------------------------
-- Datos del Vendedor.
--------------------------------------------------

SELECT 
				* 
FROM			RVF_VW_MOVI_VENDEDORES			WITH(Nolock)
WHERE			
				CodigoVendedor		=		 @CodVendedor

---------------------------------------------


--------------------------------------------------
-- Domicilio del Vendedor
--------------------------------------------------

SELECT 
				* 
FROM			RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES		WITH(Nolock)

WHERE			
				CodVendedor		 like		@CodVendedor



---------------------------------------------


--------------------------------------------------
-- Datos de Cliente correspondiente al Vendedor
--------------------------------------------------

SELECT 
				a.* ,b.*
FROM			RVF_VW_MOVI_CLIENTES a						WITH(Nolock) 

inner JOIN		RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES b

ON				a.CodigoCliente			=			b.CodigoCliente

where			b.CodVendedor			like		'TCL02'

				--and a.CodigoCliente		=			'44036'

order by		a.RazonSocial

select * from RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES
where			CodVendedor			like		'TCL02%'
				and CodigoCliente like			'44113'
order by CodigoCliente

---------------------------------------------------------------------

--------------------------------------------------
-- Articulos correspondiente al Vendedor
---------------------------------------------------
/*
				a.*
FROM			RVF_VW_MOVI_ARTICULOS a						WITH(Nolock) 

LEFT JOIN		RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES b

ON				b.Compania				=			A.Compania
AND				b.UnidadNeg				=			a.CodigoMarca

--LEFT JOIN		RVF_VW_MOVI_CLIENTES c						WITH(Nolock) 


--ON				b.CodigoCliente			=			c.CodigoCliente

WHERE			b.CodVendedor			=		@CodVendedor
*/


SELECT			a.*
FROM			RVF_VW_MOVI_ARTICULOS a
INNER JOIN
(
	SELECT			UnidadNeg 

	FROM			RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES
	
	WHERE			CodVendedor like 'TCL02%'
	
	GROUP BY		UnidadNeg
)b
ON		A.CodigoMarca		=	 	B.UnidadNeg
where a.CodigoCategoria		=		'TV-LED'
ORDER BY A.CodigoMarca desC

select * from RVF_VW_MOVI_CLASE_PRODUCTO
---------------------------------------------------------------------


--------------------------------------------------
-- Pedidos pendientes del vendedor
---------------------------------------------------

SELECT FechaPedido, a.CodigoCliente, b.RazonSocial, a.NOrden, a.UnNeg, a.TotalOrden 

FROM			RVF_VW_MOVI_ENCABEZADO_PEDIDOS		a

inner join		RVF_VW_MOVI_CLIENTES				b

ON				a.CodigoCliente			=			b.CodigoCliente

WHERE			

				a.CodigoVendedor			=			'ALC_R08'
--and				a.CodigoCliente			=			'49221'

Order by		NOrden, UnNeg
