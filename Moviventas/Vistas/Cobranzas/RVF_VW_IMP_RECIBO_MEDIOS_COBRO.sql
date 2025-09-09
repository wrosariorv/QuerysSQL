USE [RVF_Local]
GO

/*

ALTER VIEW			[dbo].[RVF_VW_IMP_RECIBO_MEDIOS_COBRO]
AS

-- */

/*
SELECT				*
FROM				(
					SELECT		
					'CO01'						AS		Company, 
					'0000-00123487'				AS		Recibo,	
					'CHCLPR'					AS		BankFee,
					100000						AS		Amount,
					123456						AS		CheckNum,	
					'20/10/2020'				AS		DueDate,
					'014'						AS		Bank

					UNION ALL

					SELECT
					'CO01', 
					'0000-00123456',	
					'CHCLPR',	
					200000,	
					9876,	
					'15/10/2020',	
					'007'

					UNION ALL

					SELECT
					'CO01', 
					'0000-00123456',	
					'CHCLTER', 	
					12000,	
					32324,	
					'16/10/2020', 	
					'014'

					UNION ALL

					SELECT
					'CO01', 
					'0000-00123456',	
					'CHCLTER', 	
					345000,	
					56623,	
					'31/10/2020', 	
					'014'
					)	A
*/

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

SELECT				TOP 100 PERCENT	*
FROM				(
					SELECT				'CO01'													AS		Company,
										nroCobranza												AS		Recibo, 
										bankFee													AS		BankFee, 
										monto													AS		Amount, 
										CASE
											WHEN	nroComprobante = '' THEN	'1'
											ELSE								nroComprobante
										END														AS		CheckNum, 
										fecha													AS		DueDate, 
										codBanco												AS		Bank
					FROM				(
										SELECT			nroCobranza, bankFee, monto, nroComprobante, 
														'' AS codBanco, CAST(fecha AS DATE) AS fecha 
										FROM			[CORPSQLMULT2019].Moviventas_test.dbo.vw_transferencias_cobranza		WITH(NoLock)

										------------
										UNION
										------------

										SELECT			nroCobranza, bankFee, monto, nroComprobante,  
														'' AS codBanco, CAST(fecha AS DATE) AS fecha 
										FROM			[CORPSQLMULT2019].Moviventas_test.dbo.vw_retenciones_cobranza			WITH(NoLock)

										------------
										UNION
										------------

										SELECT			nroCobranza, bankFee, monto, nroCheque, 
														codBanco, CAST(fechaPago AS DATE) AS fecha 
										--				, sucursal, cuenta 
										FROM			[CORPSQLMULT2019].Moviventas_test.dbo.vw_cheques_cobranza				WITH(NoLock)
										) Z
					) A

/*

WHERE NOT EXISTS	(
					SELECT					*	
					FROM					RVF_TBL_IMP_RECIBO_LOG		WITH(NoLock)
					WHERE					A.Company			=			RVF_TBL_IMP_RECIBO_LOG.Company
						AND					A.Recibo			=			RVF_TBL_IMP_RECIBO_LOG.Recibo
					)

*/
where Recibo in (
40920,
40921,
40922,
40923,
40924,
40925,
40926
)

ORDER BY		1, 2, 3, 4 
GO


