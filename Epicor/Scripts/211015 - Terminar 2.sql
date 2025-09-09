
SET DATEFORMAT DMY


DECLARE				@Company			VARCHAR(15)					=		'', 
					@Plant				VARCHAR(15)					=		'', 
					@FechaDesde			DATE						=		'01/08/2021', 
					@FechaHasta			DATE						=		'31/08/2021' 

---------------------------------------------------------------------------------------------------------------------

BEGIN


		EXECUTE				RVF_PRC_TOTALES_PRODUCCCION_MES_AA_TOTAL_PERIODO
							@Company, 
							@Plant, 
							@FechaDesde, 
							@FechaHasta

		EXECUTE				RVF_PRC_TOTALES_PRODUCCCION_MES_OTROS
							@Company, 
							@Plant, 
							@FechaDesde, 
							@FechaHasta

END



---------------------------------------------------------------------------------------------------------------------


SELECT					Company, ProdCode, SUM(SaldoFinal)	AS ProduccionFinal
FROM					(
						SELECT					Company, Componente_SK, ProdCode, 
												MIN(SaldoInicial + Fabricado) AS SaldoFinal
						FROM					RVF_TBL_TOTALES_PRODUCCCION_MES_AA
						WHERE					Fabricado			<>			0
						GROUP BY				Company, Componente_SK, ProdCode  
						)	A
GROUP BY				Company, ProdCode 

-----------------
UNION ALL
-----------------

SELECT					Company, ProdCode, SUM(TranQty)		AS		ProduccionFinal
FROM					RVF_TBL_TOTALES_PRODUCCCION_MES_OTROS
GROUP BY				Company, ProdCode 

---------------------------------------------------------------------------------------------------------------------
