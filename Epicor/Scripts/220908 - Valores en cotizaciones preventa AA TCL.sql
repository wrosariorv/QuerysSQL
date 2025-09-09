
SET DATEFORMAT DMY


SELECT				C.Company, C.CustID, C.[Name], 
					CH.TranDate, CH.GroupID, CH.Reference, CH.LegalNumber, CH.ChangedBy,
					CH.OtherDetails						AS		ReciboMoviventas, 
					U.PAC_Numero_c						AS		NroCheque, 
					U.PAC_FechaValor_c					AS		FechaDeposito, 
					U.PAC_BankBranch_c					AS		CodBanco, 
					U.PAC_Importe_c						AS		ImporteCheque, 
					U.PAC_NumBolDeposito_c				AS		NumeroBoleta, 
					U.PAC_Estado_c, 
					U.PAC_Banco_c, 
					BF.BankFeeID, 
					CASE		U.PAC_Estado_c
						WHEN	1	THEN	'Cartera'
						WHEN	2	THEN	'Depositado'
						WHEN	5	THEN	'Custodia'
						WHEN	9	THEN	'Rechazado'
						ELSE								''
					END									AS		DescripcionEstado, 
					CHU.CheckBox01						AS	ACuenta, 
					CHU.Character01						AS	ACuenta, 
					CHU.Character04						AS	UnNeg 

FROM				[CORPEPIDB].EpicorERP.Erp.CashHead			CH					WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.CashHead_UD		CHU					WITH (NoLock)
	ON				CH.SysRowID				=					CHU.ForeignSysRowID	
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.Customer			C					WITH (NoLock)
	ON				CH.Company				=					C.Company
	AND				CH.CustNum				=					C.CustNum

	--------------------------------------------------------------------------------------------------
-- Se agrega este bloque para considerar los cambios en el manejo de la cartera de valores agregados en Epicor 10
--------------------------------------------------------------------------------------------------
LEFT OUTER JOIN		(
					SELECT			U108.Company, U108.Key1, U108.Key2, U108.Key3, U108.Key4, U108.Key5, 
									U108_U.PAC_BankFeeId_c, U108_U.PAC_DescValor_c, U108_U.PAC_Numero_c, U108_U.PAC_FechaValor_c, 
									U108_U.PAC_Estado_c, U108_U.PAC_BankBranch_c, U108_U.PAC_Banco_c, U108_U.PAC_CuentaBancoDesc_c, 
									U108_U.PAC_BankTranNum_c, U108_U.PAC_CUIT_c, U108_U.PAC_Terceros_c, U108_U.PAC_Importe_c, 
									U108_U.PAC_BankAcctID_c, U108_U.PAC_ChekRef_c, U108_U.PAC_Posted_c, U108_U.PAC_FechaRecibo_c, 
									U108_U.PAC_NumBolDeposito_c
					FROM			[CORPEPIDB].EpicorERP.Ice.UD108				U108		WITH (NoLock)
					INNER JOIN		[CORPEPIDB].EpicorERP.Ice.UD108_UD				U108_U		WITH (NoLock)
						ON			U108.SysRowID		=			U108_U.ForeignSysRowID
					WHERE			U108.Key1			=			'Fase3_Cartera'
					)				U
		ON			CH.HeadNum					=		U.Key2
		AND			CH.GroupID					=		U.Key3


INNER JOIN			(
					SELECT			*
					FROM			[CORPEPIDB].EpicorERP.Erp.BankFee		B		WITH (NoLock)
					INNER JOIN		[CORPEPIDB].EpicorERP.Erp.BankFee_UD		BUD	WITH (NoLock)
						ON			B.SysRowID				=			BUD.ForeignSysRowID
					WHERE			B.Company				=			'CO01'
						AND			B.BankFeeID				IN			('CHCLPR', 'CHCLTER', 'CHEELCPROP', 'CHCLELEC')
					)		BF

	ON				U.Company				=			BF.Company
	AND				U.PAC_BankFeeId_c		=			BF.BankFeeId


WHERE				CH.TranDate				>=					'01/04/2022'
	AND				CH.TranType				=					'PayInv'
	AND				CHU.CheckBox01			=					1
	AND				CHU.Character04			=					'TCL'
	AND				CHU.Character01			=					'AA-SPLIT'
