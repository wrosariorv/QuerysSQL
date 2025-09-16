SELECT
					LEFT(LTRIM(RTRIM(REPLACE(OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)   AS OtherDetails,
					NULLIF(LEFT(LTRIM(RTRIM(LegalNumber)), 30), '')                             AS LegalNumber,
					CAST(TranAmt AS numeric(17,3))                                              AS TranAmt,
					CASE 
							WHEN Posted = 0 THEN 'No Posteada'
							WHEN Posted = 1 THEN 'Posteada'
					END                                                                         AS Estado
        FROM		[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead
        WHERE 
					TranDate				>=		DATEADD(DAY, -30, GETDATE())
			AND		
					ISNULL(OtherDetails, '') <>		''

			AND NOT EXISTS
							(
							    SELECT		1
							    FROM		[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas T
							    WHERE		T.NroReciboMoviventas		=		LEFT(LTRIM(RTRIM(REPLACE(CashHead.OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)
							      AND		ISNULL(T.LegalNumber,'')	=		ISNULL(LEFT(LTRIM(RTRIM(CashHead.LegalNumber)), 30), '')
							      AND		(
													(T.TranAmt = CAST(CashHead.TranAmt AS numeric(17,3)))
												OR		
													(T.TranAmt IS NULL AND CAST(CashHead.TranAmt AS numeric(17,3)) IS NULL)
											)
							      AND		ISNULL(T.Estado,'')			=		CASE	WHEN CashHead.Posted = 0 THEN 'No Posteada'
																						WHEN CashHead.Posted = 1 THEN 'Posteada' 
																				END
							)



SELECT
			LEFT(LTRIM(RTRIM(REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)   AS OtherDetails,
			NULLIF(LEFT(LTRIM(RTRIM(CH.LegalNumber)), 30), '')                             AS LegalNumber,
			CAST(TranAmt AS numeric(17,3))                                              AS TranAmt,
			CASE 
					WHEN CH.Posted = 0 THEN 'No Posteada'
					WHEN CH.Posted = 1 THEN 'Posteada'
			END                                                                         AS Estado
FROM		[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead									CH
INNER JOIN	[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cobranzas]					MOVI
ON			CH.OtherDetails			=		MOVI.nroCobranza
WHERE 
	--		CH.TranDate				>=		DATEADD(DAY, -30, GETDATE())
	--AND		
			ISNULL(Ch.OtherDetails, '') <>		''

	AND NOT EXISTS
					(
						SELECT		1
						FROM		[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas T
						WHERE		T.NroReciboMoviventas		=		LEFT(LTRIM(RTRIM(REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)
							AND		ISNULL(T.LegalNumber,'')	=		ISNULL(LEFT(LTRIM(RTRIM(CH.LegalNumber)), 30), '')
							AND		(
											(T.TranAmt = CAST(CH.TranAmt AS numeric(17,3)))
										OR		
											(T.TranAmt IS NULL AND CAST(CH.TranAmt AS numeric(17,3)) IS NULL)
									)
							AND		ISNULL(T.Estado,'')			=		CASE	WHEN CH.Posted = 0 THEN 'No Posteada'
																				WHEN CH.Posted = 1 THEN 'Posteada' 
																		END
					)

					delete  [CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas




					SELECT
									LEFT(LTRIM(RTRIM(L.Recibo)), 50)										AS OtherDetails,
									NULL																	AS LegalNumber,
									CAST(0 AS numeric(17,3))												AS TranAmt,
									'Eliminada'																AS Estado
					FROM			RVF_Local.dbo.RVF_TBL_IMP_RECIBO_LOG									L		WITH (NOLOCK)
					INNER JOIN	[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cobranzas]					MOVI	WITH (NOLOCK)
					ON			L.Recibo			=		MOVI.nroCobranza
					WHERE			/*L.FechaProceso		>=		DATEADD(DAY, -30, GETDATE())--DATEADD(YEAR/*DAY*/, -2, GETDATE()) || DATEADD(DAY, -30, GETDATE())
						AND */NOT EXISTS
										(
										  SELECT		1
										  FROM			[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead CH WITH (NOLOCK)
										  WHERE			ISNULL(CH.OtherDetails, '')		<>		''
											AND		L.Recibo							=		REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', '')
										)
					  AND NOT EXISTS
										(
											SELECT		1
											FROM		[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas T
											WHERE		T.NroReciboMoviventas		=		LEFT(LTRIM(RTRIM(L.Recibo)), 50)
											  AND		(T.LegalNumber IS NULL OR T.LegalNumber = '')
											  AND		T.TranAmt = CAST(0 AS numeric(17,3))
											  AND		ISNULL(T.Estado,'') = 'Eliminada'
										)

										