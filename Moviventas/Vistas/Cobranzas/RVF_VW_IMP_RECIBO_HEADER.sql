USE [RVF_Local]
GO

/*

ALTER VIEW			[dbo].[RVF_VW_IMP_RECIBO_HEADER]
AS

--*/


/*

SELECT				*
FROM				(
					SELECT
					'CO01'						AS		Company, 
					'Prueba'					AS		GroupID, 
					'IN/EG'						AS		BankAcctID,
					'19/10/2020'				AS		TranDate, 
					'999999'					AS		Vendedor, 
					'HIT'						AS		UnNeg, 
					557000						AS		DocTranAmt, 
					'Recibo de Prueba'			AS		Reference, 
					'5580'						AS		CustID, 
					1							AS		OnAccount, 
					'0000-00123456'				AS		Recibo

					UNION ALL

					SELECT	
					'CO01', 
					'Prueba', 
					'IN/EG',
					'19/10/2020', 
					'999999', 
					'HIT', 
					100000, 
					'Recibo de Prueba 2', 
					'5580', 
					1, 
					'0000-00123487'
					)			A

*/

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
SELECT				
					A.Company,	A.GroupID, A.BankAcctID, A.TranDate, A.Vendedor, A.UnNeg, A.DocTranAmt, A.Reference, 
					A.CustID, A.OnAccount, A.Recibo, 
					A.CashHead_UD_CheckBox01									AS	CheckBox01, 
					A.CashHead_UD_Character01									AS	Character01 

FROM				(
					SELECT				'CO01'															AS		Company, 
										RIGHT('00' + CAST(DATEPART(dd, GETDATE()) AS VARCHAR (4)), 2) + 
										LEFT(marca, 1) + 
										RIGHT(ISNULL(codVendedor, 999999), 2) + '-' + 
										RIGHT('00' + CAST(DATEPART(hh, GETDATE()) AS VARCHAR (10)), 2) 
																										AS		GroupID, 
										'IN/EG'															AS		BankAcctID, 
										
										----------------------------------------------------------------------------------
										-- Si la fecha del recibo ya esta cerrada, asigno al grupo el dia calendario siguiente
										CASE 
											WHEN CAST(C.fecha AS DATE) >	(
																			SELECT			UD.Date01 
																			FROM			[CORPL11-EPIDB].EpicorErpTest.Ice.UD39		UD
																			WHERE			UD.Key1				=			'CierreCobranza' 
																			AND				UD.Company			=	'CO01'						--Se agrego Filtro por company RV
																			)	THEN 			CAST(C.fecha AS DATE)
											ELSE												CAST(GETDATE() + 1 AS DATE)	
											END															AS		TranDate, 
										----------------------------------------------------------------------------------
										ISNULL(C.codVendedor, 999999)									AS		Vendedor,
										C.marca															AS		UnNeg, 
										C.totalRecibo													AS		DocTranAmt, 
										LEFT(isnull(C.comentarios, ''), 50)								AS		Reference, 
										C.codCliente													AS		CustID, 
										1																AS		OnAccount, 
										C.nroCobranza													AS		Recibo, 
										----------------------------------------------------------------
										CAST(ISNULL(T.CodeDesc, 0) AS BIT)								AS		CashHead_UD_CheckBox01, 
										CASE(ISNULL(C.codObservacion, ''))
												WHEN 'AC-AA'	THEN	'AA-SPLIT'
												WHEN 'AC-TV'	THEN	'TV-LED'	
												WHEN 'AC-CEL'	THEN	'CEL'	
												WHEN 'AC-MWO'	THEN	'MWO'	
												ELSE					''
										END																AS		CashHead_UD_Character01, 
										C.nroCobranza

					FROM				[CORPSQLMULT2019].Moviventas_test_test.dbo.vw_cobranzas				C				WITH(NoLock) 

					LEFT OUTER JOIN		RVF_VW_MOVI_TIPO_COBRANZA								T				WITH(NoLock) 
						ON				C.codObservacion				=			T.CodeID 
					) A

WHERE NOT EXISTS	(
					SELECT					*	
					FROM					RVF_TBL_IMP_RECIBO_LOG		WITH(NoLock)
					WHERE					A.Company			=			RVF_TBL_IMP_RECIBO_LOG.Company
						AND					A.nroCobranza		=			RVF_TBL_IMP_RECIBO_LOG.Recibo
					)

/*
	AND				(
					A.nroCobranza			BETWEEN			241		AND		251
					)
*/
GO

select *
FROM				[CORPSQLMULT2019].Moviventas_test.dbo.vw_cobranzas				C				WITH(NoLock) 