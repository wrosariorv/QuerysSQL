	DECLARE @FileOK  INT;
--CABECERA
	--Creo Tabla temporal
	IF OBJECT_ID('tempdb.dbo.#ImportarSueldos', 'U') IS NOT NULL
		TRUNCATE TABLE #ImportarSueldos	
	ELSE
		CREATE TABLE #ImportarSueldos (linea varchar(2000))
	
	--Inserto las lineas en tabla temporal
	EXEC xp_fileExist '\\CORPEPIAPP01\EpicorData\Sueldos\sueldos.txt' ,@FileOK OUTPUT	
	IF @FileOK = 1
	
		BULK INSERT #ImportarSueldos FROM '\\CORPEPIAPP01\EpicorData\Sueldos\sueldos.txt'

		select * from #ImportarSueldos