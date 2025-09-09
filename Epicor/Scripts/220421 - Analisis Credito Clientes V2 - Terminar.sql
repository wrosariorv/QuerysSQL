
/*

EXECUTE				[dbo].[RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE]
					@Company		=			'CO01', 
					@CustID			=			'263', 
					@UN				=			''

*/

	SET DATEFORMAT DMY

--	DROP TABLE #RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2


DECLARE				@Company			VARCHAR(15)			=			'CO01', 
					@CustID				VARCHAR(50)			=			'5580', 
					@UN					VARCHAR(15)			=			'' 

---------------------------------------------------------------------------------------------

DECLARE				@CustNum			INT					=			
																		(
																		SELECT				CustNum
																		FROM				[CORPEPIDB].EpicorErp.Erp.Customer							WITH (NoLock) 
																		WHERE				Company					=				@Company
																			AND				CustID					=				@CustID
																		)

DECLARE					@UlDiaMesAnt4		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,-3,GETDATE())),105), 
						@UlDiaMesAnt3		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,-2,GETDATE())),105), 
						@UlDiaMesAnt2		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,-1,GETDATE())),105),
						@UlDiaMesAnt1		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,0,GETDATE())),105), 
						@PrimDiaMesAct		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(GETDATE())-1),GETDATE()),105), 
						@UlDiaMesAct		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,1,GETDATE())),105), 
						@UlDiaMesAct1		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,2,GETDATE())),105), 
						@UlDiaMesAct2		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,3,GETDATE())),105), 
						@UlDiaMesAct3		DATETIME	=	CONVERT(VARCHAR(25),DATEADD(DD,-(DAY(DATEADD(MM,1,GETDATE()))),DATEADD(MM,4,GETDATE())),105), 
						@UNIni				VARCHAR(15), 
						@UNFin				VARCHAR(15)  

---------------------------------------------------------------------------------------------

IF		@UN		=	''	
		BEGIN		
				SELECT		@UNIni			=		'', 
							@UNFin			=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@UNIni			=		@UN	, 
							@UNFin			=		@UN	
		END 

---------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb.dbo.#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP1', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP1	
	ELSE

CREATE TABLE			#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP1	(
																		[Company] [nchar](10) NOT NULL,
																		[CustID] [nchar](20), 
																		[CustName] [nchar](50), 
																		[CreditLimit] [decimal](18, 5),
																		[CreditReviewDate] [datetime]
																		)

INSERT INTO 		#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP1	

SELECT				Company, CustID, [Name], CreditLimit, CreditReviewDate 
FROM				[CORPEPIDB].EpicorErp.Erp.Customer							WITH (NoLock) 
WHERE				Company					=				@Company
	AND				CustID					=				@CustID
																		

---------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb.dbo.#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2', 'U') IS NOT NULL
		TRUNCATE TABLE #RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2	
	ELSE

CREATE TABLE			#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2	(
																		[Origen] [nchar](50) NOT NULL,
																		[Company] [nchar](10) NOT NULL,
																		[OpenInvoice] [int],
																		[CreditMemo] [int],
																		[InvoiceSuffix] [nchar](10),
																		[InvoiceNum] [nchar](20),
																		[InvoiceDate] [datetime],
																		[DueDate] [datetime],
																		[InvoiceAmt] [decimal](18, 5),
																		[InvoiceBal] [decimal](18, 5),
																		[CurrencyCode] [nchar](10),
																		[ExchangeRate] [decimal](18, 8),
																		[TranDocTypeID] [nchar](20),
																		[CheckRef] [nchar](20),
																		[HeadNum] [int],
																		[HDCaseNum] [int],
																		[LegalNumber] [nchar](50),
																		[UnNeg] [nchar](15),
																		[CodBanco] [nchar](15), 
																		[NumeroValor] [nchar](30), 
																		[Reference] [nchar](100), 
																		[GroupID] [nchar](15), 
																		[EntryPerson] [nchar](15), 
																		[InvoiceComment] [nchar](150), 
																		[PartNum] [nchar](100), 
																		[LineDesc] [nchar](150), 
																		[TaxCatID] [nchar](15), 
																		[ExtPrice] [decimal](18, 5), 
																		[TaxRegionCode] [nchar](15), 
																		[Tax] [decimal](18, 5),  
																		[CreatedDate] [datetime], 
																		[CreatedBy] [nchar](15), 
																		[LastUpdatedDate] [datetime], 
																		[LastUpdatedBy] [nchar](15), 
																		[DiasMora] [int], 
																		[OrderNum] [int], 
																		[PONum] [nchar](30), 
																		[OrderDate] [datetime], 
																		[OrderQty] [decimal](18, 5),  
																		[OrderLine] [int],
																		[TotalLinea] [decimal](18, 5), 
																		[ToFulfill] [decimal](18, 5), 
																		[ValorPendiente] [decimal](18, 5), 
																		[QuoteNum] [int], 
																		[QuoteLine] [int], 
																		[TaskDescription] [nchar](30),
																		-------------------------------------------
																		[SaldoObservado] [decimal](18, 5),
																		[SaldoVencido] [decimal](18, 5),
																		[CobrNoAplic] [decimal](18, 5),
																		[VencidoMesAntN] [decimal](18, 5),
																		[VencidoMesAnt3] [decimal](18, 5),
																		[VencidoMesAnt2] [decimal](18, 5),
																		[VencidoMesAnt1] [decimal](18, 5),
																		[VencidoMesAct] [decimal](18, 5),
																		[AVencerMesAct] [decimal](18, 5),
																		[AVencerMesProx1] [decimal](18, 5),
																		[AVencerMesProx2] [decimal](18, 5),
																		[AVencerMesProx3] [decimal](18, 5),
																		[AVencerMesProxN] [decimal](18, 5)
																		)		
																		
---------------------------------------------------------------------------------------------
/********************************************************************************************
Cuenta corriente de clientes
********************************************************************************************/
	
INSERT INTO 		#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2		(
																		Origen, Company, OpenInvoice, CreditMemo, InvoiceSuffix, InvoiceNum, InvoiceDate, DueDate, InvoiceAmt, InvoiceBal, 
																		CurrencyCode, ExchangeRate, TranDocTypeID, CheckRef, HeadNum, HDCaseNum, LegalNumber, UnNeg, SaldoObservado, 
																		SaldoVencido, CobrNoAplic, VencidoMesAntN, VencidoMesAnt3, VencidoMesAnt2, VencidoMesAnt1, VencidoMesAct, 
																		AVencerMesAct, AVencerMesProx1, AVencerMesProx2, AVencerMesProx3, AVencerMesProxN 
																		)

---------------------------------------------------------------------------------

SELECT				'Cuenta Corriente'				AS				Origen, 
					IH.Company, IH.OpenInvoice, IH.CreditMemo, IH.InvoiceSuffix, IH.InvoiceNum, IH.InvoiceDate, IH.DueDate, IH.InvoiceAmt, IH.InvoiceBal, IH.CurrencyCode, 
					IH.ExchangeRate, IH.TranDocTypeID, IH.Checkref, IH.HeadNum, 
					ISNULL(CA.HDCaseNum, '')		AS				HDCaseNum, 
					------------------------------------------------------------
					CASE	
							WHEN		IH.InvoiceSuffix		=			'UR'
							THEN		CH.LegalNumber
							ELSE		IH.LegalNumber
					END								AS				LegalNumber, 
					------------------------------------------------------------
					LEFT(IHU.Character07, 15)		AS				UnNeg, 
					------------------------------------------------------------------------------------------------------------------
					CASE	WHEN CA.HDCaseNum IS NOT NULL																												THEN IH.InvoiceBal
							ELSE 0
						END																				AS SaldoObservado,	
					CASE	WHEN  IH.DueDate	< CAST(GETDATE() AS DATE)	AND CA.HDCaseNum IS NULL																	THEN IH.InvoiceBal
							ELSE 0
						END																				AS SaldoVencido,	
					CASE	WHEN InvoiceSuffix =	'UR' AND CA.HDCaseNum IS NULL																						THEN IH.InvoiceBal
							ELSE 0
						END																				AS CobrNoAplic,	
					CASE	WHEN IH.DueDate	<= @UlDiaMesAnt4 AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'													THEN IH.InvoiceBal
							ELSE 0
						END																				AS VencidoMesAntN,

					CASE	WHEN IH.DueDate	BETWEEN (@UlDiaMesAnt4+1) AND @UlDiaMesAnt3	AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'						THEN IH.InvoiceBal
							ELSE 0
						END																				AS VencidoMesAnt3,

					CASE	WHEN IH.DueDate	BETWEEN (@UlDiaMesAnt3+1) AND @UlDiaMesAnt2	AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'						THEN IH.InvoiceBal
							ELSE 0
						END																				AS VencidoMesAnt2,

					CASE	WHEN IH.DueDate	BETWEEN (@UlDiaMesAnt2+1) AND @UlDiaMesAnt1	AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'						THEN IH.InvoiceBal
							ELSE 0
						END																				AS VencidoMesAnt1,

					CASE	WHEN IH.DueDate	BETWEEN (@UlDiaMesAnt1+1) AND CAST((GETDATE()-1) AS DATE) AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'			THEN IH.InvoiceBal 
							ELSE 0
						END																				AS VencidoMesAct,

					CASE	WHEN IH.DueDate	BETWEEN CAST(GETDATE() AS DATE) AND @UlDiaMesAct AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'					THEN IH.InvoiceBal 
							ELSE 0
						END																				AS AVencerMesAct,

					CASE	WHEN IH.DueDate	BETWEEN (@UlDiaMesAct+1) AND @UlDiaMesAct1	AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'						THEN IH.InvoiceBal 
							ELSE 0
						END																				AS AVencerMesProx1,

					CASE	WHEN IH.DueDate	BETWEEN (@UlDiaMesAct1+1) AND @UlDiaMesAct2	AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'						THEN IH.InvoiceBal 
							ELSE 0
						END																				AS AVencerMesProx2,

					CASE	WHEN IH.DueDate	BETWEEN (@UlDiaMesAct2+1) AND @UlDiaMesAct3	AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'						THEN IH.InvoiceBal 
							ELSE 0
						END																				AS AVencerMesProx3,
					CASE	WHEN IH.DueDate	> @UlDiaMesAct3 AND CA.HDCaseNum IS NULL AND IH.InvoiceSuffix <>	'UR'													THEN IH.InvoiceBal 
							ELSE 0
						END																				AS AVencerMesProxN 
					------------------------------------------------------------

FROM				[CORPEPIDB].EpicorErp.Erp.InvcHead				IH			WITH (NoLock) 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcHead_UD			IHU			WITH (NoLock) 
	ON				IH.SysRowID					=				IHU.ForeignSysRowID
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.CashHead				CH			WITH (NoLock) 
	ON				IH.Company					=					CH.Company
	AND				IH.InvoiceNum				=					CH.CreditMemoNum
LEFT OUTER JOIN		(
					SELECT				Company, InvoiceNum, MAX(HDCaseNum) AS 	HDCaseNum
					FROM				[CORPEPIDB].EpicorErp.Erp.HDCase							WITH (NoLock) 
					GROUP BY			Company, InvoiceNum
					)		CA
	ON				IH.Company					=					CA.Company
	AND				IH.InvoiceNum				=					CA.InvoiceNum 

WHERE				IH.Company					=				@Company	
	AND				IH.CustNum					=				@CustNum
	AND				IHU.Character07				BETWEEN			@UNIni		AND		@UNFin
	AND				IH.InvoiceBal				<>				0					-- Documentos con saldo pendiente 
	AND				IH.Posted					=				1					-- Documentos posteados

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
/********************************************************************************************
Cheques en cartera
********************************************************************************************/

INSERT INTO 		#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2		(
																		Origen, Company, UnNeg, CodBanco, NumeroValor, InvoiceDate, DueDate, LegalNumber, Reference, InvoiceBal, 
																		VencidoMesAntN, VencidoMesAct, AVencerMesAct, AVencerMesProx1, AVencerMesProx2, AVencerMesProx3, AVencerMesProxN 
																		)

---------------------------------------------------------------------------------
SELECT					'Cheques en Cartera', 
						A.Company, A.UnNeg, A.CodBanco, A.NumeroValor, A.EntryDate, A.Duedate, A.LegalNumber, A.Reference, A.Importe, 
						CASE	WHEN A.Duedate	< @PrimDiaMesAct									THEN A.Importe
								ELSE 0
							END																				AS VencidoMesAntN,

						CASE	WHEN A.Duedate	BETWEEN (@PrimDiaMesAct) AND (GETDATE()-1)			THEN A.Importe 
								ELSE 0
							END																				AS VencidoMesAct,

						CASE	WHEN A.Duedate	BETWEEN CAST(GETDATE() AS DATE) AND @UlDiaMesAct	THEN A.Importe 
								ELSE 0
							END																				AS AVencerMesAct,

						CASE	WHEN A.Duedate	BETWEEN (@UlDiaMesAct+1) AND @UlDiaMesAct1			THEN A.Importe 
								ELSE 0
							END																				AS AVencerMesProx1,

						CASE	WHEN A.Duedate	BETWEEN (@UlDiaMesAct1+1) AND @UlDiaMesAct2			THEN A.Importe 
								ELSE 0
							END																				AS AVencerMesProx2,

						CASE	WHEN A.Duedate	BETWEEN (@UlDiaMesAct2+1) AND @UlDiaMesAct3			THEN A.Importe 
								ELSE 0
							END																				AS AVencerMesProx3,

						CASE	WHEN A.Duedate	> @UlDiaMesAct3										THEN A.Importe 
								ELSE 0
							END																				AS AVencerMesProxN 

FROM					(
						SELECT					CH.Company, CH.Posted, CH.TranType, CH.CheckRef, 
												CH.TranDate, CH.CustNum, CH.CreditMemoNum, CH.LegalNumber, 
												LEFT(CH.Reference, 100)					 AS Reference, 
												LEFT(CHUD.Character04, 15)				 AS UnNeg, 
												U.PAC_BankAcctID_c						AS BankAcctID,
												U.PAC_FechaRecibo_c						AS EntryDate, 
												U.PAC_BankFeeId_c						AS BankFeeID, 
												'AR'									AS SourceModule, 
												U.PAC_Importe_c							AS Importe, 			
												U.PAC_BankBranch_c						AS CodBanco, 			
												U.PAC_Numero_c							AS NumeroValor, 
												U.PAC_FechaValor_c						AS Duedate 

						FROM					[CORPEPIDB].EpicorERP.Erp.CashHead			CH		WITH (NoLock)
						INNER JOIN				[CORPEPIDB].EpicorERP.Erp.CashHead_UD		CHUD		WITH (NoLock)
							ON					CH.SysRowID			=			CHUD.ForeignSysRowID
						--------------------------------------------------------------------------------------------------
						-- Se agrega este bloque para considerar los cambios en el manejo de la cartera de valores agregados en Epicor 10
						--------------------------------------------------------------------------------------------------
						LEFT OUTER JOIN	(
										SELECT			U108.Company, U108.Key1, U108.Key2, U108.Key3, U108.Key4, U108.Key5, 
														U108_U.PAC_BankFeeId_c, U108_U.PAC_DescValor_c, U108_U.PAC_Numero_c, U108_U.PAC_FechaValor_c, 
														U108_U.PAC_Estado_c, U108_U.PAC_BankBranch_c, U108_U.PAC_Banco_c, U108_U.PAC_CuentaBancoDesc_c, 
														U108_U.PAC_BankTranNum_c, U108_U.PAC_CUIT_c, U108_U.PAC_Terceros_c, U108_U.PAC_Importe_c, 
														U108_U.PAC_BankAcctID_c, U108_U.PAC_ChekRef_c, U108_U.PAC_Posted_c, U108_U.PAC_FechaRecibo_c, 
														U108_U.PAC_NumBolDeposito_c
										FROM			[CORPEPIDB].EpicorERP.Ice.UD108					U108		WITH (NoLock)
										INNER JOIN		[CORPEPIDB].EpicorERP.Ice.UD108_UD				U108_U		WITH (NoLock)
											ON			U108.SysRowID		=			U108_U.ForeignSysRowID
										WHERE			U108.Key1			=			'Fase3_Cartera'
										)				U
							ON			CH.HeadNum					=		U.Key2
							AND			CH.GroupID					=		U.Key3

						LEFT OUTER JOIN	(
										SELECT			Company, GroupID, TranDate, 
														MIN(ShortChar01)				AS Vendedor, 
														MIN(ShortChar02)				AS UnNeg
										FROM			[CORPEPIDB].EpicorERP.Erp.CashGrp				CH			WITH (NoLock)
										INNER JOIN		[CORPEPIDB].EpicorERP.Erp.CashGrp_UD			CH_U		WITH (NoLock)
											ON			CH.SysRowID						=			CH_U.ForeignSysRowID
										GROUP BY		Company, GroupID, TranDate 
										)				CG
							ON			CH.Company					=		CG.Company
							AND			CH.GroupID					=		CG.GroupID
							AND			CH.TranDate					=		CG.TranDate

						--------------------------------------------------------------------------------------------------
						INNER JOIN				(
												-- Se muestran solo los Bank Fee que aplican a cuentas por cobrar y estan definidos como Cheque
												SELECT				A.Company, A.BankFeeID, A.[Description], 
																	AUD.ShortChar01, AUD.ShortChar02
												FROM				[CORPEPIDB].EpicorERP.Erp.BankFee			A		WITH (NoLock)
												INNER JOIN			[CORPEPIDB].EpicorERP.Erp.BankFee_UD		AUD		WITH (NoLock)
													ON				A.SysRowID				=			AUD.ForeignSysRowID
												WHERE				AUD.PAC_Aplica_c		=			'AR'
													AND				AUD.PAC_TipoPago_c		IN			('CHK', 'CHKELEC')
												)										BF		
							ON					U.Company			=			BF.Company
							AND					U.PAC_BankFeeID_c	=			BF.BankFeeID

						--------------------------------------------------------------------------------------------------

						WHERE					CH.Company					=			@Company	
							AND					CH.CustNum					=			@CustNum
							AND					LEFT(CHUD.Character04, 15)	BETWEEN		@UNIni		AND		@UNFin
							AND					CH.TranType					=			'PayInv'
							AND					CH.Posted					=			1
							AND					U.PAC_BankFeeID_c			<>			''
							AND					U.PAC_BankBranch_c			<>			''
							-- Se excluyen los valores que tiene un numero de boleta de deposito, porque ya han sido depositados
							AND					U.PAC_NumBolDeposito_c		NOT LIKE	'BD%'

							-- Estados habilitados: 1:En Cartera, 5:Custodia
							AND					U.PAC_Estado_c				NOT IN		(
																						2,						-- 2:Depositado
																						3,						-- 3:Orden de Pago
																						4,						-- 4:Canje
																						6,						-- 6:Venta
																						7,						-- 7:Anulado
																						8,						-- 8:Rechazado a Proveedor
																						9,						-- 9:Rechazado
																						10						-- 10:Devuelto por rechazo
																						)
						)		A

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
/********************************************************************************************
NC20
********************************************************************************************/

INSERT INTO 		#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2		(
																		Origen, Company, InvoiceNum, InvoiceDate, InvoiceAmt, TranDocTypeID, GroupID, EntryPerson, UnNeg, 
																		InvoiceComment, PartNum, LineDesc, TaxCatID, ExtPrice, TaxRegionCode, Tax  
																		)

---------------------------------------------------------------------------------

SELECT					'NC20', 
						IH.Company, IH.InvoiceNum, IH.InvoiceDate, IH.InvoiceAmt, IH.TranDocTypeID, 
						IH.GroupID, IH.EntryPerson, 
						LEFT(IHUD.Character07, 15)		AS	UnNeg, 
						LEFT(IH.InvoiceComment, 150)	AS	InvoiceComment, 
						LEFT(ID.PartNum, 100)			AS	PartNum, 
						LEFT(ID.LineDesc, 150)			AS	LineDesc, 
						ID.TaxCatID, ID.ExtPrice, ID.TaxRegionCode, 
						ISNULL(TA.Tax, 0)				AS	Tax 

FROM					[CORPEPIDB].EpicorERP.Erp.InvcHead		IH			WITH (NoLock)			-- Cabecera de documentos de ventas
INNER JOIN				[CORPEPIDB].EpicorERP.Erp.InvcHead_UD	IHUD		WITH (NoLock)
	ON					IH.SysRowID			=			IHUD.ForeignSysRowID
INNER JOIN				[CORPEPIDB].EpicorERP.Erp.InvcDtl		ID			WITH (NoLock)			-- Detalle de documentos de ventas
	ON					IH.Company				=			ID.Company
	AND					IH.InvoiceNum			=			ID.InvoiceNum
	AND					IH.CustNum				=			ID.CustNum	
LEFT OUTER JOIN			(
						SELECT					Company, InvoiceNum, InvoiceLine, SUM(TaxAmt) AS Tax	
						FROM					[CORPEPIDB].EpicorERP.Erp.InvcTax		WITH (NoLock)	
						GROUP BY				Company, InvoiceNum, InvoiceLine
						)										TA
	ON					ID.Company				=			TA.Company
	AND					ID.InvoiceNum			=			TA.InvoiceNum
	AND					ID.InvoiceLine			=			TA.InvoiceLine

WHERE					IH.Company					=			@Company	
	AND					IH.CustNum					=			@CustNum
	AND					LEFT(IHUD.Character07, 15)	BETWEEN		@UNIni		AND		@UNFin
	AND					IH.InvoiceType			=			'MIS'
	AND					IH.Posted				=			0
	AND					IH.TranDocTypeID		=			'NC'
	AND					IH.GroupID				LIKE		'NC20%'

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
/********************************************************************************************
Facturas Observadas
********************************************************************************************/

INSERT INTO 		#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2		(
																		Origen, Company, InvoiceNum, HDCaseNum, CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy,  
																		LegalNumber, InvoiceDate, InvoiceBal, UnNeg, InvoiceComment, DiasMora
																		)

---------------------------------------------------------------------------------

SELECT					'Facturas Observadas', 
						CA.Company, CA.InvoiceNum, CA.HDCaseNum, CA.CreatedDate, CA.CreatedBy, CA.LastUpdatedDate, CA.LastUpdatedBy, 
						IH.LegalNumber, IH.InvoiceDate, IH.InvoiceBal, 
						LEFT(IHUD.Character07, 15)								AS	UnNeg, 
						LEFT(LTRIM(RTRIM(CA.[Description])), 150)				AS	[Description], 
					    (CAST((CAST(CAST(GETDATE() AS DATE) AS DATETIME) - 
						CAST(IH.DueDate AS DATETIME)) AS INT))					AS	DiasMora  
						
FROM					[CORPEPIDB].EpicorERP.Erp.HDCase		CA		WITH (NoLock)
INNER JOIN				[CORPEPIDB].EpicorERP.Erp.InvcHead		IH		WITH (NoLock)
	ON					CA.Company		=		IH.Company
	AND					CA.InvoiceNum	=		IH.InvoiceNum
INNER JOIN				[CORPEPIDB].EpicorERP.Erp.InvcHead_UD	IHUD	WITH (NoLock)
	ON					IH.SysRowID		=		IHUD.ForeignSysRowID
WHERE					IH.Company					=			@Company	
	AND					IH.CustNum					=			@CustNum
	AND					LEFT(IHUD.Character07, 15)	BETWEEN		@UNIni		AND		@UNFin			
	AND					IH.InvoiceBal				<>			0

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
/********************************************************************************************
Ordenes de venta
********************************************************************************************/

INSERT INTO 		#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2		(
																		Origen, Company, OrderNum, PONum, OrderDate, UnNeg, OrderQty, OrderLine,  
																		PartNum, LineDesc, TotalLinea, ToFulfill, ValorPendiente
																		)

---------------------------------------------------------------------------------

SELECT					'Ordenes de Venta', 
						OV.*, 
						TotalLinea / OrderQty * ToFulfill		AS		ValorPendiente
FROM					(
						SELECT					OH.Company,OH.OrderNum, OH.PONum, OH.OrderDate, 
												LEFT(OHUD.Character02, 15)							AS UN, 
												OD.OrderQty, OD.OrderLine, OD.PartNum, OD.LineDesc,  
												ROUND((OD.DocExtPriceDtl - OD.DocDiscount +  
												ISNULL(Tax.DocTaxAmt, 0)), 2)						AS TotalLinea,  
												ORel.PendEntrega									AS ToFulfill   

						FROM					[CORPEPIDB].EpicorERP.Erp.OrderHed		OH		WITH (NoLock)
						INNER JOIN				[CORPEPIDB].EpicorERP.Erp.OrderHed_UD	OHUD	WITH (NoLock)
							ON					OH.SysRowID			=			OHUD.ForeignSysRowID
						INNER JOIN				[CORPEPIDB].EpicorERP.Erp.OrderDtl		OD		WITH (NoLock)
							ON					OH.Company			=			OD.Company
							AND					OH.OrderNum			=			OD.OrderNum
						LEFT OUTER JOIN			(
												SELECT			Company, OrderNum, OrderLine, Plant, 
																SUM(OurReqQty - OurStockShippedQty)  AS PendEntrega
												FROM			[CORPEPIDB].EpicorERP.Erp.OrderRel			WITH (NoLock)
												GROUP BY		Company, OrderNum, OrderLine, Plant
												)										ORel
							ON					OD.Company			=			ORel.Company
							AND					OD.OrderNum			=			ORel.OrderNum
							AND					OD.OrderLine		=			ORel.OrderLine
						LEFT OUTER JOIN			(
												SELECT					Company, OrderNum, OrderLine, SUM(DocTaxAmt) 
																		AS DocTaxAmt  
												FROM					[CORPEPIDB].EpicorERP.Erp.OrderRelTax		WITH (NoLock)
												GROUP BY				Company, OrderNum, OrderLine
												) Tax
							ON					OD.Company			=			Tax.Company
							AND					OD.OrderNum			=			Tax.OrderNum
							AND					OD.OrderLine		=			Tax.OrderLine
						LEFT OUTER JOIN			(
												-- Se listan las lineas completamente enviadas
												-- Lineas de ordenes de venta completamente enviadas
												SELECT				B.Company, B.OrderNum, B.Orderline, B.PartNum, B.OrderQty, X.Shipped
												FROM				[CORPEPIDB].EpicorERP.Erp.OrderDtl		B		WITH (NoLock)
												LEFT OUTER JOIN		(
																	SELECT				SD.Company, SD.OrderNum, SD.OrderLine, SD.PartNum, SUM(SD.OurInventoryShipQty) AS Shipped
																	FROM				(
																						SELECT				Det.*
																						FROM				[CORPEPIDB].EpicorERP.Erp.ShipDtl	Det		WITH (NoLock)
																						INNER JOIN			[CORPEPIDB].EpicorERP.Erp.ShipHead	Hea		WITH (NoLock)
																							ON				Det.Company			=			Hea.Company
																							AND				Det.PackNum			=			Hea.PackNum
																						WHERE				ShipStatus			=			'SHIPPED'
																						)											SD
																	GROUP BY			SD.Company, SD.OrderNum, SD.OrderLine, SD.PartNum
																	) X
													ON				B.Company		=		X.Company
													AND				B.OrderNum		=		X.OrderNum
													AND				B.OrderLine		=		X.OrderLine
													AND				B.PartNum		=		X.PartNum
												WHERE				B.OrderQty		=		X.Shipped
												)	Z
						ON				OD.Company		=		Z.Company
						AND				OD.OrderNum		=		Z.OrderNum
						AND				OD.OrderLine	=		Z.OrderLine
						AND				OD.PartNum		=		Z.PartNum
					
						WHERE					OH.Company					=				@Company	
							AND					OH.CustNum					=				@CustNum
							AND					LEFT(OHUD.Character02, 15)	BETWEEN			@UNIni		AND		@UNFin		
							AND					OH.OpenOrder				=				1
							AND					OD.OpenLine					=				1
							AND					OH.CounterSale				=				0
							-----------------------------------------------------------
							AND					ORel.PendEntrega			<>				0
							-----------------------------------------------------------
							AND					Z.OrderNum					IS NULL
							-----------------------------------------------------------
						)		OV

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
/********************************************************************************************
Cotizaciones de venta
********************************************************************************************/

INSERT INTO 		#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2		(
																		Origen, Company, QuoteNum, OrderDate, UnNeg, QuoteLine, PartNum, LineDesc, 
																		OrderQty, TotalLinea, TaskDescription
																		)

---------------------------------------------------------------------------------

SELECT					'Cotizaciones de Venta', 
						QH.Company, QH.QuoteNum, QH.EntryDate, 
						LEFT(QH.Character02, 15)									AS UnNeg,  
						QD.QuoteLine, QD.PartNum, QD.LineDesc, QD.OrderQty, 
						QD.ExtPriceDtl - QD.Discount + ISNULL(Tax.ValorImpuesto, 0)	AS TotalLinea, 
						T.TaskDescription 

FROM					(
						SELECT					H.Company, H.QuoteNum, H.CustNum, H.EntryDate, H.TerritoryID, 
												H.TaskSetID, H.CurrentStage, H.ActiveTaskID, 
												H.ShipToNum, H.TermsCode, H.ReasonType, 
												HUD.Character02, HUD.Date01
						FROM					[CORPEPIDB].EpicorERP.Erp.QuoteHed	H		WITH (NoLock)
						INNER JOIN				[CORPEPIDB].EpicorERP.Erp.QuoteHed_UD	HUD		WITH (NoLock)
							ON					H.SysRowID			=			HUD.ForeignSysRowID
						WHERE EXISTS			-- Cotizaciones que no estan en estado GANADA o PERDIDA
												(
												SELECT				*
												FROM				RVF_VW_TCRED_COTIZ_PEND	B		WITH (NoLock)
												WHERE				H.Company		=		B.Company
													AND				H.QuoteNum		=		B.Key1
												)	
							AND					H.Ordered			=			0
							AND					H.ReasonType		<>			'L'
							----------------------------------------------------------------
							AND		H.Company					=				@Company	
							AND		H.CustNum					=				@CustNum
							AND		LEFT(HUD.Character02, 15)	BETWEEN			@UNIni		AND		@UNFin	
							----------------------------------------------------------------
						)										QH


INNER JOIN				(
						SELECT 					D.Company, D.QuoteNum, D.QuoteLine, D.PartNum, D.LineDesc, D.OrderQty, D.ProdCode, 
												D.Ordered, D.Discount, D.ExtPriceDtl, 
												DUD.Number06, DUD.Number11
						FROM 					[CORPEPIDB].EpicorERP.Erp.QuoteDtl	D		WITH (NoLock)
						INNER JOIN 				[CORPEPIDB].EpicorERP.Erp.QuoteDtl_UD	DUD		WITH (NoLock)
							ON					D.SysRowID			=			DUD.ForeignSysRowID
						WHERE EXISTS			-- Cotizaciones que no estan en estado GANADA o PERDIDA
												(
												SELECT				*
												FROM				RVF_VW_TCRED_COTIZ_PEND	B		WITH (NoLock)
												WHERE				D.Company		=		B.Company
													AND				D.QuoteNum		=		B.Key1
												)
						----------------------------------------------------------------
							AND		D.Company					=				@Company	
							AND		D.CustNum					=				@CustNum
						----------------------------------------------------------------
							
						)										QD
	ON					QH.Company			=			QD.Company
	AND					QH.QuoteNum			=			QD.QuoteNum	

LEFT OUTER JOIN			-- Impuestos por linea de cotizacion
						(
						SELECT					Tax.Company, Tax.QuoteNum, Tax.QuoteLine, 
												SUM(Tax.TaxAmt)						AS ValorImpuesto
						FROM					RVF_VW_CTRLQUOTE_IMP_DET		Tax		WITH (NoLock)
						WHERE EXISTS			-- Cotizaciones que no estan en estado GANADA o PERDIDA
												(
												SELECT				*
												FROM				RVF_VW_TCRED_COTIZ_PEND	B		WITH (NoLock)
												WHERE				Tax.Company			=		B.Company
													AND				Tax.QuoteNum		=		B.Key1
												)	
						GROUP BY				Company, QuoteNum, QuoteLine 
						)									Tax
			ON			QD.Company		=		Tax.Company
			AND			QD.QuoteNum		=		Tax.QuoteNum
			AND			QD.QuoteLine	=		Tax.QuoteLine

LEFT OUTER JOIN			-- Cotizaciones que no estan en estado GANADA o PERDIDA
						RVF_VW_TCRED_COTIZ_PEND	T		WITH (NoLock)
			ON			QH.Company			=		T.Company
			AND			QH.QuoteNum			=		T.Key1

WHERE		QH.Company					=				@Company	
	AND		QH.CustNum					=				@CustNum
	AND		LEFT(QH.Character02, 15)	BETWEEN			@UNIni		AND		@UNFin	

---------------------------------------------------------------------------------

SELECT				*
FROM			/*	#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP1			T1
CROSS JOIN		*/	#RVF_PRC_TCRED_ANALISIS_CREDITO_CLIENTE_TEMP2			T2

---------------------------------------------------------------------------------

