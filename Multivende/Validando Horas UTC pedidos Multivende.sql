select * from MV_Ventas

select * from MV_Notificaciones

select * from [CORPSQLMULT01].[Multivende].[dbo].RVF_TBL_API_VENTAS_WEB

select * from MV_Ventas
where  ID like '175252bc%'

select * from MV_Ventas
where Datos like '%2000003579597799%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T21:41:57.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T21:41:57.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T21:41:57.000-04:00';  
DECLARE @date date= @datetimeoffset;  
DECLARE @time time(3) = @datetimeoffset;  
  
SELECT @datetimeoffset AS '@datetimeoffset ', @time AS 'time'; 
  
SELECT @datetimeoffset AS '@datetimeoffset ', @date AS 'date';  


select sysdatetimeoffset(), SQL_VARIANT_PROPERTY(sysdatetimeoffset(), 'BaseType')

Select	 TODATETIMEOFFSET (GETDATE(),'-04:00')	AS [time on east coast?],
		 sysdatetimeoffset ()						AS [time on east coast?],
		 cast (GETDATE() AS datetimeoffset)		AS [time on east coast?]


Select		GETDATE()								As[implied time zone],
			TODATETIMEOFFSET(

								Getdate(),'-04:00'
							)						AS[explicit UT -03:00 time zone],
			DATEADD(HOUR, -1, GETDATE())			As[east coast time, implied time zone],
			TODATETIMEOFFSET(
								DATEADD(hour,-4,Getdate()),'-04:00'

							)						As[east coast with time zone]

---------------------------------------------------------------------------------------

select * from MV_Ventas
where Datos like '%2000003633933484%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T13:27:25.000-03:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T13:27:25.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]


--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%2000003637178070%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T13:27:25.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T13:27:25.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]

select NumeroOC,FechaVenta,*
FROM				[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]
where
NumeroOC in ('2000003637178070')
order by 1 asc

--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%2000003636779248%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T21:02:41.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T13:27:25.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]

--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%2000003637412946%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T20:08:15.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T20:08:15.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]

--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%2000003637678714%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T22:20:51.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T22:20:51.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]

--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%2000003637804278%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T22:43:51.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T22:43:51.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]

--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%252607505%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T17:16:13.962Z',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T17:16:13.962Z';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -1, @datetime)			As[Hora Argentina UTC -03:00 time zone]

--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%2000003637178070%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T21:02:41.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T21:02:41.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -4, @datetime)						AS[Hora UTC -08:00 time zone],

DATEADD(HOUR, 4, @datetime)							AS[Hora UTC 00:00 time zone],

DATEADD(HOUR, -1, @datetime)						As[Hora Argentina UTC -03:00 time zone]


--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%253140303%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T21:02:41.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T21:02:41.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -4, @datetime)						AS[Hora UTC -08:00 time zone],

DATEADD(HOUR, 4, @datetime)							AS[Hora UTC 00:00 time zone],

DATEADD(HOUR, -1, @datetime)						As[Hora Argentina UTC -03:00 time zone]

--------------------------------------------------------------------------------------
select * from MV_Ventas
where Datos like '%250774897%'

SELECT Convert (DATETIMEOFFSET,'2022-05-30T21:02:41.000-04:00',103) AS [FechaLog]


DECLARE @datetimeoffset datetimeoffset(4) = '2022-05-30T21:02:41.000-04:00';  
DECLARE @datetime datetime= @datetimeoffset;  
  
SELECT 

TODATETIMEOFFSET(

								@datetime,'-04:00'
							)						AS[HoraChile UTC -04:00 time zone],

DATEADD(HOUR, -4, @datetime)						AS[Hora UTC -08:00 time zone],

DATEADD(HOUR, 4, @datetime)							AS[Hora UTC 00:00 time zone],

DATEADD(HOUR, -1, @datetime)						As[Hora Argentina UTC -03:00 time zone]