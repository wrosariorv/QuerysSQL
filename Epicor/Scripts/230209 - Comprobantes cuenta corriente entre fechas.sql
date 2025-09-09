
CREATE PROCEDURE	RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS
										@Company	VARCHAR(15)			=			'CO01', 
										@CustNum	INT, 
										@FechaDesde	DATE, 
										@FechaHasta	DATE

AS

SET DATEFORMAT DMY

/*

DECLARE				@Company	VARCHAR(15)			=			'CO01', 
					@CustNum	INT					=			1, 
					@FechaDesde	DATE				=			'01/07/2022', 
					@FechaHasta	DATE				=			'31/01/2023'

*/

/**********************************************************

Se carga una tabla temporal con los numeros de factura seleccionados

**********************************************************/

IF OBJECT_ID('tempdb.dbo.#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP1', 'U') IS NOT NULL
		TRUNCATE TABLE #RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP1	
	ELSE

CREATE TABLE	#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP1		(
																	Company					VARCHAR(15), 
																	InvoiceNum				INT
																	)

INSERT INTO 	#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP1

SELECT			IH.Company, IH.InvoiceNum 
FROM			CORPEPIDB.EpicorErp.Erp.InvcHead								IH			WITH(NoLock)
WHERE			IH.Company				=			@Company
	AND			IH.CustNum				=			@CustNum
	AND			IH.InvoiceDate			BETWEEN		@FechaDesde		AND		@FechaHasta
	AND			IH.InvoiceSuffix		NOT IN		('UR')					-- Se excluyen los saldos de recibos no aplicados
	AND			IH.Posted				=			1						-- Solo documentos posteados 


/**********************************************************

Se carga una tabla temporal con los impuestos de las facturas seleccionadas

**********************************************************/

IF OBJECT_ID('tempdb.dbo.#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP2', 'U') IS NOT NULL
		TRUNCATE TABLE #RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP2	
	ELSE

CREATE TABLE	#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP2		(
																	Company					VARCHAR(15), 
																	InvoiceNum				INT, 
																	InvoiceLine				SMALLINT, 
																	TaxCode					VARCHAR(15), 
																	TaxAmt					DECIMAL(23,5), 
																	DocTaxAmt				DECIMAL(23,5), 
																	RptCatCode				VARCHAR(15)
																	)

INSERT INTO 	#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP2

SELECT			IT.Company, IT.InvoiceNum, IT.InvoiceLine, IT.TaxCode, IT.TaxAmt, IT.DocTaxAmt, 
				ST.RptCatCode 
FROM			#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP1					T1			WITH(NoLock)
INNER JOIN		CORPEPIDB.EpicorErp.Erp.InvcTax									IT			WITH(NoLock)
	ON			T1.Company				=			IT.Company 
	AND			T1.InvoiceNum			=			IT.InvoiceNum
INNER JOIN 		CORPEPIDB.EpicorErp.Erp.SalesTax								ST			WITH(NoLock)
	ON			IT.Company				=			ST.Company 
	AND			IT.TaxCode				=			ST.TaxCode 


/**********************************************************

Se carga una tabla temporal con los impuestos de las facturas seleccionadas totalizados por grupo

**********************************************************/

IF OBJECT_ID('tempdb.dbo.#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP3', 'U') IS NOT NULL
		TRUNCATE TABLE #RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP3	
	ELSE

CREATE TABLE	#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP3		(
																	[Company]				VARCHAR(15), 
																	[InvoiceNum]			INT, 
																	[IMPINT-BI]				DECIMAL(23,5),
																	[IMPINT-NoBI]			DECIMAL(23,5),
																	[IVA]					DECIMAL(23,5), 
																	[PIIBB]					DECIMAL(23,5), 
																	[PIVA]					DECIMAL(23,5)
																	)

INSERT INTO 	#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP3

SELECT			Company, InvoiceNum, ISNULL([IMPINT-BI], 0), ISNULL([IMPINT-NoBI], 0), ISNULL([IVA], 0), ISNULL([PIIBB], 0), ISNULL([PIVA], 0) 
FROM			(
				-----------------------------------------------------------------------------------------
				-- Se listan todos los impuestos, menos los IMP INT
				-----------------------------------------------------------------------------------------

				SELECT				Company, InvoiceNum, RptCatCode, 
									SUM(TaxAmt)			AS TaxAmt
				FROM				#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP2					T2			WITH(NoLock)
				WHERE				RptCatCode				NOT IN				('IMPINT')
				GROUP BY			Company, InvoiceNum, RptCatCode
				
				---------
				UNION ALL
				---------

				-----------------------------------------------------------------------------------------
				-- Se listan los impuestos internos que forman parte de la base imponible
				-----------------------------------------------------------------------------------------

				SELECT				Company, InvoiceNum, RptCatCode + '-BI', 
									SUM(TaxAmt)			AS TaxAmt
				FROM				#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP2					T2			WITH(NoLock)
				WHERE				RptCatCode				IN					('IMPINT')
					AND				TaxCode					IN					('II1', 'II1_NC')
				GROUP BY			Company, InvoiceNum, RptCatCode

				---------
				UNION ALL
				---------

				-----------------------------------------------------------------------------------------
				-- Se listan los impuestos internos que no forman parte de la base imponible
				-----------------------------------------------------------------------------------------

				SELECT				Company, InvoiceNum, RptCatCode + '-NoBI', 
									SUM(TaxAmt)			AS TaxAmt
				FROM				#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP2					T2			WITH(NoLock)
				WHERE				RptCatCode				IN					('IMPINT')
					AND				TaxCode					NOT IN				('II1', 'II1_NC')
				GROUP BY			Company, InvoiceNum, RptCatCode

				)		A
				PIVOT
				(
				SUM			(TaxAmt)
				FOR			RptCatCode IN ([IMPINT-BI], [IMPINT-NoBI], [IVA], [PIIBB], [PIVA])
				)		P

-----------------------------------------------------------

SELECT				IH.Company, IH.CreditMemo, IH.Posted, IH.GroupID, IH.InvoiceNum, IH.LegalNumber, IH.InvoiceType, IH.InvoiceDate, 
					IH.InvoiceComment, IH.InvoiceAmt, IH.CurrencyCode, IH.ExchangeRate, IH.RMANum, IH.Plant, 
					LTRIM(RTRIM(IHU.Character07))						AS		UnNeg, 
					C.CustID, 
					C.[Name]											AS		CustName, 
					ISNULL(T3.[IMPINT-BI], 0)							AS		[IMPINT-BI], 
					ISNULL(T3.[IMPINT-NoBI], 0)							AS		[IMPINT-NoBI], 
					ISNULL(T3.IVA, 0)									AS		IVA, 
					ISNULL(T3.PIIBB, 0)									AS		PIIBB, 
					ISNULL(T3.PIVA, 0)									AS		PIVA, 
					IH.InvoiceAmt - ISNULL(T3.[IMPINT-NoBI], 0) - 
					ISNULL(T3.IVA, 0) - ISNULL(T3.PIIBB, 0)	 - 
					ISNULL(T3.PIVA, 0)									AS		SubTotal

FROM				#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP1					T1			WITH(NoLock)
INNER JOIN			CORPEPIDB.EpicorErp.Erp.InvcHead								IH			WITH(NoLock)
	ON				T1.Company				=			IH.Company 
	AND				T1.InvoiceNum			=			IH.InvoiceNum
INNER JOIN			CORPEPIDB.EpicorErp.Erp.InvcHead_UD								IHU			WITH(NoLock)
	ON				IH.SysRowID				=			IHU.ForeignSysRowID 
INNER JOIN			CORPEPIDB.EpicorErp.Erp.Customer								C			WITH(NoLock)
	ON				IH.Company				=			C.Company 
	AND				IH.CustNum				=			C.CustNum
LEFT OUTER JOIN		#RV_PRC_COMPROBANTES_CTA_CTE_ENTRE_FECHAS_TEMP3					T3
	ON				T1.Company				=			T3.Company 
	AND				T1.InvoiceNum			=			T3.InvoiceNum

-----------------------------------------------------------

