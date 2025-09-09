DECLARE @mydate DATETIME
SELECT @mydate = GETDATE()
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)),@mydate),101) ,
'Último día del mes anterior'
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),101) AS Date_Value,
'Primer día del mes corriente' AS Date_Type
UNION
SELECT CONVERT(VARCHAR(25),@mydate,101) AS Date_Value, 'Hoy' AS Date_Type
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate)),101) ,
'Último día del mes corriente'
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),DATEADD(mm,1,@mydate)),101) ,
'Primer día del mes siguiente'
GO

----------------------------------------------------------
----------------------------------------------------------
DECLARE		@FechaActual	DATE, 
			@FindeMes		DATE,
			@Fecha DATE = GETDATE()

SELECT		@FindeMes		=		EOMONTH (GETDATE()), 
			@FechaActual	=		CAST(GETDATE() AS DATE)

Select @FindeMes,@FechaActual


SELECT DATEADD(DAY, 1, EOMONTH(@Fecha, -1)) as diaInicioMes, EOMONTH(@Fecha) AS diaFinalMes
----------------------------------------------------------
----------------------------------------------------------






----------------------------------------------------------

DECLARE		@FechaActual	DATE, 
			@FindeMes		DATE

SELECT		@FindeMes		=		EOMONTH (GETDATE()), 
			@FechaActual	=		CAST(GETDATE() AS DATE)

----------------------------------------------------------

IF			@FindeMes		=		@FechaActual
	BEGIN

			/****************************************************************
			Ejecuta Job
			****************************************************************/

			--'Detalle anticipos sin aplicar - Completo'
			EXEC msdb.dbo.sp_start_job N'8CCCCE37-75DD-4745-A6D4-D2CF09C05792'   

			-- 'Cuenta corriente Clientes - Completo'
			EXEC msdb.dbo.sp_start_job N'87EDD01B-B186-4F5F-B24F-E4732D7CD71E'

			-- 'Cuenta corriente Clientes - Resumen'
			EXEC msdb.dbo.sp_start_job N'F6941B97-3A00-4332-8C74-1F178C1FA9F4'

			-- 'Aging Clientes - China'
			EXEC msdb.dbo.sp_start_job N'E62EBB77-BB13-4E49-ACFE-20FCB8D65D94'

			-- 'Saldo deuda Cuenta Corriente'
			EXEC msdb.dbo.sp_start_job N'C27F5609-919D-4B40-BC6C-41AC3FC6337E'

	END