USE [RVF_Local]
GO

 /*

ALTER VIEW			[dbo].[RVF_VW_IMP_RECIBO_FC_APPLIED]
AS

-- */

/*

SELECT				*
FROM				(
					SELECT		
					'CO01'						AS		Company, 
					'0000-00123487'				AS		Recibo,	
					164952						AS		InvoiceNum,	
					75846.22					AS		ApliedAmt

					UNION ALL

					SELECT 
					'CO01', 
					'0000-00123456',	
					167519,	
					41333.91

					UNION ALL

					SELECT 
					'CO01', 
					'0000-00123456',	
					168547,	
					17472.64

					UNION ALL

					SELECT
					'CO01', 
					'0000-00123456',	
					170885, 	
					105252.51
					)	A

*/

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

SELECT				TOP 100 PERCENT *
FROM				(
					SELECT				'CO01'									AS		Company,
										nroCobranza								AS		Recibo, 
										codDocumento							AS		InvoiceNum,
										montoAplicado							AS		AppliedAmt 
					FROM				[CORPSQLMULT2019].Moviventas_test.dbo.vw_documentos_cobranza		C			WITH(NoLock)
					)	A
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
ORDER BY			2,4
GO


