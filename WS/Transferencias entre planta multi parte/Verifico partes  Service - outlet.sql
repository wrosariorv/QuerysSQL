SELECT 
		DISTINCT
		* 
FROM
		(
			SELECT	
					
					X.Company,
					X.PartNum,
					X.SNPrefix,
					X.Estado
			FROM	[CORPSQLMULT2019].[WS].[TP].[RV_VW_SIP_PARTES_MAL_CARGADAS_FRA6403]	X
			WHERE
					X.Estado IN ('ERROR')
		   ----------
			UNION ALL
		   ---------
			SELECT	
					
					Y.Company,
					Y.PartNum,
					Y.SNPrefix,
					Y.Estado
			FROM	[CORPSQLMULT2019].[WS].[TP].[RV_VW_SIP_PARTES_MAL_CARGADAS_PER2823]	Y
			WHERE
					Y.Estado IN ('ERROR')
		) AS E

