[QuoteNum] in (60699,60688, 60956)

select * from RVF_TBL_IMP_QUOTE_HEADER
where [QuoteNum] in (60956)
 
select * from RVF_TBL_IMP_QUOTE_DETAIL
where [QuoteNum] in (60956)


select * from RVF_TBL_IMP_QUOTE_HEADER_PROBLEMA
where [QuoteNum] in (60956)

select * from RVF_TBL_IMP_QUOTE_DETAIL_PROBLEMA
where [QuoteNum] in (60956)

Select W.*
FROM	(

			SELECT
						MQD.compania,
						MQD.nroCotizacion,
						dbo.RVF_FNC_Calcula_NroLinea(MQD.compania, MQD.nroCotizacion, MQD.nroLinea) AS NroLinea,
						MQD.codProducto,
						MQD.cantidad,
						MQD.precio,
						ISNULL(MQD.descuento, 0) AS descuento
			FROM		(
							SELECT		
										
										compania, NroCotizacion,codProducto, nroLinea, cantidad, max(precio)AS precio, descuento
							FROM
							[CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]	WITH(NOLOCK)							
							group by	compania, NroCotizacion,codProducto, nroLinea, cantidad, descuento

						) AS MQD
						--[CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion] AS MQD 
			INNER JOIN	(
							SELECT		compania, nroCotizacion
							FROM		[CORPSQLMULT2019].[moviventas].[dbo].[vw_cotizaciones] WITH(NOLOCK)
							WHERE		nroCotizacion IS NOT NULL
							  --AND		CAST(Fecha AS DATE) >= DATEADD(DAY, -30, GETDATE())
						) AS MQH
				ON		MQH.compania		=		MQD.compania
			   AND		MQH.nroCotizacion	=		MQD.nroCotizacion
			--INNER JOIN	@TeporalHEADER AS T
			--	ON		T.Company			=		MQD.compania
			--   AND		T.QuoteNum			=		MQD.nroCotizacion
			WHERE
						MQD.nroCotizacion IS NOT NULL
			AND			MQD.nroCotizacion in	(60956)
	) W
	ORDER BY W.compania,W.nroCotizacion,W.NroLinea
 
	SELECT			DC.compania, DC.NroCotizacion, DC.codProducto, DC.nroLinea + 1 AS nroLinea, ART.CodigoCategoria, ART.ClassID,
					CASE 
						WHEN		(		ART.CodigoCategoria		=	'AA-SPLIT'
										AND
											ART.ClassID				LIKE	'%SK%'
										)
 
																		THEN		3
						ELSE														1
					END									AS LineasTotales			
	FROM			(
						SELECT		
									DISTINCT
									compania, NroCotizacion,codProducto, nroLinea
						FROM
						[CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]								
						

					) AS DC
	LEFT OUTER JOIN	[CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS			ART
		ON			DC.codProducto			=			ART.CodigoArticulo
	WHERE			DC.compania				=			'CO01'
		AND			DC.nroCotizacion		in			(60956)		
	ORDER by  DC.compania, DC.NroCotizacion, cast(DC.nroLinea AS INT)

		
		SELECT		*
		FROM		[CORPSQLMULT2019].[moviventas].[dbo].[vw_cotizaciones] WITH(NOLOCK)
		WHERE		nroCotizacion in ('60956')
		
		
		select * from [CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]								
		where
				nroCotizacion		in ('60956')
		order by nroCotizacion, nroLinea 


		SELECT			DC.compania, DC.NroCotizacion, DC.codProducto, DC.nroLinea + 1 AS nroLinea, ART.CodigoCategoria, ART.ClassID,
					CASE 
						WHEN		(		ART.CodigoCategoria		=	'AA-SPLIT'
										AND
											ART.ClassID				LIKE	'%SK%'
										)
 
																		THEN		3
						ELSE														1
					END									AS LineasTotales			
	FROM			(
						SELECT		
									DISTINCT
									compania, NroCotizacion,codProducto, nroLinea
						FROM
						[CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]								
						

					) AS DC
	inner JOIN	[CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS			ART
		ON			DC.codProducto			=			ART.CodigoArticulo
	WHERE			DC.compania				=			'CO01'
		--AND			DC.nroCotizacion		in			(60956)		
		and			ART.CodigoCategoria		=	'AA-SPLIT'
		and			ART.ClassID				=	'SKRE'
	ORDER by  DC.compania, DC.NroCotizacion, cast(DC.nroLinea AS INT)
				
				