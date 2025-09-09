
SELECT					*, 
						TotalLinea / CantidadPedida * CantidadEntregar		AS		ValorPendiente
FROM					(
							Select

													OD.OrderNUM,
													OD.ORDERLINE,
													OH.OrderDate,
													ISNULL(Tax.DocTaxAmt, 0)							AS TotalImpuesto, 
													ROUND((OD.DocExtPriceDtl - OD.DocDiscount +  
													ISNULL(Tax.DocTaxAmt, 0)), 2)						AS TotalLinea,
													OD.OrderQty											AS CantidadPedida,
													ORel.PendEntrega									AS CantidadEntregar


													
							FROM					[CORPEPIDB].EpicorERP.Erp.OrderHed	OH		WITH (NoLock)

							INNER JOIN				[CORPEPIDB].EpicorERP.Erp.OrderDtl	OD		WITH (NoLock)
							ON					OH.Company			=			OD.Company
							AND					OH.OrderNum			=			OD.OrderNum

							LEFT OUTER JOIN			(
														SELECT					Company, OrderNum, OrderLine, SUM(DocTaxAmt) 
																				AS DocTaxAmt  
														FROM					[CORPEPIDB].EpicorERP.Erp.OrderRelTax		WITH (NoLock)
														GROUP BY				Company, OrderNum, OrderLine
													) Tax
							ON					OD.Company			=			Tax.Company
							AND					OD.OrderNum			=			Tax.OrderNum
							AND					OD.OrderLine		=			Tax.OrderLine

							LEFT OUTER JOIN			(
												SELECT			Company, OrderNum, OrderLine, Plant, 
																SUM(OurReqQty - OurStockShippedQty)  AS PendEntrega
												FROM			[CORPEPIDB].EpicorERP.Erp.OrderRel			WITH (NoLock)
												GROUP BY		Company, OrderNum, OrderLine, Plant
												)										ORel
							ON					OD.Company			=			ORel.Company
							AND					OD.OrderNum			=			ORel.OrderNum
							AND					OD.OrderLine		=			ORel.OrderLine

							where
											OH.Company			=			'CO01'
							AND				OH.DocOrderAmt		<>			0
							--AND				OD.DocExtPriceDtl	=			0
							--AND				OH.OrderDate		BETWEEN		DATEADD(YEAR,-1,GETDATE() )  and GETDATE()
							AND				OH.OrderNUM			='123033'

							)	W