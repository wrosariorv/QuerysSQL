IF OBJECT_ID('tempdb.dbo.#RVF_VW_INFORMACION_DOC_VISION_TEMP1', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_VW_INFORMACION_DOC_VISION_TEMP1
	ELSE

CREATE TABLE		#RVF_VW_INFORMACION_DOC_VISION_TEMP1
												(
												NumeroRemito				VARCHAR(30), 
												JobID						INT, 
												FechaConforme				DATETIME, 
												FechaActualizacion			DATETIME
												)

INSERT INTO			#RVF_VW_INFORMACION_DOC_VISION_TEMP1

SELECT				
					--DISTINCT
					NumeroRemito, JobID, FechaConforme, FechaActualizacion
FROM				[RNC].SyncEpicor	WITH (NoLock)	--[CORPSQLMULT2019].RV_Remitos.dbo.SyncEpicor  WITH (NoLock)	Se cambia vista local
WHERE				/*FechaActualizacion			BETWEEN			DATEADD(YEAR, -1, CAST(GETDATE() AS DATE))		AND		CAST(GETDATE() AS DATE) 
AND					FechaConforme is not null
AND					*/NumeroRemito='R-0247-00092809'


SELECT			CASE
				WHEN	LEN (SYE.NumeroRemito) = 15 THEN SYE.NumeroRemito
				ELSE	CONCAT('R-',SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),1,4),'-', SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),5,8)) 
				END		AS NroRemito,	
				SYE.JobID, SYE.FechaConforme, SYE.FechaActualizacion

FROM			#RVF_VW_INFORMACION_DOC_VISION_TEMP1			SYE					WITH(NoLock)
INNER JOIN		(
				SELECT			NumeroRemito, MAX(FechaActualizacion) AS FechaActualizacion 
				FROM			#RVF_VW_INFORMACION_DOC_VISION_TEMP1				WITH(NoLock)
				GROUP BY		NumeroRemito
				)			M
	ON			SYE.NumeroRemito			=				M.NumeroRemito
	AND			SYE.FechaActualizacion		=				M.FechaActualizacion

select					UDA.Company,
						UDA.Key1, 
						UDA.Key2,
						UDA.Key3,											-- Numero de Viaje 
						UDA.Key4, 
						UDA.Key5,
						UDA.ChildKey1,
						UDA.ChildKey2,
						UDA.ChildKey3,
						UDA.ChildKey4,
						UDA.ChildKey5,
						UDA.CheckBox02, 									-- Marca Conforme 
						FLOOR(UDA.Number06)									AS NumeroInternoRemito, 
						UDA.ShortChar07										AS NumeroRemito, 
						FLOOR(UDA.Number08) 								AS NumeroInternoFactura, 
						UDA.ShortChar09										AS NumeroFactura, 
						SH.ShipDate, 
						--DV.FechaConforme,
						--ISNULL(SHU.RV_FechaConforme_c, '')					AS ShipHead_UD_RV_FechaConforme_c,
						--DV.FechaActualizacion,								-- Utilizar como fecha de corte de control
						--DV.JobId, 
						--DATEDIFF(dd, SH.ShipDate, DV.FechaConforme)			AS DiasDemoraEnvio,
						'UpdShipDate'										AS UD16_Key1
FROM					[CORPE11-EPIDB].EpicorERP.Ice.UD110A		UDA				WITH (NoLock)
LEFT OUTER JOIN			(
						SELECT					*
						FROM					[CORPE11-EPIDB].EpicorERP.Erp.ShipHead						WITH (NoLock)
						WHERE					ShipDate 			BETWEEN			DATEADD(YEAR, -1, CAST(GETDATE() AS DATE))		AND		CAST(GETDATE() AS DATE) 
						)			SH
	ON					UDA.Company				=			SH.Company
	AND					UDA.Number06			=			SH.PackNum 
INNER JOIN				[CORPE11-EPIDB].EpicorERP.Erp.ShipHead_UD	SHU				WITH (NoLock)
	ON					SH.SysRowID				=			SHU.ForeignSysRowID

where UDA.Number06=329826

SELECT					SH.LegalNumber,ISNULL(SHU.RV_FechaConforme_c, '')					AS ShipHead_UD_RV_FechaConforme_c,SH.*
FROM					[CORPE11-EPIDB].EpicorERP.Erp.ShipHead				SH		WITH (NoLock)

INNER JOIN				[CORPE11-EPIDB].EpicorERP.Erp.ShipHead_UD	SHU				WITH (NoLock)
	ON					SH.SysRowID				=			SHU.ForeignSysRowID
where					LegalNumber like 'R-0247-00092235'


select UDA.CheckBox02,* from [CORPE11-EPIDB].EpicorERP.Ice.UD110A		UDA	
where
UDA.Number06=329826