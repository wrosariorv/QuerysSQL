select * from RVF_TBL_API_VENTAS_WEB
where 

CanalEntrada ='shopify'
Convert (date,FechaVenta ) between '2023-01-19' and GETDATE()

order by 1

NumeroOC in 
(
'4685386121371',
'4685384777883',
'4685381664923'
)


select CanalEntrada,ShippingMode from RVF_TBL_API_VENTAS_WEB
where 

CanalEntrada <>'shopify'

Group by ShippingMode, CanalEntrada


select CanalEntrada,ShippingMode from RVF_TBL_API_VENTAS_WEB
where 

CanalEntrada ='shopify'



select * from [CORPCIBDB01].[RadioVictoria].[dbo].MV_Ventas
where
--Convert (date,InformadoRV )>'2022-08-05'
--and 
Datos like '%4685386121371%'
or Datos like '%4685384777883%'
or Datos like '%4685381664923%'
order by InformadoRV DESC