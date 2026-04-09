DECLARE					@Company		NVARCHAR(8)		=		'CO01',
						--@Plant			NVARCHAR(8)		=		'CDEE',
						@OrderNum		INT				=		 281789

SELECT		B0.*,
            /* Línea ANCLA = mayor AnchorLineSelf en la “ventana móvil” de 2 líneas previas */
            MAX(B0.AnchorLineSelf) OVER (
                PARTITION BY B0.Company, B0.OrderNum
                ORDER BY B0.OrderLine
                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
            ) AS AnchorLine

FROM		(


					SELECT
									OH.Company,OH.OrderNum, OD.OrderLine, OD.PartNum
									,REL.OrderRelNum, REL.OpenRelease, REL.Plant
									,SIG.Archivo
									,ART.CodigoCategoria, ART.ClassID--,ART.*
									,SD.ReadyToInvoice, SD.ShipCmpl
									,SH.ShipPerson, SH.EntryPerson,
									CASE
																	WHEN	(
																					SD.ReadyToInvoice = 1
																				AND
																					SD.ShipCmpl = 1
																			)
																			AND
																			(
																					REL.OpenRelease=0
																			)
																			AND
																			(
																					SH.EntryPerson like 'USR_%'
																				OR
																					SH.ShipPerson	like 'USR_%'
																			)
																			OR
																			(
																					SIG.Archivo is not null
																			)
																	THEN	'DESPACHADO INTEGRACION'
																	WHEN	(
																					SD.ReadyToInvoice = 1
																				AND
																					SD.ShipCmpl = 1
																			)
																			AND
																			(
																					REL.OpenRelease=0
																			)
																			AND
																			(
																					SH.EntryPerson not like 'USR_%'
															
																			)
																			OR
																			(
																					SIG.Archivo is null
																			)
																	THEN	CONCAT('DESPACHADO POR ',UPPER(SH.ShipPerson))
																	WHEN	(
																					SD.ReadyToInvoice is null
																				OR
																					SD.ShipCmpl is null
											
																			)
																			AND
																			(
																					REL.OpenRelease=1
																			)
														
																	THEN	'PENDIENTE DE DESPACHP'

																	ELSE	'CERRADA'
									END	AS EstadoDespacho
									/* Marca de ANCLA propia si AA-SPLIT + SK% */
									,CASE
											WHEN 
													ART.CodigoCategoria = 'AA-SPLIT' 
												AND 
													ART.ClassID LIKE 'SK%'
											THEN    OD.OrderLine
											ELSE    NULL
									END                                                         AS AnchorLineSelf

					FROM			[CORPL11-EPIDB].[EpicorERPTest].Erp.OrderHed								OH
					INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.OrderDtl								OD
						ON			OH.Company		=		OD.Company
						AND			OH.OrderNum		=		OD.OrderNum
					INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.OrderRel								REL
						ON			OD.Company		=		REL.Company
						AND			OD.OrderNum		=		REL.OrderNum
						AND			OD.OrderLine	=		REL.OrderLine
					LEFT JOIN		[SIG_TEST].dbo.[Ordenes]												SIG
						ON			REL.Company		=		SIG.Company		COLLATE Modern_Spanish_CI_AS
						AND			REL.OrderNum	=		SIG.OrderNum	
						AND			REL.OrderLine	=		SIG.OrderLine	
						AND			REL.OrderRelNum	=		SIG.OrderRelNum	
					LEFT JOIN		[CORPL11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS						ART
						ON			OD.Company			=			ART.Compania
						AND			OD.PartNum			=			ART.CodigoArticulo
					LEFT JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.ShipDtl									SD
						ON			REL.Company		=		SD.Company
						AND			REL.OrderNum	=		SD.OrderNum
						AND			REL.OrderLine	=		SD.OrderLine
						AND			REL.OrderRelNum	=		SD.OrderRelNum	
					INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Shiphead									SH
						ON			SD.Company		=		SH.Company
						AND			SD.PackNum		=		SH.PackNum
	
						WHERE			
									OH.Company		=		@Company
						AND			OH.OrderNum		=		@OrderNum
) AS B0