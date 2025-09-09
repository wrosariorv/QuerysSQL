use Multivende

select * from RVF_TBL_API_VENTAS_WEB
where (
		CanalEntrada ='Shopify'
		and NumeroOC ='3337'
	   )
		or
		(
		CanalEntrada ='Walmart'
		and NumeroOC ='51026178851'
		)
		or
		(
		CanalEntrada ='Paris'
		and NumeroOC ='274136139'
		)
		or
		(
		CanalEntrada ='Ripley'
		and NumeroOC ='22886439001-A'
		)

CanalEntrada in ('shopify', 'walmart','Paris','Ripley')
and NumeroOC in ()

SELECT TOP (1000) [fecha]
      ,[ID]
      ,[Datos]
  FROM [CORPCIBDB01].[RadioVictoria].[dbo].[MV_Ventas_Log]
  where 
  id='13c422da-c81d-4b11-92ad-7ad96799537b'

  order by fecha


  --Obtener el ultimo Json para el Chekout_id de ML

  SELECT 
    t1.fecha, 
    t1.ID, 
    b.NumeroOC, 
    t1.Datos
FROM [CORPCIBDB01].[RadioVictoria].[dbo].[MV_Ventas_Log] t1
INNER JOIN RVF_TBL_API_VENTAS_WEB b
ON t1.id COLLATE Modern_Spanish_CI_AS = b.Chekout_id COLLATE Modern_Spanish_CI_AS
WHERE fecha = (
    SELECT MIN(fecha) 
    FROM [CORPCIBDB01].[RadioVictoria].[dbo].[MV_Ventas_Log] t2
    WHERE t1.ID = t2.ID
)
AND t1.ID IN (
    '1b11e572-d15e-4ba0-b80e-8a7ea2668351',
    'd1f5de97-94fd-453c-8126-433d10745095',
    'e9bd6ef8-65d0-43e6-95ba-d41501aa6d77',
    '6bd7c8cb-c731-4559-916b-9975e460b328',
    'be02b043-f9bf-4120-81e9-4c3d878e3745'
)
ORDER BY fecha;
