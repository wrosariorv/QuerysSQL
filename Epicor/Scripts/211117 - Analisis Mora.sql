
SET DATEFORMAT DMY

/************************************************************************************

SELECT			*
FROM			[CORPEPIDB].EpicorERP.Erp.Customer							WITH (NoLock)
WHERE			Name				LIKE					'%Montes%'

************************************************************************************/

DECLARE			@Company			VARCHAR(15)		=		'CO01', 
				@CustNum			INT				=		'825', 
				@FechaDesde			DATE			=		'01/11/2021', 
				@FechaHasta			DATE			=		'30/11/2021', 
				@TasaInteres		DECIMAL(18,5)	=		4

/************************************************************************************
CALCULO DE MORA ENTRE LA FECHA DE LA FACTURA Y LA FECHA DEL RECIBO APLICADO
************************************************************************************/

-------------------------------------------------------------------------
-- Recibos cargados y aplicados 
-------------------------------------------------------------------------

SELECT			CH.Company, CH.LegalNumber, CH.HeadNum, CH.CheckRef, CH.GroupID, CH.TranDate, CH.CustNum, CH.AppliedAmt, CH.UnAppliedAmt, CH.OtherDetails, 
				CH.TranAmt											AS		TranAmt_CH, 
		--		CD.LegalNumber, CD.TranDate, 
				CD.TranAmt											AS		TranAmt_CD, 
				IH.LegalNumber										AS		LegalNumber_IH, 
				IH.InvoiceNum, IH.InvoiceDate, 
				IHUD.Character07									AS		UnNeg, 
				ISC.PayDueDate, 
				C.CustID, C.[Name], 
				DATEDIFF(dd, ISC.PayDueDate, CH.TranDate)			AS		DiasMoraRecibo, 
				'Recibo'											AS		TipoTransaccion, 
				@TasaInteres										AS		TasaInteres, 
				(CD.TranAmt * ((@TasaInteres/100)/30) * 
				DATEDIFF(dd, ISC.PayDueDate, CH.TranDate))			AS		Interes

FROM			[CORPEPIDB].EpicorERP.Erp.CashHead				CH			WITH (NoLock)
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.CashDtl				CD			WITH (NoLock)
	ON			CH.Company					=			CD.Company
	AND			CH.HeadNum					=			CD.HeadNum
	AND			CH.CheckRef					=			CD.CheckRef
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.InvcHead				IH			WITH (NoLock)
	ON			CD.Company					=			IH.Company 
	AND			CD.InvoiceNum				=			IH.InvoiceNum
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.InvcHead_UD			IHUD		WITH (NoLock)
	ON			IH.SysRowID					=			IHUD.ForeignSysRowID
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.Customer				C			WITH (NoLock)
	ON			CH.Company					=			C.Company
	AND			CH.CustNum					=			C.CustNum
LEFT OUTER JOIN (
				SELECT				*
				FROM				[CORPEPIDB].EpicorERP.Erp.InvcSched		WITH (NoLock)		
				WHERE				PaySeq			=			1	
				)										ISC
	ON			CD.Company					=			ISC.Company
	AND			CD.InvoiceNum				=			ISC.InvoiceNum

WHERE			CH.Company					=			@Company
	AND			CH.CustNum					=			@CustNum 
	AND			CH.LegalNumber				<>			''
	AND			CD.TranDate					BETWEEN		@FechaDesde			AND			@FechaHasta

-----------------------
UNION ALL
-----------------------

-------------------------------------------------------------------------
-- Aplicacion de saldos anteriores
-------------------------------------------------------------------------

SELECT			ISNULL(CH_2.Company, CH.Company)					AS		Company, 
				ISNULL(CH_2.LegalNumber, CH.LegalNumber)			AS		LegalNumber, 
				ISNULL(CH_2.HeadNum, CH.HeadNum)					AS		HeadNum, 
				ISNULL(CH_2.CheckRef, CH.CheckRef)					AS		CheckRef, 
				ISNULL(CH_2.GroupID, CH.GroupID)					AS		GroupID, 
				ISNULL(CH_2.TranDate, CH.TranDate)					AS		TranDate, 
				ISNULL(CH_2.CustNum, CH.CustNum)					AS		CustNum, 
				ISNULL(CH_2.AppliedAmt, CH.AppliedAmt)				AS		AppliedAmt, 
				ISNULL(CH_2.UnAppliedAmt, CH.UnAppliedAmt)			AS		UnAppliedAmt, 
				ISNULL(CH_2.OtherDetails, CH.OtherDetails)			AS		OtherDetails, 
				ISNULL(CH_2.TranAmt, CH.TranAmt)					AS		TranAmt_CH, 
		--		CD.LegalNumber, CD.TranDate, CD.InvoiceRef, 
				CD.TranAmt											AS		TranAmt_CD, 
				IH.LegalNumber										AS		LegalNumber_IH, 
				IH.InvoiceNum, IH.InvoiceDate, 
				IHUD.Character07									AS		UnNeg, 
				ISC.PayDueDate, 
				C.CustID, C.[Name], 
				DATEDIFF(dd, ISC.PayDueDate, CH.TranDate)			AS		DiasMoraRecibo, 
				'Aplicacion'										AS		TipoTransaccion, 
				@TasaInteres										AS		TasaInteres, 
				(CD.TranAmt * ((@TasaInteres/100)/30) * 
				DATEDIFF(dd, ISC.PayDueDate, CH.TranDate))			AS		Interes

FROM			[CORPEPIDB].EpicorERP.Erp.CashHead				CH			WITH (NoLock)
INNER JOIN		(
				SELECT			*
				FROM			[CORPEPIDB].EpicorERP.Erp.CashDtl							WITH (NoLock)
				WHERE			InvoiceRef					<>			0
				)	CD 
	ON			CH.Company					=			CD.Company
	AND			CH.HeadNum					=			CD.HeadNum
	AND			CH.CheckRef					=			CD.CheckRef
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.CashHead				CH_2		WITH (NoLock)
	ON			CD.Company					=			CH_2.Company
--	AND			CD.HeadNum					=			CH_2.HeadNum
	AND			CD.InvoiceRef				=			CH_2.CreditMemoNum
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.InvcHead				IH			WITH (NoLock)
	ON			CD.Company					=			IH.Company
	AND			CD.InvoiceNum				=			IH.InvoiceNum
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.InvcHead_UD			IHUD		WITH (NoLock)
	ON			IH.SysRowID					=			IHUD.ForeignSysRowID
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.Customer				C			WITH (NoLock)
	ON			CH.Company					=			C.Company
	AND			CH.CustNum					=			C.CustNum
LEFT OUTER JOIN (
				SELECT				*
				FROM				[CORPEPIDB].EpicorERP.Erp.InvcSched		WITH (NoLock)		
				WHERE				PaySeq			=			1	
				)										ISC
	ON			CD.Company					=			ISC.Company
	AND			CD.InvoiceNum				=			ISC.InvoiceNum

WHERE			CH.Company										=			@Company
	AND			CH.CustNum										=			@CustNum 
	AND			CH.LegalNumber									=			''
	AND			CAST(IH.InvoiceNum AS VARCHAR(50))				<>			CAST(IH.LegalNumber AS VARCHAR(50))
	AND			CD.TranDate										BETWEEN		@FechaDesde			AND			@FechaHasta




