USE [WS]
GO

/*
ALTER PROCEDURE [dbo].[RV_PRC_SIP_ENCABEZADO_TP_PENDIENTE]
AS
--*/

SET DATEFORMAT DMY




SELECT		
			LB.Company,
			LB.OT,
			J.ProdQty																											AS CantidadOT,
			J.AssemblySeq																										AS SecuenciaEnsamble,
			LB.PartNum,
			J.ClassID,
			J.ProdCode,
			J.JobEngineered																										AS IngAprobado,
			J.JobReleased																										AS Liberado,
			J.JobClosed																											AS OTCerrada,
			J.CantidaEnsamble,
			LB.SeriesProducidasPendientes,
			--LB.SeriesTransfeirdasPendientes,
			ISNULL(LD.LaborQty, 0)																								AS CantidadDeclarada,
			ISNULL(PT.TranQty, 0)																								AS CantidaTransferida, 
			ISNULL(P.PendientesT, 0)																							AS PendientesTranferir,
			ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)											AS Cuenta,
			ISNULL(LB.SeriesProducidasPendientes, 0) + ISNULL(PT.TranQty, 0) + ISNULL(P.PendientesT, 0)							AS Cuenta2,
			LB.SeriesProducidasPendientes - ABS((ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)))	AS Cuenta3,
			CASE
					   WHEN					(
													ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)	>=			40
											AND		LB.SeriesProducidasPendientes												>=			40
											)
					   THEN																													40					   
					  
					   WHEN					(
													--ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)	>=	40
													(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))	>=			40
											AND		LB.SeriesProducidasPendientes												between 	1 and 39
											AND		ISNULL(LB.SeriesProducidasPendientes, 0) + ISNULL(PT.TranQty, 0) + ISNULL(P.PendientesT, 0)	<= J.ProdQty
											)
					   THEN					LB.SeriesProducidasPendientes
					   
					    WHEN				(
													(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))	between 	1 and 39
											--AND		(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))	>	0
											--AND		(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))	<	40
											AND		LB.SeriesProducidasPendientes												between 	1 and 39
											AND		ISNULL(LB.SeriesProducidasPendientes, 0) + ISNULL(PT.TranQty, 0) + ISNULL(P.PendientesT, 0)	<= J.ProdQty
											)
					   THEN					LB.SeriesProducidasPendientes

					   WHEN					(
													LB.SeriesProducidasPendientes												between 	1 and 39
											AND		ISNULL(LB.SeriesProducidasPendientes, 0) + ISNULL(PT.TranQty, 0) + ISNULL(P.PendientesT, 0)	> J.ProdQty
											)
					   THEN					LB.SeriesProducidasPendientes - ABS((ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)))

					   ELSE																													0
			END																													AS Transferir,
			CASE
						-- Validación de estado
						WHEN				 
											--VALIDA SI LA OT ESTA ABIERTA	
											J.JobClosed					<>		1 
											--VALIDA QUE ESTE APROBADO POR ING
							AND				J.JobEngineered				<>		0
											--VALIDA QUE LAOT ESTE LIBERADA
							AND				J.JobReleased				<>		0 
											--VALIDA QUE LA CANTIDAD TRANSFERIDA SEA MENOR A LA CANTIDAD PRODUCIDA
							--AND				LB.SeriesProducidas		<=		PT.TranQty			
							AND				ISNULL(LD.LaborQty, 0)		<>		0	
											--VALIDA LAS SERIES PENDIENTES NO SEAN MAYOR A LAS DECLARADAS
							AND				(
														ISNULL(LB.SeriesProducidasPendientes, 0) + ISNULL(PT.TranQty, 0) + ISNULL(P.PendientesT, 0)	> J.ProdQty
												AND
														LB.SeriesProducidasPendientes - ABS((ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))) > 0
														--LB.SeriesProducidasPendientes >	(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))
											)
											--VALIDA QUE LA CANTIDAD TRANSFERIDA SEA MENOR O IGUAL A LA DECLARADA
											--O QUE HAYA CANTIDADES DECLARADA
							AND				(
												PT.TranQty				<=		LD.LaborQty
												OR
												ISNULL(LD.LaborQty, 0)	<>		0
											)
											--Valida que la OT este cumplida
							AND				J.ProdQty					<>		ISNULL(PT.TranQty, 0)
											--Valida que haya pendientes por transferir
							AND				(ISNULL(LD.LaborQty, 3) - ISNULL(P.PendientesT, 0) -  ISNULL(PT.TranQty, 0)) <> 0

							
							
						THEN											CAST(1 AS BIT)
						ELSE											CAST(0 AS BIT)
			END																													AS AutorizaTP,
			CASE
						-- Detalle de la no autorización
						WHEN				J.JobClosed					<>		0 
						THEN				'La OT '+LB.OT+ ' está cerrada.'
						WHEN				J.JobEngineered				<>		1 
						THEN				'La OT '+LB.OT+ ' no está aprobada por Ingeniería.'
						WHEN				J.JobReleased				<>		1 
						THEN				'La OT '+LB.OT+ ' no está liberada.'
						WHEN				ISNULL(LD.LaborQty, 0)		=		0
						THEN				'Las cantidades declarada para la OT '+LB.OT+' es 0'

											--VALIDA LAS SERIES PENDIENTES NO SEAN MAYOR A LAS DECLARADAS
						WHEN				(
														ISNULL(LB.SeriesProducidasPendientes, 0) + ISNULL(PT.TranQty, 0) + ISNULL(P.PendientesT, 0)	> J.ProdQty
												AND
														LB.SeriesProducidasPendientes - ABS((ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))) > 0
														--LB.SeriesProducidasPendientes >	(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))
											)

						THEN				'La cantida de series pendientes por declarar ('+CAST ((ISNULL(LB.SeriesProducidasPendientes, 0) + ISNULL(PT.TranQty, 0) + ISNULL(P.PendientesT, 0)) AS varchar(10)) +') es mayor ('+CAST(J.ProdQty AS varchar(10))+ ') a la establecida en la OT: '+LB.OT
						WHEN				(
												PT.TranQty				>=		LD.LaborQty
												OR
												ISNULL(LD.LaborQty, 0)	=		0
											)
						--THEN				'La cantidad transferida '+CAST(PT.TranQty AS varchar(10))+ ' de la OT '+LB.OT+ ' no puede ser mayor o igual a la declarada '+CAST(LD.LaborQty AS varchar(10))
						THEN				'Hay series pendientes por transferir '+CAST(LB.SeriesProducidasPendientes AS varchar(10))+ ' de la OT '+LB.OT+ ' que no han sido declardas.'
						WHEN				J.ProdQty					=		ISNULL(PT.TranQty, 0)					
						THEN				'la OT '+LB.OT+ ' ya esta cumplida'
						WHEN				(
												(ISNULL(LD.LaborQty, 3) - ISNULL(P.PendientesT, 0) -  ISNULL(PT.TranQty, 0)) = 0
											AND
												LB.SeriesProducidasPendientes > 0
											)
						THEN				'Hay series producidas '+CAST(LB.SeriesProducidasPendientes AS varchar(10))+' pendientes por transferir de la OT '+LB.OT+ ' que no han sido Declaradas'
						ELSE				''
			END 																												AS DetalleAutoriza,
			GETDATE()																											AS Fecha
FROM		(
				SELECT				*
				FROM				[RF].[RV_VW_SIP_RFID_SERIES_PENDIENTE]
				
			) LB
LEFT JOIN	(
					/******************************************************************
						OBTEGO INF. DE ENSAMBLE, MATERIALES Y CABEZERA DE OT
					******************************************************************/
				SELECT				JH.Company, 
									JH.JobNum, 
									CAST(JH.ProdQty AS INT)					AS ProdQty, 
									CAST(JA.AssemblySeq AS INT)				AS AssemblySeq, 
									JH.PartNum,
									P.ClassID,
									P.ProdCode,
									CAST (JH.JobEngineered AS BIT)			AS JobEngineered,
									CAST(JH.JobReleased AS BIT)				AS JobReleased, 
									CAST(JH.JobClosed AS BIT)				AS JobClosed, 
									CAST(JA.QtyPer	AS INT)					AS CantidaEnsamble, 
									JA.JobComplete
				FROM				[CORPE11-EPIDB].[EpicorERP].Erp.JobMtl JM
				RIGHT JOIN			[CORPE11-EPIDB].[EpicorERP].Erp.JobOpDtl JO
					ON				JM.Company				=		JO.Company 
					AND				JM.JobNum				=		JO.JobNum 
					AND				JM.AssemblySeq			=		JO.AssemblySeq 
					AND				JM.RelatedOperation		=		JO.OprSeq
				RIGHT JOIN			[CORPE11-EPIDB].[EpicorERP].Erp.JobAsmbl JA
					ON				JA.Company				=		JO.Company 
					AND				JA.JobNum				=		JO.JobNum 
					AND				JA.AssemblySeq			=		JO.AssemblySeq
				RIGHT JOIN			[CORPE11-EPIDB].[EpicorERP].Erp.JobHead JH
					ON				JH.Company				=		JA.Company 
					AND				JH.JobNum				=		JA.JobNum
				RIGHT JOIN			[CORPE11-EPIDB].[EpicorERP].Erp.Part P
					ON				JH.Company				=		P.Company 
					AND				JH.Partnum				=		P.Partnum

				WHERE				/*JH.CreateDate			>=		'2023-01-01' --'2023-06-01'
					AND				*/JA.AssemblySeq			=			0 
					AND				JH.JobComplete			<>			1
				GROUP BY			JH.Company, JH.JobNum, JH.ProdQty ,JA.AssemblySeq ,JH.PartNum,
									P.ClassID,P.ProdCode,JH.JobEngineered,JH.JobReleased,JH.JobClosed,JA.QtyPer,
									JA.JobComplete

			) J
ON			LB.Company		=		J.Company
AND			LB.OT			=		J.JobNum 
AND			LB.PartNum		=		J.PartNum

				/******************************************************************
								VALIDO CANTIDADES DECLARADAS EN EPICOR
				******************************************************************/
LEFT JOIN	(
				SELECT				Company,									
									JobNum, 
									AssemblySeq, 
									CAST(SUM(LaborQty) AS int)		AS LaborQty
				FROM				[CORPE11-EPIDB].[EpicorERP].Erp.LaborDtl
				WHERE				
									--CreateDate >= '2023-06-01' AND 
									ApprovedDate IS NOT NULL
				GROUP BY			Company,JobNum, AssemblySeq
			) LD 
ON			J.Company		=		LD.Company
AND			J.JobNum		=		LD.JobNum 
AND			J.AssemblySeq	=		LD.AssemblySeq
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
				FROM				[CORPE11-EPIDB].[EpicorERP].Erp.PartTran
				WHERE				
									
									TranType		=		'MFG-STK'
				GROUP BY			Company, JobNum, Partnum, TranType
			) PT 
ON			J.Company		=		PT.Company
AND			J.JobNum		=		PT.JobNum 
AND			J.PartNum		=		PT.Partnum
LEFT JOIN   (
				--Verifica lo pedidos pendiete por integrar
				SELECT		Company, OT, AutorizaTP,
							/*Estado,*/ 
							CAST(SUM(Transferir) AS int)				AS PendientesT
				FROM		[WS].[dbo].RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P 
				WHERE		AutorizaTP			=		1
				AND			Estado				in		('Procesando','Pendiente')
				GROUP BY	Company, OT, AutorizaTP/*,Estado*/

			) AS P
ON			J.Company			=		P.Company
AND			J.JobNum			=		P.OT

WHERE		j.JobClosed					IS NOT NULL
--/*
AND			(		
					J.JobEngineered		=	1
			AND
					J.JobReleased		=	1
			)
--*/
GO


