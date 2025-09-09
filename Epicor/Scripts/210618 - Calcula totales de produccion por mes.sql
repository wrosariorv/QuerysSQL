
USE RVF_Local
GO


CREATE PROCEDURE	RVF_PRC_TOTALES_PRODUCCCION_MES_OTROS 
							@Company			VARCHAR(15)					=		'CO01', 
							@Plant				VARCHAR(15)					=		'', 
							@FechaDesde			DATE						=		'', 
							@FechaHasta			DATE						=		'' 

AS

SET DATEFORMAT DMY

/*

DECLARE				@Company			VARCHAR(15)					=		'', 
					@Plant				VARCHAR(15)					=		'', 
					@FechaDesde			DATE						=		'01/06/2021', 
					@FechaHasta			DATE						=		'30/06/2021' 
				
*/

---------------------------------------------------------------------------------------------------------------------

DECLARE				@CompanyDesde		VARCHAR(15), 
					@CompanyHasta		VARCHAR(15), 
					@PlantDesde			VARCHAR(15), 
					@PlantHasta			VARCHAR(15) 

---------------------------------------------------------------------------------------------------------------------

IF		@Company		=	''	
		BEGIN		
				SELECT		@CompanyDesde			=		'', 
							@CompanyHasta			=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@CompanyDesde			=		@Company, 
							@CompanyHasta			=		@Company	
		END 

--------------------------------------------------------------


IF		@Plant		=	''	
		BEGIN		
				SELECT		@PlantDesde			=		'', 
							@PlantHasta			=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@PlantDesde			=		@Plant, 
							@PlantHasta			=		@Plant	
		END 

---------------------------------------------------------------------------------------------------------------------

-- Grupos de Producto correspondientes a Acondicionadores de Aire 
DECLARE 			@ClassAA			TABLE(ProdCode VARCHAR(15)) 
INSERT INTO			@ClassAA			VALUES ('SUBA'), ('SUCO')					

---------------------------------------------------------------------------------------------------------------------
-- Almacena los movimientos de produccion de UI / UE desde el inicio del sistema y hasta antes de la fecha inicial de analisis
		
IF OBJECT_ID('tempdb.dbo.#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP1', 'U') IS NOT NULL
		TRUNCATE TABLE	#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP1	
	ELSE

CREATE TABLE			#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP1	(
																Company				VARCHAR(15), 
																Plant				VARCHAR(15), 
																TranDate			DATE, 
																PartNum				VARCHAR(50), 
																TranNum				BIGINT, 
																TranQty				DECIMAL(18,2), 
																UM					VARCHAR(5), 
																TranType			VARCHAR(10), 
																JobNum				VARCHAR(15), 
																PartDescription		VARCHAR(200), 
																SearchWord			VARCHAR(15), 
																ProdCode			VARCHAR(15), 
																ClassID				VARCHAR(15), 
																MtlAnalysisCode		VARCHAR(10), 
																CommodityCode		VARCHAR(15), 
																Character04			VARCHAR(1000), 
																ShortChar05			VARCHAR(50), 
																ShortChar07			VARCHAR(50), 
																ShortChar08			VARCHAR(50)
																)

INSERT INTO 			#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP1

-- Unidad interior y exterior de acondicionadores de aire
SELECT				PT.Company, PT.Plant, PT.TranDate, PT.PartNum, PT.TranNum, PT.TranQty, PT.UM, PT.TranType, PT.JobNum,  
					LEFT(P.PartDescription, 200), P.SearchWord, P.ProdCode, P.ClassID, P.MtlAnalysisCode, P.CommodityCode, 
					PU.Character04, PU.ShortChar05, PU.ShortChar07, PU.ShortChar08 
FROM				[CORPEPIDB].EpicorErp.Erp.PartTran				PT			WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part					P			WITH(NoLock)
	ON				PT.Company				=					P.Company
	AND				PT.PartNum				=					P.PartNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part_UD				PU			WITH(NoLock)
	ON				P.SysRowID				=					PU.ForeignSysRowID
WHERE				PT.TranType				IN					('MFG-STK')
	AND				PT.TranDate				<					@FechaDesde	
	AND				PT.Company				BETWEEN				@CompanyDesde		AND			@CompanyHasta 
	AND				PT.Plant				BETWEEN				@Plant				AND			@PlantHasta
	AND				P.ClassID				IN					(
																SELECT				ProdCode 
																FROM				@ClassAA
																)
														
---------------------------------------------------------------------------------------------------------------------
-- Almacena los totales de fabricacion de las Unidades Exteriores
		
IF OBJECT_ID('tempdb.dbo.#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP2', 'U') IS NOT NULL
		TRUNCATE TABLE	#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP2	
	ELSE

CREATE TABLE		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP2		(
																Company				VARCHAR(15), 
																PartNum				VARCHAR(50), 
																ShortChar05			VARCHAR(50), 
																TranQty				DECIMAL(18,2) 
																)

INSERT INTO 		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP2

SELECT				Company, PartNum, ShortChar05, SUM(TranQty)		AS	TranQty
FROM				#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP1			T1			WITH(NoLock)
WHERE				PartNum					LIKE				'%UE'
GROUP BY			Company, PartNum, ShortChar05 

---------------------------------------------------------------------------------------------------------------------
-- Almacena los totales de fabricacion de las Unidades Interiores

IF OBJECT_ID('tempdb.dbo.#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP3', 'U') IS NOT NULL
		TRUNCATE TABLE	#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP3	
	ELSE

CREATE TABLE		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP3		(
																Company				VARCHAR(15), 
																PartNum				VARCHAR(50), 
																ShortChar05			VARCHAR(50), 
																TranQty				DECIMAL(18,2) 
																)

INSERT INTO 		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP3

SELECT				Company, PartNum, ShortChar05, SUM(TranQty)		AS	TranQty
FROM				#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP1			T1			WITH(NoLock)
WHERE				PartNum					LIKE				'%UI'
GROUP BY			Company, PartNum, ShortChar05 

---------------------------------------------------------------------------------------------------------------------
-- Almacena una lista de los productos SK vinculados a los articulos fabricados

IF OBJECT_ID('tempdb.dbo.#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP4', 'U') IS NOT NULL
		TRUNCATE TABLE	#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP4	
	ELSE

CREATE TABLE		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP4		(
																Company				VARCHAR(15), 
																ShortChar05			VARCHAR(50)
																)

INSERT INTO 		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP4

SELECT				DISTINCT Company, ShortChar05 
FROM				#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP1			T1			WITH(NoLock)

---------------------------------------------------------------------------------------------------------------------
/*

SELECT				T4.Company, 
					T4.ShortChar05									AS	Componente_SK, 
					ISNULL(T2.PartNum, '')							AS	Componente_UE, 
					ISNULL(T3.PartNum, '')							AS	Componente_UI,  
					ISNULL(T2.TranQty, 0)							AS	Total_UE, 
					ISNULL(T3.TranQty, 0)							AS	Total_UI, 
					CASE 
							WHEN ISNULL(T2.TranQty, 0)	>= ISNULL(T3.TranQty, 0) THEN	ISNULL(T3.TranQty, 0)
							ELSE														ISNULL(T2.TranQty, 0)
					END												AS	EquiposCompletos, 
					ISNULL(T2.TranQty, 0) - ISNULL(T3.TranQty, 0)	AS	SaldoProduccion 

FROM	 			#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP4			T4			WITH(NoLock)
LEFT OUTER JOIN		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP2			T2			WITH(NoLock)
	ON				T4.Company				=					T2.Company
	AND				T4.ShortChar05			=					T2.ShortChar05
LEFT OUTER JOIN		#RVF_PRC_TOTALES_PRODUCCCION_MES_TEMP3			T3			WITH(NoLock)
	ON				T4.Company				=					T3.Company
	AND				T4.ShortChar05			=					T3.ShortChar05
WHERE				ISNULL(T2.TranQty, 0) - ISNULL(T3.TranQty, 0)	<>			0
ORDER BY			T4.Company, T4.ShortChar05	

*/
---------------------------------------------------------------------------------------------------------------------



SELECT				PT.Company, PT.Plant, PT.TranDate, PT.PartNum, PT.TranNum, PT.TranQty, PT.UM, PT.TranType, PT.JobNum,  
					P.PartDescription, P.SearchWord, P.ProdCode, P.ClassID, P.MtlAnalysisCode, P.CommodityCode, 
					PU.Character04, PU.ShortChar05, PU.ShortChar07, PU.ShortChar08 
FROM				[CORPEPIDB].EpicorErp.Erp.PartTran				PT			WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part					P			WITH(NoLock)
	ON				PT.Company				=					P.Company
	AND				PT.PartNum				=					P.PartNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part_UD				PU			WITH(NoLock)
	ON				P.SysRowID				=					PU.ForeignSysRowID
WHERE				PT.TranType				IN					('MFG-STK')
	AND				PT.TranDate				BETWEEN				@FechaDesde			AND			@FechaHasta
	AND				PT.Company				BETWEEN				@CompanyDesde		AND			@CompanyHasta 
	AND				PT.Plant				BETWEEN				@PlantDesde			AND			@PlantHasta
	AND				P.ClassID				NOT IN				(
																SELECT				ProdCode 
																FROM				@ClassAA
																)


---------------------------------------------------------------------------------------------------------------------

/*

SELECT				PT.Company, PT.Plant, PT.TranDate, PT.PartNum, PT.TranNum, PT.TranQty, PT.UM, PT.TranType, PT.JobNum,  
					P.PartDescription, P.SearchWord, P.ProdCode, P.ClassID, P.MtlAnalysisCode, P.CommodityCode, 
					PU.Character04, PU.ShortChar05, PU.ShortChar07, PU.ShortChar08 
FROM				[CORPEPIDB].EpicorErp.Erp.PartTran				PT			WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part					P			WITH(NoLock)
	ON				PT.Company				=					P.Company
	AND				PT.PartNum				=					P.PartNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part_UD				PU			WITH(NoLock)
	ON				P.SysRowID				=					PU.ForeignSysRowID
WHERE				PT.TranType				IN					('MFG-STK')
	AND				PT.TranDate				BETWEEN				@FechaDesde			AND			@FechaHasta
	AND				PT.Company				BETWEEN				@CompanyDesde		AND			@CompanyHasta 
	AND				PT.Plant				BETWEEN				@PlantDesde			AND			@PlantHasta
	AND				P.ClassID				IN					(
																SELECT				ProdCode 
																FROM				@ClassAA
																)
*/
---------------------------------------------------------------------------------------------------------------------
