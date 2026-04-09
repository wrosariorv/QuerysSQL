select * from [moviventas_test].dbo.key_values

begin tran 

UPDATE [moviventas_test].dbo.key_values
set value='76777'
where
	key_='Collect'

--commit tran
rollback tran


select 
		
		MAX(CAST(MOVI.nroCobranza as int))
from [CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cobranzas]					MOVI
group by MOVI.nroCobranza
order by MOVI.nroCobranza desc


SELECT
    MAX(CAST(MOVI.nroCobranza AS INT)) AS nroCobranza_MasAlto
FROM
    [CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cobranzas] MOVI;


	[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead	


SELECT			MAX(CAST(ISNULL(CH.OtherDetails, '') AS INT)) AS nroCobranza_MasAlto
FROM			[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead CH WITH (NOLOCK)
WHERE			ISNULL(CH.OtherDetails, '')		<>		''
AND				REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', '')

SElECT
    --MAX(TRY_CAST(CH.OtherDetails AS INT)) AS nro_MasAlto_Validado,
    TRY_CAST(CH.OtherDetails AS INT) AS [MasAlto_Validado]
FROM
    [CORPL11-EPIDB].EpicorErpTest.Erp.CashHead CH WITH (NOLOCK)
WHERE
    CH.OtherDetails IS NOT NULL
    AND CH.OtherDetails <> '' -- Valida que el campo no esté vacío
ORDER BY  TRY_CAST(CH.OtherDetails AS INT) desc