SELECT				
					MQH.[compania]											AS Company,
					MQH.[nroCotizacion]										AS QuoteNum,
					convert (date,MQH.[fecha])								AS EntryDate,
					MQH.[codInternoCliente]									AS CustNum,
					ISNULL(MQH.[codDomicilioEntrega],'')					AS ShipToNum,
					--'TCL-99'												AS ShipToNum,
					ISNULL(MQH.[ordenDeCompra],'')							AS PONum,
					MQH.[codCampana]										AS MktgCampaignID,
					--,'001'												AS MktgCampaignID	
					ISNULL(MQH.[codCondicionDePago],'')						AS TermsCode,
					ISNULL(convert (date,MQH.[fechaEntrega]),'')			AS RequestDate,
					MQH.[codCliente]										AS CustID,
					/*
					'TCL18'													AS Territory,
					'TCL18'													AS SalesRepCode,
					*/
					O.TerritoryID											AS ShipTerritory,
					O.SalesRepCode											AS ShipSalesRepCode,
					F.NewTerritory											AS Territory,
					F.NewSalesRepCode										AS SalesRepCode,
					CASE
							WHEN	(
											O.TerritoryID		<>	F.NewTerritory
										OR
											O.SalesRepCode		<>	F.NewSalesRepCode
										
									)

							THEN	'CASE 1'
							
							WHEN	(
											O.TerritoryID		is null
										AND
											O.SalesRepCode		is null
										AND
											F.NewTerritory		is null
										AND
											F.NewSalesRepCode	is null
										
									)
							THEN	'CASE 2'
							
							
							WHEN	(
											O.TerritoryID		=	F.NewTerritory
										AND
											O.SalesRepCode		=	F.NewSalesRepCode
										
									)

							THEN	'CASE 3'
							
					END		Casos,

					GETDATE()												AS [DateTime]
					--ISNULL(MQD.[codProducto],'')							AS [PartNum],
					--,DATEADD(DAY, -30, GETDATE())							AS date
					--,CONCAT('Company=', MQH.compania, ' | ','CustNum=', MQH.codInternoCliente, ' | ','ShipToNum=', ISNULL(MQH.codDomicilioEntrega, ''), ' | ','PartNum=', ISNULL(MQD.codProducto, '')) AS DebugParams
					
FROM				[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cotizaciones] MQH		WITH(NoLock)
INNER JOIN			(
						SELECT		compania,nroCotizacion,codProducto FROM [CORPSQLMULT2019].[moviventas_test].[dbo].[vw_detalle_cotizacion]		WITH(NoLock)
						WHERE		nroCotizacion		IS NOT NULL
						AND			nroLinea=0
						--AND			[descuento]			<>0
						GROUP BY	compania,nroCotizacion,codProducto
					) MQD
ON					MQH.compania				=		MQD.compania
AND					MQH.nroCotizacion			=		MQD.nroCotizacion
LEFT JOIN			(
						SELECT			C.Company, 
										C.CustID,
										C.CustNum,
										ST.SalesRepCode, 
										ST.TerritoryID,
										ST.ShipToNum,				
										STU.Character02						AS UnidadNeg

						FROM			[CORPL11-EPIDB].EpicorErpTest.Erp.Customer				C			WITH(NoLock)

						INNER JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.ShipTo				ST			WITH(NoLock)
							ON			C.Company				=			ST.Company
							AND			C.CustNum				=			ST.CustNum
						INNER JOIN 		[CORPL11-EPIDB].EpicorErpTest.Erp.ShipTo_UD				STU			WITH(NoLock)
							ON			ST.SysRowID				=			STU.ForeignSysRowID
							WHERE		
										ST.Company				=			'CO01'
							AND			ST.ShipToNum			<>			''
							--AND			C.CustID				=			'263'
							--AND	EXISTS	(
							--			SELECT			*
							--			FROM			[CORPL11-EPIDB].EpicorErpTest.Ice.UDCodes				UD
							--			WHERE			UD.CodeTypeID			=			'MovGrupCli'
							--				AND			UD.IsActive				=			1
							--				AND			UD.Company				=			C.Company
							--				AND			UD.CodeID				=			C.GroupCode
							--			)
					) AS O
ON					MQH.[compania]					=		O.Company
AND					MQH.[codInternoCliente]			=		O.CustNum
AND					MQH.[codDomicilioEntrega]		=		O.ShipToNum

OUTER APPLY			dbo.RVF_FNC_ACTUALIZA_VENDEDOR_QUOTE(
															MQH.compania,
															CAST(MQH.codInternoCliente AS int),
															ISNULL(MQH.codDomicilioEntrega, ''),
															ISNULL(MQD.codProducto, '')
														) AS F

WHERE			
					MQH.nroCotizacion					IS NOT NULL
AND					MQH.nroCotizacion					> '2013'
AND					convert (date,MQH.[fechaEntrega])	>= DATEADD(YEAR, -2, GETDATE())
AND					MQH.[codDomicilioEntrega]			IS NOT NULL
ORDER				BY	convert (date,MQH.[fechaEntrega]) DESC


SELECT				MQD.[compania]																				AS Company,
					MQD.[nroCotizacion]																			AS QuoteNum,
--					MQD.[nroLinea]																				AS QuoteLine,
					[dbo].[RVF_FNC_Calcula_NroLinea] (MQD.[compania], MQD.[nroCotizacion], MQD.[nroLinea])		AS QuoteLine, 
					MQD.[codProducto]																			AS PartNum,
					MQD.[cantidad]																				AS SellingExpectedQty,
					MQD.[precio]																				AS ListPrice,
					ISNULL(MQD.[descuento],0)																	AS DiscountPercent  

FROM				[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_detalle_cotizacion]		MQD		WITH(NoLock)
INNER JOIN			(
					SELECT		compania,nroCotizacion 
					FROM		[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cotizaciones]		WITH(NoLock)
					WHERE		nroCotizacion		IS NOT NULL
					--AND			CAST (Fecha AS date)			>=		DATEADD(DAY, -30, GETDATE())
					)	MQH

ON					MQH.compania			=			MQD.compania
AND					MQH.nroCotizacion		=			MQD.nroCotizacion
WHERE				MQD.nroCotizacion		IS NOT NULL
AND					MQD.nroCotizacion		in ('26110','55055','26112','55056','26101','55049','55048','55046')		
--AND					MQD.[descuento]			<>0

order by 1, 2,3
