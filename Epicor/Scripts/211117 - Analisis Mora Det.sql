

/*

CREATE PROCEDURE	RVF_PRC_FIN_MORA_RECIBO_VALORES
							@Company			VARCHAR(15)		=		'CO01', 
							@CustNum			INT, 
							@FechaDesde			DATE, 
							@FechaHasta			DATE, 
							@TasaInteres		DECIMAL(18,5)

AS
*/

SET DATEFORMAT DMY


DECLARE			@Company			VARCHAR(15)		=		'CO01', 
				@CustNum			INT				=		'825', 
				@FechaDesde			DATE			=		'01/11/2021', 
				@FechaHasta			DATE			=		'30/11/2021',
				@TasaInteres		DECIMAL(18,5)	=		4


/************************************************************************************
CALCULO DE MORA ENTRE LA FECHA DEL RECIBO Y LA FECHA DE VENCIMIENTO DE LOS VALORES
************************************************************************************/

SELECT			DISTINCT 
				CH.Company, CH.HeadNum, CH.CheckRef, CH.LegalNumber, CH.CustNum, 
				CH.CurrencyCode													AS	CurrencyCodeOrig, 
				CH.ExchangeRate													AS	ExchangeRateOrig, 
				U.PAC_BankTranNum_c												AS	TranNum, 
				U.PAC_FechaRecibo_c												AS	FechaRecibo, 
				U.PAC_FechaValor_c												AS	FechaVtoValor,
				U.PAC_Numero_c													AS	NumeroValor, 
				U.PAC_Importe_c													AS	ImporteValor, 	
				U.PAC_DescValor_c												AS	DecripcionValor, 
				C.CustID, C.[Name], 
				DATEDIFF(dd, U.PAC_FechaRecibo_c, U.PAC_FechaValor_c)			AS	DiasMoraValores, 
				@TasaInteres													AS	TasaInteres, 
				(U.PAC_Importe_c * ((@TasaInteres/100)/30) * 
				DATEDIFF(dd, U.PAC_FechaRecibo_c, U.PAC_FechaValor_c))			AS	Interes

FROM			[CORPEPIDB].EpicorERP.Erp.CashHead			CH			WITH (NoLock)

--------------------------------------------------------------------------------------------------
-- Se agrega este bloque para considerar los cambios en el manejo de la cartera de valores agregados en Epicor 10
--------------------------------------------------------------------------------------------------
LEFT OUTER JOIN	(
				SELECT			U108.Company, U108.Key1, U108.Key2, U108.Key3, U108.Key4, U108.Key5, 
								--------------------------------------------------------------------
								U108_U.PAC_RegNum_c, U108_U.PAC_TipoPago_c, U108_U.PAC_CustID_c, U108_U.PAC_LeganNum_c, U108_U.PAC_BankTranNum_c, U108_U.PAC_FechaRecibo_c, 
								U108_U.PAC_FechaValor_c, U108_U.PAC_Estado_c, U108_U.PAC_Importe_c, U108_U.PAC_TipoCertificado_c, U108_U.PAC_Provincia_c, U108_U.PAC_Terceros_c, 
								U108_U.PAC_CUIT_c, U108_U.PAC_CuentaBanco_c, U108_U.PAC_Posted_c, U108_U.PAC_Cartera_c, U108_U.PAC_BankFeeId_c, U108_U.PAC_DescValor_c, 
								U108_U.PAC_HeadNum_c, U108_U.PAC_GroupID_c, U108_U.PAC_ChekRef_c, U108_U.PAC_BankBranch_c, U108_U.PAC_Banco_c, U108_U.PAC_ReceiptAmt_c, 
								U108_U.PAC_CuentaBancoDesc_c, U108_U.PAC_Voided_c, U108_U.PAC_NumBolDeposito_c, U108_U.PAC_CheckNum_c, U108_U.PAC_HeadNumAP_c, 
								U108_U.PAC_Jurisdiction_c, U108_U.PAC_BankAcctID_c, U108_U.PAC_PayLegalNumber_c, U108_U.PAC_VendorNumAP_c, U108_U.PAC_InvoiceNumAP_c, 
								U108_U.PAC_InvoiceNumAR_c, U108_U.PAC_LegalNumAR_c, 
								CAST(U108_U.PAC_Numero_c AS BIGINT)				AS	PAC_Numero_c

				FROM			[CORPEPIDB].EpicorERP.Ice.UD108				U108		WITH (NoLock)
				INNER JOIN		[CORPEPIDB].EpicorERP.Ice.UD108_UD				U108_U		WITH (NoLock)
					ON			U108.SysRowID		=			U108_U.ForeignSysRowID
				WHERE			U108.Key1			=			'Fase3_Cartera'
				)				U
	ON			CH.HeadNum					=		U.Key2
	AND			CH.GroupID					=		U.Key3
	AND			CH.CheckRef					=		U.PAC_ChekRef_c
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.CashDtl				CD			WITH (NoLock)
	ON			CH.Company					=			CD.Company
	AND			CH.HeadNum					=			CD.HeadNum
	AND			CH.CheckRef					=			CD.CheckRef
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.Customer				C			WITH (NoLock)
	ON			CH.Company					=			C.Company
	AND			CH.CustNum					=			C.CustNum

--------------------------------------------------------------------------------------------------

WHERE			CD.Company					=			@Company
	AND			CD.CustNum					=			@CustNum 
	AND			CD.TranDate					BETWEEN		@FechaDesde			AND			@FechaHasta
	AND			CH.CheckRef					<>			''
				