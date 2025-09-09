					/******************************************************************
								SERIES TRANSFERIDAS EN EPICOR
					******************************************************************/	
SELECT		
			LB.Company,
			LB.OT,
			LB.PartNum,
			LB.SeriesProducidasPendientes,
			ISNULL(PT.TranQty, 0)																								AS CantidaTransferida, 
			ISNULL(P.PendientesT, 0)																							AS PendientesTranferir		


			
FROM		(
				SELECT				A.Company, 
									A.OT, 
									A.PartNum,
									A.SeriesProducidasPendientes
				FROM				(
										SELECT		
													Company,
													OT, 
													PartNum, 
													COUNT(*) OVER (PARTITION BY OT)		AS SeriesProducidasPendientes
										FROM		[SIP].[dbo].[SeriesFabricadas]
										WHERE		Estado ='Integrado'
									) A
				GROUP BY			A.Company, A.OT, A.PartNum,A.SeriesProducidasPendientes

			) LB

					/******************************************************************
								VALIDO SERIES TRANSFERIRDAS EN EPICOR
					******************************************************************/	
LEFT JOIN (
				-- Subconsulta para CantidaTransferida
				SELECT 
									Company, 
									JobNum, 
									Partnum, 
									CAST(SUM(TranQty) AS int)				AS TranQty
				FROM				[CORPLAB-EPIDB].[EpicorERP].Erp.PartTran
				WHERE				
									
									TranType		=		'MFG-STK'
				GROUP BY			Company, JobNum, Partnum, TranType
			) PT 
ON			LB.Company		=		PT.Company
AND			LB.OT			=		PT.JobNum 
AND			LB.PartNum		=		PT.Partnum
LEFT JOIN   (
				--Verifica lo pedidos pendiete por integrar
				SELECT		Company, OT, AutorizaTP,
							/*Estado,*/ 
							CAST(SUM(Transferir) AS int)				AS PendientesT
				FROM		[WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P 
				WHERE		AutorizaTP			=		1
				AND			Estado				in		('Integrado')
				GROUP BY	Company, OT, AutorizaTP/*,Estado*/

			) AS P
ON			LB.Company			=		P.Company
AND			LB.OT				=		P.OT