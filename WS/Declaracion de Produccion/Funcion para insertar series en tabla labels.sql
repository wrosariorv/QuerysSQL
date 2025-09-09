
-- Generar la fecha actual más 30 minutos
DECLARE @FechaHora datetime,
		@partnum nvarchar(20)='T766J-FALCAR11',
		@OT nvarchar(20)='RV000040',--Modificar
		@CodMaster nvarchar(10)='TEST02',--Modificar
		@turno nvarchar(10)='Manaña',
		@serialRange nvarchar(20)='RT33562000000',
		@serialNo nvarchar(20)='73',--Modificar Uno menos del deseado
		@linea nvarchar(10)='CEL1',
		@Codigo varchar(20)='',
		@Time int='30',
		@CantidadSerie int =6,--Modificar
		@i int=1,
		@Indice int=0,
		@CaracteresPermitidos varchar(37)

-- Generar un hora estimativa de proceso
SET		@FechaHora			=		DATEADD(MINUTE, 30, GETDATE())



-- Llenar el código con caracteres aleatorios
SET @CaracteresPermitidos	 =		'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'




WHILE @i <= @CantidadSerie
BEGIN
		--Creo el Codigo del MSN
		WHILE @Indice <= 20
		BEGIN
				SET @Codigo = @Codigo + SUBSTRING(@CaracteresPermitidos, CAST((RAND() * 37) + 1 AS int), 1)
				SET @Indice = @Indice + 1
		END


		SET @Time=@Time+(30*@i)

		-- Insertar los datos en la tabla
		INSERT INTO [CORPLAB-DB-01\LABDB01].[SIP].dbo.[Labels] (msn, SerialRV, TimeDevice, TimeGift, TimeMaster, CodMaster, OT, ModeloRV, PCBA, MMI1, MMI2, Linea, Turno)
		VALUES ( @Codigo, CONCAT(@serialRange,(@serialNo+@i)), @FechaHora, DATEADD(MINUTE, @Time, @FechaHora),DATEADD(MINUTE, (@Time*1.5), @FechaHora),@CodMaster,
				@OT,@partnum,DATEADD(MINUTE, (@Time*2),@FechaHora),DATEADD(MINUTE, (@Time*2.5),@FechaHora),DATEADD(MINUTE, (@Time*3),@FechaHora),@linea,@turno )

		SET @i=@i+1
		SET @Indice=0
		SET @Codigo=''


END


--Muestro Resultado

select * from Labels
where
CodMaster='TEST02'
order by 2