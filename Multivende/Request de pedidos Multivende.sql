--SP: [CORPCIBDB01].[RadioVictoria].dbo.[MV_Pool]
declare @MerchantId varchar(100) = '278587981635'
declare @FromUTC as datetime
declare @ToUTC as datetime=getutcdate()
select @FromUTC = CONVERT(datetime,DatoAlfa,126) from CC_ConfigData_Tabla where Propiedad = 'MV_Pooling'
select @FromUTC = coalesce(@FromUTC ,'20220401')

--select  left(convert(varchar,@FromUTC,20),19), left(convert(varchar,@ToUTC,20),19)

declare @URLbase varchar(4000)= 'https://app.multivende.com/api/m/'+@MerchantId+'/checkouts/light/p/%pag%?_sold_at_from=2022-04-01 00:00:00&_updated_at_from='+ left(convert(varchar,@FromUTC,20),19) +'&_updated_at_to='+left(convert(varchar,@ToUTC,20),19)


select @URLbase AS Response