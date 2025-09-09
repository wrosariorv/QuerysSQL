INSERT INTO RVF_TBL_API_VENTAS_WEB_BK
select 
      a.[CanalEntrada]
      ,a.[NumeroOC]
      ,a.[NumeroDocumento]
      ,a.[Nombre]
      ,a.[Domicilio]
      ,a.[Ciudad]
      ,a.[Provincia]
      ,a.[CodigoPostal]
      ,a.[CodigoProvincia]
      ,a.[Entrega_Nombre]
      ,a.[Entrega_domicilio1]
      ,a.[Entrega_domicilio2]
      ,a.[Entrega_domicilio3]
      ,a.[Entrega_Ciudad]
      ,a.[Entrega_Provincia]
      ,a.[Entrega_CP]
      ,a.[Entrega_Documento]
      ,a.[Comentario]
      ,a.[FechaVenta]
      ,a.[Linea]
      ,a.[CodigoProducto]
      ,a.[Cantidad]
      ,a.[PrecioUnitario]
      ,a.[RequiereFactura]
      ,a.[CostoEnvio]
      ,a.[UltimaLinea]
      ,a.[ShippingMode]
  FROM [Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB] a

  where  exists (select NumeroOC from RVF_TBL_API_VENTAS_WEB_BK b where a.NumeroOC=b.NumeroOC )
  AND	convert (date,a.FechaVenta ) not between '2022-04-14' and '2022-04-24'

  order by [FechaVenta]

  select * from RVF_TBL_API_VENTAS_WEB_BK


  --delete FROM [Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB] 
  where  
convert (date,FechaVenta ) not between '2022-04-14' and '2022-04-20'

select FechaVenta,* from [Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]
order by 1