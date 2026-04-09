select * 
--delete
from [CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas
where
		NroReciboMoviventas > 76777
order by Fecha desc

select A.*,B.GroupID, B.HeadNum, B.CheckRef from RVF_Local.dbo.RVF_TBL_IMP_RECIBO_LOG A
inner join    [CORPL11-EPIDB].EpicorErpTest.Erp.CashHead AS B
ON              A.Company           =       B.Company
AND             A.Recibo            =       TRY_CAST(B.OtherDetails AS INT)
WHERE
                B.OtherDetails IS NOT NULL
    AND         B.OtherDetails <> ''
    AND         TRY_CAST(B.OtherDetails AS INT) > 76777
    AND         CAST (A.FechaProceso AS date)>'2025-10-30'
order by	FechaProceso desc


SElECT
    *
FROM
    [CORPL11-EPIDB].EpicorErpTest.Erp.CashHead CH WITH (NOLOCK)
WHERE
    CH.OtherDetails IS NOT NULL
    AND CH.OtherDetails <> ''
    AND TRY_CAST(CH.OtherDetails AS INT) in (76778)

--Encabezado de entrada integracion
select * from [dbo].[RVF_VW_IMP_RECIBO_HEADER]

--EXEC [dbo].[RVF_PRC_MOVI_ESTADO_COBRANZAS_TEST]


/* ================================================================
           1) Tabla variable de staging (sin #temp)
           ================================================================ */
			DECLARE @TablaTemporal TABLE
			(
				OtherDetails  varchar(50)   NOT NULL PRIMARY KEY,
				LegalNumber   varchar(30)   NULL,
				TranAmt       numeric(17,3) NULL,
				Estado        varchar(11)   NOT NULL
			);

         /* Cobranzas registradas en Epicor (últimos 30 días) */
        --INSERT INTO @TablaTemporal (OtherDetails, LegalNumber, TranAmt, Estado)
        SELECT		
					X.OtherDetails,
					X.LegalNumber,
					X.TranAmt,
					X.Estado
					--,X.TranDate
		FROM		(
						SELECT		
									LEFT(LTRIM(RTRIM(REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)	AS OtherDetails,
									NULLIF(LEFT(LTRIM(RTRIM(CH.LegalNumber)), 30), '')								AS LegalNumber,
									CAST(CH.TranAmt AS numeric(17,3))												AS TranAmt,
									CH.Posted,
									CASE 
											WHEN CH.Posted = 0 THEN 'No Posteada'
											WHEN CH.Posted = 1 THEN 'Posteada'
									END																			AS Estado,
									CH.TranDate,
									ROW_NUMBER() OVER (
										PARTITION BY LEFT(LTRIM(RTRIM(REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)
										ORDER BY	CH.TranDate ASC
										-- Opcional: desempate si hubiera misma fecha en varias filas:
										-- , CH.TranNum ASC
									)																			AS rn
						FROM		[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead									CH
						INNER JOIN	[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cobranzas]					MOVI
						ON			CH.OtherDetails			=		MOVI.nroCobranza
						WHERE		ISNULL(CH.OtherDetails, '') <>	''
						AND NOT EXISTS		(
												SELECT		1
												FROM		[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas	T
												WHERE		T.NroReciboMoviventas	=	LEFT(LTRIM(RTRIM(REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)
													AND		ISNULL(T.LegalNumber,'')	=	ISNULL(LEFT(LTRIM(RTRIM(CH.LegalNumber)), 30), '')
													AND		(
																	(T.TranAmt = CAST(CH.TranAmt AS numeric(17,3)))
																OR		
																	(T.TranAmt IS NULL AND CAST(CH.TranAmt AS numeric(17,3)) IS NULL)
															)
													AND		ISNULL(T.Estado,'')	=	CASE	WHEN CH.Posted = 0 THEN 'No Posteada'
																							WHEN CH.Posted = 1 THEN 'Posteada' 
																					END
											)
						AND CH.LegalNumber NOT in	(
														SELECT			CH.LegalNumber
														FROM			[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead CH WITH (NOLOCK)
														WHERE			ISNULL(CH.OtherDetails, '')		in ('37205','37361','6575')
														AND				CH.GroupID						in ('27T16-12','25H08-07')
														And				LegalNumber						in ('RA-00077585','RA-00123376','RA-00123381')
													)
					)	X
		WHERE		X.rn  = 1

        /* Cobranzas integradas y luego eliminadas desde Epicor (últimos 30 días) */
        --INSERT INTO @TablaTemporal (OtherDetails, LegalNumber, TranAmt, Estado)
        SELECT			DISTINCT
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
			AND L.Recibo NOT in	(
											SELECT			CH.OtherDetails
											FROM			[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead CH WITH (NOLOCK)
											WHERE			ISNULL(CH.OtherDetails, '')		in ('37205','37361','6575')
											AND				CH.GroupID						in ('27T16-12','25H08-07')
											And				LegalNumber						in ('RA-00077585','RA-00123376','RA-00123381')
										)

							select * from @TablaTemporal





