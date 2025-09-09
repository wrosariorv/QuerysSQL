
SET DATEFORMAT DMY

DECLARE			@Fecha		DATE			=			'28/05/2021'

---------------------------------------------------------------------------------
		
IF OBJECT_ID('tempdb.dbo.#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP1', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP1	
	ELSE

CREATE TABLE	#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP1	(
																Company				VARCHAR(15), 
																Posted				SMALLINT,
																InvoiceNum			INT, 
																InvoiceDate			DATE, 
																LegalNumber			VARCHAR(30),
																OrderNum			INT,
																CustNum				SMALLINT,
																InvoiceAmt			DECIMAL(18,3),
																Plant				VARCHAR(15),
																OrderDate			DATE 
																)
	
INSERT INTO 	#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP1

---------------------------------------------------------------------------------

SELECT			IH.Company, IH.Posted, IH.InvoiceNum, IH.InvoiceDate, IH.LegalNumber, IH.OrderNum, IH.CustNum, IH.InvoiceAmt, 
				IH.Plant, 
				OH.OrderDate 
FROM			[CORPEPIDB].EpicorErp.Erp.InvcHead				IH			WITH(NoLock)
LEFT OUTER JOIN	[CORPEPIDB].EpicorErp.Erp.OrderHed				OH			WITH(NoLock)
	ON			OH.Company					=				IH.Company
	AND			OH.OrderNum					=				IH.OrderNum 
WHERE			IH.InvoiceSuffix			NOT IN			('UR')			-- Se excluyen los saldos no aplicados de recibos 
	AND			IH.Posted					=				1				-- Se incluyen solo los documentos posteados
	AND			IH.OrderNum					<>				0				-- Se excluyen las operaciones que no tengan una Sales Order 
	AND			IH.InvoiceDate				=				@Fecha

---------------------------------------------------------------------------------

IF OBJECT_ID('tempdb.dbo.#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP2', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP2	
	ELSE

CREATE TABLE	#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP2	(
																Company				VARCHAR(15), 
																OrderNum			INT,
																QuoteNum			INT
																)
	
INSERT INTO 	#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP2

SELECT			OD.Company, OD.OrderNum, OD.QuoteNum 
FROM			[CORPEPIDB].EpicorErp.Erp.OrderDtl					OD			WITH(NoLock)
INNER JOIN		#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP1				T1			WITH(NoLock)
	ON			OD.Company					=				T1.Company
	AND			OD.OrderNum					=				T1.OrderNum
GROUP BY		OD.Company, OD.OrderNum, OD.QuoteNum 
			
---------------------------------------------------------------------------------

SELECT			*
/*
				T1.Company, T1.Posted, T1.InvoiceNum, T1.InvoiceDate, T1.LegalNumber, T1.OrderNum, T1.CustNum, T1.InvoiceAmt, 
				T1.Plant, T1.OrderDate , 
				Q.QuoteNum, 
				QH.EntryDate									AS		Quote_EnrtyDate, 
				T.StartDate										AS		QuoteTask_StartDate, 
				T.CompleteDate									AS		QuoteTask_CompleteDate
*/
FROM			#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP1				T1			WITH(NoLock)

LEFT OUTER JOIN	#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP2			Q
	ON			Q.Company					=				T1.Company
	AND			Q.OrderNum					=				T1.OrderNum

LEFT OUTER JOIN	(
				SELECT			T1.Company, T1.Key1, T1.StartDate, T1.CompleteDate 
				FROM			[CORPEPIDB].EpicorErp.Erp.Task				T1				WITH(NoLock)
				INNER JOIN		#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP2		TMP				WITH(NoLock)
					ON			T1.Company				=				TMP.Company
					AND			T1.Key1					=				TMP.QuoteNum 
				WHERE			T1.TaskDescription			NOT IN				(
																				'01 - Vendedor', '02 - Jefe Ventas', '03 - Gcia Comercial', 
																				'04 - Gcia Costos', '06 - Comite Creditos'
																				)
				)			T 
	ON			T.Company				=				Q.Company
	AND			T.Key1					=				Q.QuoteNum 

LEFT OUTER JOIN	[CORPEPIDB].EpicorErp.Erp.QuoteHed				QH				WITH(NoLock)
	ON			QH.Company				=				Q.Company
	AND			QH.QuoteNum				=				Q.QuoteNum 

---------------------------------------------------------------------------------

SELECT			OD.Company, OD.OrderNum, OD.QuoteNum 
FROM			[CORPEPIDB].EpicorErp.Erp.OrderDtl					OD			WITH(NoLock)
INNER JOIN		#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP1				T1			WITH(NoLock)
	ON			OD.Company					=				T1.Company
	AND			OD.OrderNum					=				T1.OrderNum
GROUP BY		OD.Company, OD.OrderNum, OD.QuoteNum


SELECT			T1.Company, T1.Key1, T1.StartDate, T1.CompleteDate 
FROM			[CORPEPIDB].EpicorErp.Erp.Task				T1				WITH(NoLock)
INNER JOIN		#RVF_PRC_CTRL_PROCESO_FACTURACION_TEMP2		TMP				WITH(NoLock)
	ON			T1.Company				=				TMP.Company
	AND			T1.Key1					=				TMP.QuoteNum 
WHERE			T1.TaskDescription		NOT IN				(
															'01 - Vendedor', '02 - Jefe Ventas', '03 - Gcia Comercial', 
															'04 - Gcia Costos', '06 - Comite Creditos'
															)