SELECT			ISNULL(SUM(LineasTotales), 0) + 1
FROM			(
				SELECT			DC.compania, DC.NroCotizacion, DC.nroLinea + 1 AS nroLinea, ART.CodigoCategoria, 
								CASE 
									WHEN		(		ART.CodigoCategoria	=	'AA-SPLIT'
													AND
														ART.ClassID			=	'SK'
												 )

																					THEN		3
									ELSE														1
								END										AS LineasTotales			
				FROM			[CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]								DC
				LEFT OUTER JOIN	[CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS			ART
					ON			DC.codProducto			=			ART.CodigoArticulo
				WHERE			DC.compania				=			'CO01'
					AND			DC.nroCotizacion		=			'55806'
					AND			DC.nroLinea				<			'2' 
				)	A


				select		Top 10
							* 
				from [CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS			ART
				where 
						--CodigoArticulo in ('RL3400FC-M-SK','TP3100INV-F-SK')
						CodigoArticulo in ('RL3400FC-M-SK','RL5400FC-F-SK','RL6500FC-F-SK','TP3100INV-F-SK')


				select * from [dbo].[RVF_VW_IMP_QUOTE_DETAIL]
				where QuoteNum='55806'