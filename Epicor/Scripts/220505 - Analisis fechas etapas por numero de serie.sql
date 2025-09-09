

SELECT					Company, PartNum, SerialNumber, TranDate, 
						CASE	TranType
							WHEN		'MFG-STK'		THEN		'Fabricacion'
							WHEN		'TRANSFER'		THEN		'Envio Transferencia'
							WHEN		'RECEIPT'		THEN		'Recibo Transferencia'
							WHEN		'STK-CUS'		THEN		'Despacho a Cliente'
							ELSE							''
						END									AS		Operacion
			--			TranNum, JobNum, CustNum, PackNum, PackLine,   
FROM					[CORPEPIDB].EpicorErp.Erp.SNTran									WITH(NoLock)
WHERE					(
						SerialNumber				=					'RO2505639948002'
						OR
						SerialNumber				LIKE				'RO2507339929601'
						)
	AND					TranType					IN					('MFG-STK', 'TRANSFER', 'RECEIPT', 'STK-CUS')
ORDER BY				Company, PartNum, SerialNumber, TranNum

