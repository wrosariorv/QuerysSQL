
/*

- vistas para integración en la base "moviventas" de 10.1.7.81
    * vw_cobranzas
    * vw_documentos_cobranza
    * vw_transferencias_cobranza
    * vw_retenciones_cobranza
    * vw_cheques_cobranza

*/

DECLARE			@NumeroInicial		SMALLINT	=	240

SELECT			nroCobranza, codVendedor, marca, fecha, comentarios, codCliente, efectivo, totalRecibo, codObservacion
FROM			[CORPSQLMULT01].Moviventas.dbo.vw_cobranzas								WITH(NoLock)
WHERE			nroCobranza				>=			@NumeroInicial



SELECT			nroCobranza, bankFee, monto, nroComprobante, CAST(fecha AS DATE) AS fecha 
FROM			[CORPSQLMULT01].Moviventas.dbo.vw_transferencias_cobranza				WITH(NoLock)
WHERE			nroCobranza				>=			@NumeroInicial

------------
UNION
------------

SELECT			nroCobranza, bankFee, monto, '', CAST(fecha AS DATE) AS fecha 
FROM			[CORPSQLMULT01].Moviventas.dbo.vw_retenciones_cobranza					WITH(NoLock)
WHERE			nroCobranza				>=			@NumeroInicial

------------
UNION
------------

SELECT			nroCobranza, bankFee, monto, nroCheque, CAST(fechaPago AS DATE) AS fecha 
--				, sucursal, cuenta, codBanco
FROM			[CORPSQLMULT01].Moviventas.dbo.vw_cheques_cobranza						WITH(NoLock)
WHERE			nroCobranza				>=			@NumeroInicial

ORDER BY		1, 2, 3, 4 


SELECT			nroCobranza, codDocumento, montoAplicado
FROM			[CORPSQLMULT01].Moviventas.dbo.vw_documentos_cobranza					WITH(NoLock)
WHERE			nroCobranza				>=			@NumeroInicial


SELECT			*
FROM			RVF_Local.dbo.RVF_VW_MOVI_ESTADO_COBRANZAS								WITH(NoLock)


SELECT			*
FROM			[CORPEPIDB].EpicorErp.Ice.UD16											WITH(NoLock)
WHERE			Key1					=			'CobranzasMoviventas'
ORDER BY		Key2 

/*

INSERT INTO		[CORPEPIDB].EpicorErp.Ice.UD16	(Company, Key1, Key2, Key3, Key4, Key5)
SELECT			'CO01', 'CobranzasMoviventas', nroCobranza, CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME), ''
FROM			[CORPSQLMULT01].Moviventas.dbo.vw_cobranzas								WITH(NoLock)
WHERE			NOT EXISTS		(
								SELECT							*
								FROM							[CORPEPIDB].EpicorErp.Ice.UD16
								WHERE							Key1						=			'CobranzasMoviventas'
									AND							vw_cobranzas.nroCobranza	=			UD16.Key2
								)

*/
