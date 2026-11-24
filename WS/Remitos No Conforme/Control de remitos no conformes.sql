/**********************************************************
				Integracion SC
***********************************************************/
--Exec [RNC].[RVF_PRC_BUSCA_REMITOS_NO_CONFORMADOS]
--truncate table RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS
select  * from RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS
ORDER BY 1, 2, 3, 4, 7, 8 

select * from [RNC].RVF_TBL_REMITOS_No_CONFORMADOS
select * from RV_TBL_SIP_LOG_TP
--where Codigo LIKE 'RNC%'
ORder by Fecha desc

Select			NumeroRemito, FechaConforme, FechaActualizacion, FechaDigitalizacion, PackNum 
from			[CORPE11-SSRS].[RVF_Local].dbo.RVF_TBL_CONTROL_CONFORME_FECHA_CONFORME_REMITOS A
inner join		[CORPE11-EPIDB].EpicorERP.dbo.ShipHead B
on				a.NumeroRemito		=	b.LegalNumber
where 			FechaDigitalizacion >	'2026-01-01' 
and				company				=	'CO01' 
and				RV_FechaConforme_c	is  null
-----------------------------------------------------------

SELECT		*
FROM		[CORPE11-EPIDB].EpicorERP.Ice.UD16
WHERE		
			KEY1='UpdShipDate'
AND			Key2=329834
order by Date01 desc



SELECT		*
FROM		[CORPE11-EPIDB].EpicorERP.Ice.UD110A
WHERE		
			Company='CO01'	
AND			Key1='ViajeCab'	
AND			Number06=329834
AND			Key2='MPlace'
AND			Key3='00057146'	
AND			Key4=''
AND			Key5=''

SELECT		*
FROM		[CORPE11-EPIDB].EpicorERP.Ice.UD16
WHERE		
			Character01='Prueba API'
order by Date01 desc

SELECT		*
FROM		[CORPE11-EPIDB].EpicorERP.Ice.UD110A
WHERE		
			Character01='Prueba API'


SELECT		*
FROM		[CORPE11-EPIDB].EpicorERP.Ice.UD110A
WHERE		
			Company='CO01'	
AND			Key1='ViajeCab'	
AND			Number06=329834
AND			Key2='MPlace'
AND			Key3='00057146'	
AND			Key4=''
AND			Key5=''
SELECT		*
FROM		[CORPE11-EPIDB].EpicorERP.Ice.UD110
WHERE		
			Company='CO01'	
AND			Key1='ViajeCab'	
AND			Key2='CDEE'
AND			Key3='00057543'	
AND			Key4=''
AND			Key5=''

SELECT		*
FROM		[CORPE11-EPIDB].EpicorERP.Ice.UD110A
WHERE		
			Company='CO01'	
AND			Key1='ViajeCab'	
AND			Key2='CDEE'
AND			Key3='00057543'	
AND			Key4=''
AND			Key5=''
	
order by Date01 desc


SET DATEFORMAT DMY

DECLARE					@FechaDesde DATETIME		=		DATEADD(d, -180, CAST(GETDATE() AS DATE)),		-- Ultimos 30 dias
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
FROM				[CORPSQLMULT2019].RV_Remitos.dbo.SyncEpicor							WITH (NoLock)	
WHERE				FechaActualizacion			BETWEEN			@FechaDesde		AND		@FechaHasta 
AND					FechaConforme is not null

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