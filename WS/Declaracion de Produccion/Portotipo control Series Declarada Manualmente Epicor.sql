DECLARE		@TablaTemporal	TABLE	(	
										Company			VARCHAR(10),
										PartNum			VARCHAR(50),
										SerialNumber	VARCHAR(20),
										JobNum			VARCHAR(10),
										SNStatus		VARCHAR(20),
										Origen			VARCHAR(10),
										Estado			VARCHAR(50)
									)

INSERT INTO @TablaTemporal

SELECT			SN.Company,
				SN.PartNum,
				SN.SerialNumber,
				SN.JobNum,
				SN.SNStatus,
				C.Origen,
				C.Estado
FROM			(
						SELECT  SF.Company,
								SF.PartNum,
								SF.Serie            AS SerialNumber,
								SF.OT               AS JobNum,
								SF.HoraFabricacion  AS FechaAlta,
								'SIP'				AS Origen,
								Estado
						FROM    [PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas] SF WITH (NOLOCK)
						WHERE   
								SF.Estado IN ('Procesando','Pendiente')
								--SF.Estado NOT IN ('Integrado','Cancelado')
						AND     SF.HoraFabricacion     >= DATEADD(MONTH, -1, GETDATE())
						---------
						UNION ALL
						---------
						SELECT  
								DISTINCT
								RF.Company,
								RF.PartNum,
								RF.SerialNumber,
								RF.OT				AS JobNum,
								RF.FechaAlta,
								'RFID'				AS Origen,
								Estado
						FROM    [WS].[RF].[RV_TBL_SIP_RFID_SERIE] RF WITH (NOLOCK)
						WHERE   
								RF.Estado IN ('Procesando','Pendiente')
								--RF.Estado NOT IN ('Integrado','Cancelado','ERROR')
						AND     FechaAlta     >= DATEADD(MONTH, -1, GETDATE())
				) AS C
 INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo SN WITH (NOLOCK)
  ON			SN.Company			=		C.Company
  AND			SN.PartNum			=		C.PartNum
  AND			SN.SerialNumber		=		C.SerialNumber
  AND			SN.JobNum			=		C.JobNum


  IF((SELECT COUNT(*) FROM @TablaTemporal) = 0 )
  BEGIN
		 SELECT
				CAST(NULL AS varchar(10))  AS Company,
				CAST(NULL AS varchar(50))  AS OT,
				CAST(NULL AS int)          AS TranNum,
				CAST(NULL AS int)          AS TranNumEpicor,
				CAST(NULL AS varchar(50))  AS PartNum,
				CAST(NULL AS int)          AS Linea,
				CAST(NULL AS varchar(20))  AS Serie,
				CAST(NULL AS varchar(10))  AS Origen,
				CAST(NULL AS varchar(20))  AS Estado,
				CAST(NULL AS datetime)     AS Fecha
		WHERE 1 = 0;

		RETURN;
END

SELECT			
				SN.Company,
				SN.JobNum						AS OT,
				ISNULL(I.TranNum,0)				AS TranNum,
				ISNULL(PT.TranNumEpicor,0)		AS TranNumEpicor,
				sn.PartNum, 
				ISNULL(I.Linea,0)				AS Linea,
				--SN.SerialNumber,
				SN.SerialNumber					AS Serie,
				SN.Origen,
				I.Estado
				,SN.SNStatus
				,SN.Estado AS EstadoTemporal,
				
				
				CASE
						----Series pendientes por declarar
						--WHEN	(
						--			SN.SNStatus			IN		('WIP')
						--		AND
						--			PT.TranNumEpicor	IS NULL
						--		AND 
						--			I.Estado			IS NOT NULL
						--		AND
						--			SN.Estado			in ('Pendiente','Procesando')
						--		)									
						--THEN	'OK'
						----Series  declaradas pendiente de actualizar
						--WHEN	(
						--			SN.SNStatus			<>		'WIP'
						--		AND
						--			PT.TranNumEpicor	IS NOT NULL
						--		AND 
						--			I.Estado			IS NOT NULL
						--		AND
						--			SN.Estado			in ('Procesando')
						--		)									
						--THEN	'OK'
						WHEN	(
									SN.SNStatus			<>		'WIP'
								AND
									SN.Estado			in		('Pendiente')
								AND
									PT.TranNumEpicor	<>		0
								
								)
						THEN	'DECLARADO EN EPICOR'
						ELSE	'Cancelado'
				END								AS Estado,
				GETDATE()						AS Fecha
FROM			@TablaTemporal		SN

LEFT JOIN		
				(
					SELECT			E.Company,
									E.OT,
									E.PartNum, 
									E.TranNum,
									I.Linea,
									I.Serie,
									I.SNStatus,
									E.Estado AS EstadoEncabezado,
									I.Estado 

					FROM			[WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P	E		WITH (NoLock)

					INNER JOIN		[WS].[dbo].RV_TBL_SIP_ITEM_TP						I		WITH (NoLock)
					ON				E.Company			=			I.Company
					AND				E.OT				=			I.OT
					AND				E.PartNum			=			I.PartNum
					AND				E.TranNum			=			I.TranNum

					WHERE			E.Fecha				>=			DATEADD(MONTH, -1, GETDATE())
					AND				
									(
											E.Estado			=			'Integrado'
									AND		I.Estado			=			'Integrado'
									)
							
				) AS I
ON				SN.Company			=			I.Company
AND				SN.PartNum			=			I.PartNum
AND				SN.SerialNumber		=			I.Serie
AND				SN.JobNum			=			I.OT

LEFT JOIN (
				-- Subconsulta para validar existencia de la Partran Epicor
				SELECT
									PT.Company, 
									PT.JobNum,
									CAST(PT.TranNum AS int) AS TranNumEpicor,
									CAST(RIGHT(PT.TranReference, LEN(PT.TranReference) - CHARINDEX('-', REVERSE(PT.TranReference))) AS INT) AS TranNum,														
									PT.Partnum,
									PT.TranReference,
									CAST(PT.TranQty AS int) AS TranQty
									--,*
				FROM				[WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P	E		WITH (NoLock)
				INNER JOIN			[CORPE11-EPIDB].[EpicorERP].Erp.PartTran			PT		WITH (NoLock)
				ON					E.Company			=			PT.Company						
				AND					E.OT				=			PT.Jobnum						
				AND					E.PartNum			=			PT.PartNum	
				AND					E.TranNum			=			CAST(RIGHT(PT.TranReference, LEN(PT.TranReference) - CHARINDEX('-', REVERSE(PT.TranReference))) AS INT)
				WHERE
									PT.TranType		=		'MFG-STK'
				AND					E.TranNum								<> 0
				AND					PATINDEX('%[0-9]%', PT.TranReference)	<> 0
				
			) PT 
ON			SN.Company		=		PT.Company
AND			SN.JobNum		=		PT.JobNum 
AND			SN.PartNum		=		PT.Partnum
AND			I.TranNum		=		PT.TranNum
WHERE
					(
						SN.SNStatus			NOT IN		('WIP')
					AND
						PT.TranNumEpicor	NOT IN (NULL , 0)
					AND 
						I.Estado			IS NOT NULL
					AND
						SN.Estado			NOT in ('Pendiente','Procesando')
					)
	AND
			
					(
						SN.SNStatus			=		'WIP'
					AND
						SN.Estado			NOT in ('Pendiente')
					AND
						(	
							PT.TranNumEpicor	IS NOT NULL
						or
							PT.TranNumEpicor	<> 0
						)
					)

/***************************************************************
Version Final
****************************************************************/

DECLARE		@TablaTemporal	TABLE	(	
										Company			VARCHAR(10),
										PartNum			VARCHAR(50),
										SerialNumber	VARCHAR(20),
										JobNum			VARCHAR(10),
										SNStatus		VARCHAR(20),
										Linea			VARCHAR(10),
										Origen			VARCHAR(10),
										Estado			VARCHAR(50)
									)

INSERT INTO @TablaTemporal

SELECT			
				SN.Company,
				SN.PartNum,
				SN.SerialNumber,
				SN.JobNum,
				SN.SNStatus,
				C.PseudoLinea AS Linea,
				C.Origen,
				C.Estado
FROM			(
						SELECT  SF.Company,
								SF.PartNum,
								SF.Serie            AS SerialNumber,
								SF.OT               AS JobNum,
								SF.HoraFabricacion  AS FechaAlta,
								'CEL'					AS PseudoLinea,
								'SIP'				AS Origen,
								Estado
						FROM    [PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas] SF WITH (NOLOCK)
						WHERE   
								SF.Estado IN (/*'Procesando',*/'Pendiente')
								--SF.Estado NOT IN ('Integrado','Cancelado')
						AND     SF.HoraFabricacion     >= DATEADD(MONTH, -1, GETDATE())
						---------
						UNION ALL
						---------
						SELECT  
								DISTINCT
								RF.Company,
								RF.PartNum,
								RF.SerialNumber,
								RF.OT				AS JobNum,
								RF.FechaAlta,
								RF.PseudoLinea,
								'RFID'				AS Origen,
								Estado
						FROM    [WS].[RF].[RV_TBL_SIP_RFID_SERIE] RF WITH (NOLOCK)
						WHERE   
								RF.Estado IN (/*'Procesando',*/'Pendiente')
						AND		RF.PseudoLinea in ('TV1','TV2','TV3','TV4')
								--RF.Estado NOT IN ('Integrado','Cancelado','ERROR')
						AND     FechaAlta     >= DATEADD(MONTH, -1, GETDATE())
				) AS C
 INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo SN WITH (NOLOCK)
  ON			SN.Company			=		C.Company
  AND			SN.PartNum			=		C.PartNum
  AND			SN.SerialNumber		=		C.SerialNumber
  AND			SN.JobNum			=		C.JobNum
WHERE
		SN.SNStatus			<>  'WIP'


IF((SELECT COUNT(*) FROM @TablaTemporal) = 0 )
  BEGIN
		 SELECT
				CAST(NULL AS varchar(10))  AS Company,
				CAST(NULL AS varchar(50))  AS OT,
				CAST(NULL AS int)          AS TranNum,
				CAST(NULL AS int)          AS TranNumEpicor,
				CAST(NULL AS varchar(50))  AS PartNum,
				CAST(NULL AS int)          AS Linea,
				CAST(NULL AS varchar(20))  AS Serie,
				CAST(NULL AS varchar(10))  AS Origen,
				CAST(NULL AS varchar(20))  AS Estado,
				CAST(NULL AS datetime)     AS Fecha
		WHERE 1 = 0;

		RETURN;
END

SELECT * FROM @TablaTemporal

SELECT			
				SN.Company,
				SN.JobNum						AS OT,
				ISNULL(I.TranNum,0)				AS TranNum,
				ISNULL(PT.TranNumEpicor,0)		AS TranNumEpicor,
				sn.PartNum, 
				ISNULL(I.Linea,0)				AS Linea,
				--SN.SerialNumber,
				SN.SerialNumber					AS Serie,
				--SN.Linea,
				SN.Origen,
				I.Estado
				,SN.SNStatus
				,SN.Estado AS EstadoTemporal,
				
				
				CASE
						
						WHEN	(
									SN.SNStatus			<>		'WIP'
								
								AND
									(		ISNULL(PT.TranNumEpicor,0)		=		0
										OR
											ISNULL(I.TranNum,0)				=		0
									)
								)
						THEN	'DECLARADO EN EPICOR'
						ELSE	'Cancelado'
				END								AS Estado,
				GETDATE()						AS Fecha
FROM			@TablaTemporal		SN

LEFT JOIN		
				(
					SELECT			E.Company,
									E.OT,
									E.PartNum, 
									E.TranNum,
									I.Linea,
									I.Serie,
									I.SNStatus,
									E.Estado AS EstadoEncabezado,
									I.Estado 

					FROM			[WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P	E		WITH (NoLock)

					INNER JOIN		[WS].[dbo].RV_TBL_SIP_ITEM_TP						I		WITH (NoLock)
					ON				E.Company			=			I.Company
					AND				E.OT				=			I.OT
					AND				E.PartNum			=			I.PartNum
					AND				E.TranNum			=			I.TranNum

					WHERE			E.Fecha				>=			DATEADD(MONTH, -1, GETDATE())
					AND				
									(
											E.Estado			=			'Integrado'
									AND		I.Estado			=			'Integrado'
									)
							
				) AS I
ON				SN.Company			=			I.Company
AND				SN.PartNum			=			I.PartNum
AND				SN.SerialNumber		=			I.Serie
AND				SN.JobNum			=			I.OT

LEFT JOIN (
				-- Subconsulta para validar existencia de la Partran Epicor
				SELECT
									PT.Company, 
									PT.JobNum,
									CAST(PT.TranNum AS int) AS TranNumEpicor,
									CAST(RIGHT(PT.TranReference, LEN(PT.TranReference) - CHARINDEX('-', REVERSE(PT.TranReference))) AS INT) AS TranNum,														
									PT.Partnum,
									PT.TranReference,
									CAST(PT.TranQty AS int) AS TranQty
									--,*
				FROM				[WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P	E		WITH (NoLock)
				INNER JOIN			[CORPE11-EPIDB].[EpicorERP].Erp.PartTran			PT		WITH (NoLock)
				ON					E.Company			=			PT.Company						
				AND					E.OT				=			PT.Jobnum						
				AND					E.PartNum			=			PT.PartNum	
				AND					E.TranNum			=			CAST(RIGHT(PT.TranReference, LEN(PT.TranReference) - CHARINDEX('-', REVERSE(PT.TranReference))) AS INT)
				WHERE
									PT.TranType		=		'MFG-STK'
				AND					E.TranNum								<> 0
				AND					PATINDEX('%[0-9]%', PT.TranReference)	<> 0
				
			) PT 
ON			SN.Company		=		PT.Company
AND			SN.JobNum		=		PT.JobNum 
AND			SN.PartNum		=		PT.Partnum
AND			I.TranNum		=		PT.TranNum
WHERE
					SN.SerialNumber IN (
										'RT3392975478937','RT3392975478938','RT3392975478939','RT3392975478940'
										)
