begin tran
DECLARE 
	@Company nvarchar(10) = 'CO01',--Modificar 'CO02'
	@ClassID nvarchar(50) = 'PTF', --Modificar PTCO
	@Estado nvarchar(50) = 'Pendiente',
	@FechaHora datetime,
	@partnum nvarchar(20) = 'R25DG',--Modificar 6125A-BALCAR11
	@OT nvarchar(20) = 'ME000001', --Modificar
	@serialRange nvarchar(20) = 'RO23023', --Modificar
	@serialNo int = 1, --Modificar justo el numero a crear
	@Time int = 8,
	@CantidadSerie int = 500, --Modificar cantidad exacta
	@i int = 1

-- Generar un hora estimativa de proceso
SET @FechaHora = DATEADD(MINUTE, 30, GETDATE())

WHILE @i <= @CantidadSerie
BEGIN
	SET @Time = @Time + (30 * @i)

	
	DECLARE @formattedSerialNo varchar(8);
	SET @formattedSerialNo = RIGHT(REPLICATE('0', 8) + CAST(@serialNo AS VARCHAR(8)), 8);

	DECLARE @concatenatedString nvarchar(15);
	SET @concatenatedString = CONCAT(@serialRange, @formattedSerialNo);

	INSERT INTO [CORPLAB-DB-01\LABDB01].[SIP].dbo.[SeriesFabricadas] (
																		[Company], 
																		[OT], 
																		[PartNum],	
																		[ClassID],	
																		[Serie], 
																		[HoraFabricacion],	
																		[Estado], 
																		[Fecha]
																	)
	VALUES 
																	(
																		@Company,
																		@OT, 
																		@partnum,
																		@ClassID,
																		@concatenatedString,
																		DATEADD(MINUTE, @Time, @FechaHora),
																		@Estado,
																		NULL
																	);

	SET @i = @i + 1;
	SET @serialNo=@serialNo+1;
END

--commit tran
--rollback tran

select			*
from			[CORPLAB-DB-01\LABDB01].[SIP].dbo.[SeriesFabricadas]
where			OT=@OT
AND				Estado ='Pendiente'
and  (ot LIKE 'rv0%'
		OR
	  ot LIKE 'SO0%'
	  OR
	  ot LIKE 'ME0%'
	 )
--and	Serie LIKE '%758%'

order by 1,2,5


--update [CORPLAB-DB-01\LABDB01].[SIP].dbo.[SeriesFabricadas]
--set  ClassID='PTCO'
--where
--OT='SO000001'
--AND ClassID='PTF'