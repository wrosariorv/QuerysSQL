use RadioVictoria
select * from MV_Ventas
where
--Convert (date,InformadoRV )>'2022-08-05'
--and 
Datos like '%22886439001%'
order by InformadoRV DESC

select * from MV_Notificaciones

select * from [CORPSQLMULT01].[Multivende].[dbo].RVF_TBL_API_VENTAS_WEB


