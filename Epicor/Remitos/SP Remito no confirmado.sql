USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_CONTROL_REMITOS_NO_CONFORMADOS]    Script Date: 4/13/2021 10:33:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
ALTER PROCEDURE		[dbo].[RVF_PRC_CONTROL_REMITOS_NO_CONFORMADOS]
AS
*/

SET DATEFORMAT DMY

DECLARE					@FechaDesde DATETIME		=		DATEADD(d, -7, CAST(GETDATE() AS DATE)),		-- Ultimos 7 dias
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

SELECT				NumeroRemito, JobID, FechaConforme, FechaActualizacion
FROM				[CORPSQLMULT01].RV_Remitos.dbo.SyncEpicor							WITH (NoLock)	
WHERE				FechaActualizacion			BETWEEN			@FechaDesde		AND		@FechaHasta 

----------------------------------------------------------------
--INSERT INTO				RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS
SELECT					--top 10
						UDA.Company,
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
						DV.FechaConforme, 
						DV.FechaActualizacion,								-- Utilizar como fecha de corte de control
						DV.JobId, 
						DATEDIFF(dd, SH.ShipDate, DV.FechaConforme)			AS DiasDemoraEnvio
FROM					[CORPEPIDB].EpicorERP.Ice.UD110A		UDA				WITH (NoLock)
LEFT OUTER JOIN			(
						SELECT					*
						FROM					[CORPEPIDB].EpicorERP.Erp.ShipHead						WITH (NoLock)
						--WHERE					ShipDate 			BETWEEN			@FechaDesde		AND		@FechaHasta 
						)			SH
	ON					UDA.Company				=			SH.Company
	AND					UDA.Number06			=			SH.PackNum 
INNER JOIN				[CORPEPIDB].EpicorERP.Erp.ShipHead_UD	SHU				WITH (NoLock)
	ON					SH.SysRowID				=			SHU.ForeignSysRowID
INNER JOIN				(
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

	ON					UDA.ShortChar07						=			DV.NroRemito				COLLATE Modern_Spanish_CI_AS

WHERE					UDA.CheckBox02						=			0							-- No tiene la marca de Remito Conforme en Epicor	
	OR					(
						ISNULL(SHU.RV_FechaConforme_c, '')	<>			DV.FechaConforme			-- Tiene diferencia entre la fechadel remito y la fecha conforme de la digitalizacion 
						AND 
						DV.FechaConforme					IS NOT NULL
						)
ORDER BY				1, 2, 3, 4, 5, 6, 7, 8


GO


