SET DATEFORMAT DMY

DECLARE					@FechaDesde DATETIME		=		DATEADD(YEAR, -1, CAST(GETDATE() AS DATE)),		-- Ultimos 30 dias
						@FechaHasta DATETIME		=		CAST(GETDATE() AS DATE)							-- Fecha actual

----------------------------------------------------------------

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
					DISTINCT
					NumeroRemito, JobID, FechaConforme, FechaActualizacion
					--*
FROM				[CORPSQLMULT2019].RV_Remitos.dbo.SyncEpicor							WITH (NoLock)	
WHERE				/*FechaActualizacion			BETWEEN			@FechaDesde		AND		@FechaHasta 
AND					*/FechaConforme is not null




SELECT					A.Company, A.NroViaje, A.NroRemito, A.NroLegal, A.NroOrden, A.NroInterno, A.NroEmpaque, A.Producto, A.Cantidad, 
						A.ReservedQty, A.CantidadOrden, A.Linea, A.Conforme, A.FechaViaje, A.InvoiceDate, A.CustNum, A.Name, 
						P.SearchWord, P.PartDescription, P.ClassID, P.ProdCode, 
						PUD.Character02,
						DV.FechaConforme, 
						DV.FechaActualizacion,								-- Utilizar como fecha de corte de control
						DV.JobId, 
						DATEDIFF(dd, A.FechaViaje, DV.FechaConforme)			AS DiasDemoraEnvio
FROM					[CORPE11-SSRS].[RVF_Local].dbo.RVF_VW_ANALISIS_ORDEN_VIAJE_REMITO_FACTURA			A			With (NoLock)
LEFT OUTER JOIN			[CORPE11-EPIDB].EpicorERP.Erp.Part					P			With (NoLock)
	ON					A.Company		=		P.Company
	AND					A.Producto		=		P.PartNum
INNER JOIN				[CORPE11-EPIDB].EpicorERP.Erp.Part_UD					PUD			With (NoLock)
	ON					P.SysRowID		=		PUD.ForeignSysRowID
LEFT JOIN				(
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
						) AS DV
	ON					A.NroRemito				=			DV.NroRemito				COLLATE Modern_Spanish_CI_AS
WHERE				A.NroViaje		<>		0
	AND 			A.NroEmpaque	<>		0
	AND				A.Conforme		=		0
	AND				FechaConforme	is not null