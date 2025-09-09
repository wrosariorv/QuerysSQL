USE [WS]
GO


/*

ALTER PROCEDURE	[dbo].[RV_PRC_SIP_OT_ACTUALIZA_ESTADO_FABRICA]
AS

--*/

DECLARE		@TablaTemporal	TABLE	(	
										Company			VARCHAR(10),
										PartNum			VARCHAR(50),
										SerialNumber	VARCHAR(20),
										JobNum			VARCHAR(10),
										SNStatus		VARCHAR(20)
									)

INSERT INTO @TablaTemporal
--SELECT		Company,PartNum,SerialNumber,JobNum, SNStatus		
--FROM		[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo		WITH (NoLock)
--WHERE		SNStatus			=			'INVENTORY'
--AND			SerialNumber		IN			(
--												SELECT			Serie
--												FROM			[PLANSQLMULT01].[SIP].[dbo].[SeriesFabricadas] WITH (NoLock)
--												WHERE			Estado <> 'Integrado'
--											)
SELECT
				SN.Company,
				SN.PartNum,
				SN.SerialNumber,
				SN.JobNum,
				SN.SNStatus
FROM
				[CORPE11-EPIDB].[EpicorERP].Erp.SerialNo SN WITH (NOLOCK)
WHERE EXISTS	(
					SELECT		SF.Serie
					FROM		[PLANSQLMULT01].[SIP].[dbo].[SeriesFabricadas] SF WITH (NOLOCK)
					WHERE		SN.Company		=		SF.Company
					AND			SN.PartNum		=		SF.PartNum
					AND			SN.SerialNumber =		SF.Serie
					AND			SN.CreateDate	>=		'2023-01-01'--DATEADD(YEAR, -1, GETDATE())
					AND			SN.JobNum		=		SF.OT
					AND			SF.Estado		<>		'Integrado'
				)
AND				SN.SNStatus			<>		'WIP';

SELECT			
				SN.Company,
				SN.JobNum,
				ISNULL(I.TranNum,0)				AS TranNum,
				ISNULL(PT.TranNumEpicor,'')		AS TranNumEpicor,
				sn.PartNum, 
				ISNULL(I.Linea,0)				AS Linea,
				--SN.SerialNumber,
				SN.SerialNumber,
				--I.Estado,
				CASE
						WHEN	(
									SN.SNStatus		=		'INVENTORY'
								AND 
									I.Estado		IS NOT NULL
								)									
						THEN	'Integrado'
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

					WHERE			E.Fecha				>=			DATEADD(DAY, -3, GETDATE())
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
				AND					PATINDEX('%[0-9]%', PT.TranReference) <> 0

			) PT 
ON			I.Company		=		PT.Company
AND			I.OT			=		PT.JobNum 
AND			I.PartNum		=		PT.Partnum
AND			I.TranNum		=		PT.TranNum

			

GO


