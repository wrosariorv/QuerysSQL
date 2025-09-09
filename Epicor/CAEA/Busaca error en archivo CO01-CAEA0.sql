
BEGIN

--CABECERA
	--Creo Tabla temporal
	IF OBJECT_ID('tempdb.dbo.#caeatemp', 'U') IS NOT NULL
		TRUNCATE TABLE #caeatemp	
	ELSE
		CREATE TABLE #caeatemp (linea varchar(2000))
		BULK INSERT #caeatemp FROM '\\CORPFACSRV01\caea\Archivos\CO01-CAEA0.txt'

		select * from #caeatemp
    INSERT INTO Comprobantes

		SELECT 
			CAST(SUBSTRING(Linea,1,1) AS DECIMAL(1,0))								[IDEREG0],	--[decimal](1, 0) NULL,
			CAST(SUBSTRING(Linea,2,3) AS DECIMAL(3,0))								[TIPCBT],	--[decimal](2, 0) NULL,
			CAST(SUBSTRING(Linea,5,4) AS DECIMAL(4,0))								[PVENTA],	--[decimal](4, 0) NULL,
			CAST(SUBSTRING(Linea,9,8) AS DECIMAL(8,0))								[NROCBT],	--[decimal](8, 0) NULL,
			SUBSTRING(Linea,17,8)													[FECHAE],	--[varchar](8) NULL,
			SUBSTRING(Linea,25,1)													[TIPAUT],	--[varchar](1) NULL,
			SUBSTRING(Linea,26,50)													[CODAUT],	--[varchar](50) NULL,
			SUBSTRING(Linea,76,8)													[FECVEN],	--[varchar](8) NULL,
			CAST(SUBSTRING(Linea,84,2) AS DECIMAL(2,0))								[TIPDOC],	--[decimal](2, 0) NULL,
			SUBSTRING(Linea,86,15)													[NRODOC],	--[varchar](15) NULL,
			CAST(CAST(SUBSTRING(Linea,101,15) AS FLOAT)/1000 AS DECIMAL(15,3))		[IMPGRA],	--[decimal](15, 3) NULL,
			CAST(CAST(SUBSTRING(Linea,116,15) AS FLOAT)/1000 AS DECIMAL(15,3))		[IMPNGR],	--[decimal](15, 3) NULL,
			CAST(CAST(SUBSTRING(Linea,131,15) AS FLOAT)/1000 AS DECIMAL(15,3))		[IMPEXE],	--[decimal](15, 3) NULL,
			CAST(CAST(SUBSTRING(Linea,146,15) AS FLOAT)/1000 AS DECIMAL(15,3))		[IMPSTO],	--[decimal](15, 3) NULL,
			CAST(CAST(SUBSTRING(Linea,161,15) AS FLOAT)/1000 AS DECIMAL(15,3))		[IMPOTR],	--[decimal](15, 3) NULL,
			CAST(CAST(SUBSTRING(Linea,176,15) AS FLOAT)/1000 AS DECIMAL(15,3))		[IMPTOT],	--[decimal](15, 3) NULL,
			SUBSTRING(Linea,191,3)													[MONEDA],	--[varchar](3) NULL,
			CAST(CAST(SUBSTRING(Linea,194,19) AS FLOAT)/1000000 AS DECIMAL(19,6))	[COTIZA],	--[decimal](19, 6) NULL,
			SUBSTRING(Linea,213,500)												[OBSERV],	--[varchar](500) NULL,
			CAST(SUBSTRING(Linea,713,1)	 AS DECIMAL(1,0))							[CPTO],		--[decimal](1, 0) NULL,
			SUBSTRING(Linea,714,8)													[FECSED],	--[varchar](8) NULL,
			SUBSTRING(Linea,722,8)													[FECSEH],	--[varchar](8) NULL,
			SUBSTRING(Linea,730,8)													[FECVEP],	--[varchar](8) NULL,
			CAST(SUBSTRING(Linea,738,11) AS DECIMAL(11,0))							[CUIT],		--[decimal](11, 0) NULL,
			SUBSTRING(Linea,749,1)													[RESUL],	--[varchar](1) NULL,
			CAST(SUBSTRING(Linea,750,14) AS DECIMAL(14,0))							[CAEA],		--[decimal](14, 0) NULL,
			SUBSTRING(Linea,764,8)													[FECPRO],	--[varchar](8) NULL,
			SUBSTRING(Linea,772,1000)												[MOTIVO],	--[varchar](1000) NULL,
			SUBSTRING(Linea,1772,6)													[CODERR],	--[varchar](6) NULL,
			CAST(SUBSTRING(Linea,1778,8) AS DECIMAL(8,0))							[CLAVE0]	--[decimal](8, 0) NOT NULL,

		FROM #caeatemp;
END



GO


