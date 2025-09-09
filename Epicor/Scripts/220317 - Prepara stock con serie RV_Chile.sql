
SET DATEFORMAT DMY
GO

USE		RVF_Local
GO

/*

DROP TABLE	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP1
DROP TABLE	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP2
DROP TABLE	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP3

*/

---------------------------------------------------------

IF OBJECT_ID('tempdb.dbo.#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP1', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP1	
	ELSE

CREATE TABLE	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP1	(
															Company					VARCHAR(15), 
															Plant					VARCHAR(15), 
															WareHseCode				VARCHAR(15), 
															BinNum					VARCHAR(15), 
															PartNum					VARCHAR(50), 
															ReasonCode				VARCHAR(15), 
															TranDate				DATE, 
															AdjustQuantity			INT
															)

INSERT INTO 	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP1

VALUES	

---------------------------------------------------------

('CL01', 'MfgSys', '001', 'STGREC', '0218-102570', 'INICMERC', '31/01/2022', 777),
('CL01', 'MfgSys', '001', 'STGREC', '0818-760121', 'INICMERC', '31/01/2022', 11),
('CL01', 'MfgSys', '001', 'STGREC', '1620-001302-UI', 'INICMERC', '31/01/2022', 25),
('CL01', 'MfgSys', '001', 'STGREC', '1620-001302-UE', 'INICMERC', '31/01/2022', 25),
('CL01', 'MfgSys', '001', 'STGREC', '1620-001306-UI', 'INICMERC', '31/01/2022', 12),
('CL01', 'MfgSys', '001', 'STGREC', '1620-001306-UE', 'INICMERC', '31/01/2022', 12)

---------------------------------------------------------

IF OBJECT_ID('tempdb.dbo.#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP2', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP2	
	ELSE

CREATE TABLE	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP2	(
															Company					VARCHAR(15), 
															Plant					VARCHAR(15), 
															WareHseCode				VARCHAR(15), 
															BinNum					VARCHAR(15), 
															PartNum					VARCHAR(50), 
															ReasonCode				VARCHAR(15), 
															TranDate				DATE, 
															AdjustQuantity			INT, 
															Linea					INT
															)

INSERT INTO 	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP2

SELECT			*, 
				ROW_NUMBER() OVER	(
									ORDER BY Company, Plant, WareHseCode, BinNum, PartNum 
									)													AS Linea

FROM			#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP1


---------------------------------------------------------

DECLARE			@Contador1	INT		=		1,				-- Numero de serie dentro de la linea en proceso
				@Contador2	INT		=		1,				-- Numero de linea en proceso
				@Contador3	INT		=		1				-- Muestra el total de registros a procesar 

---------------------------------------------------------

IF OBJECT_ID('tempdb.dbo.#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP3', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP3	
	ELSE

CREATE TABLE	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP3	(
															Company					VARCHAR(15), 
															Plant					VARCHAR(15), 
															WareHseCode				VARCHAR(15), 
															BinNum					VARCHAR(15), 
															PartNum					VARCHAR(50), 
															ReasonCode				VARCHAR(15), 
															TranDate				DATE, 
															AdjustQuantity			INT, 
															)

-- Busco la cantidad de registros que hay en la tabla temporal para saber cuantas veces hay que iterar

SELECT			@Contador3		=		COUNT(*)
FROM			#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP1

---------------------------------------------------------

WHILE			@Contador2	<=		@Contador3 

BEGIN

	SET				@Contador1	=		1				-- Inicializo el numero de serie dentro de la linea en proceso

	BEGIN

		WHILE			@Contador1	<=		(
											SELECT			AdjustQuantity
											FROM			#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP2
											WHERE			@Contador2		=		Linea
											)

		BEGIN
		
			INSERT INTO 	#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP3

			SELECT			T2.Company, T2.Plant, T2.WareHseCode, T2.BinNum, T2.PartNum, T2.ReasonCode, T2.TranDate, T2.AdjustQuantity 
			FROM			#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP2			T2
			WHERE			@Contador2		=		Linea	
		
			SET				@Contador1		=		@Contador1 + 1
		
		END

	END

	SET				@Contador2		=		@Contador2 + 1

END 

----------------------------------------------------------

SELECT			Company, Plant, WareHseCode, BinNum, PartNum, ReasonCode, TranDate, 
				1																		AS	AdjustQuantity, 
				ROW_NUMBER() OVER	(
									ORDER BY Company, Plant, WareHseCode, BinNum, PartNum 
									)													AS	SerialNumber  

FROM			#RVF_TBL_PRUEBA_SERIES_CHILE_PILOT_TEMP3
ORDER BY		Company, Plant, WareHseCode, BinNum, PartNum

----------------------------------------------------------
