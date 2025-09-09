


/*

CREATE PROCEDURE	[dbo].[RVF_PRC_TRANSFER_PRODUCCION_TRANSFERIDOS]	@Empresa			VARCHAR(15), 
																		@FechaDesde			DATE,   
																		@FechaHasta			DATE,  
																		@OT					VARCHAR(50)

AS

 */

SET		DATEFORMAT DMY

DECLARE	
						--------------------------------------------------------------
 --/*
						@Empresa			VARCHAR(15)			=		'CO01', 
						@FechaDesde			DATE				=		'01/04/2023', 
						@FechaHasta			DATE				=		'30/08/2023', 
						@OT					VARCHAR(50)			=		'RV000049'	,
 --*/
						--------------------------------------------------------------

						@OTIni		VARCHAR(50), 
						@OTFin		VARCHAR(50)
 
------------------------------------------------------------------------------------------------------------------

IF		@OT		=	'Todos'	
		BEGIN		
				SELECT		@OTIni			=		'', 
							@OTFin			=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@OTIni			=		@OT, 
							@OTFin			=		@OT	
		END 

------------------------------------------------------------------------------------------------------------------

BEGIN



	
SELECT		
			LB.Company,
			LB.OT,
			J.ProdQty																											AS CantidadOT,
			J.AssemblySeq																										AS SecuenciaEnsamble,
			LB.PartNum,
			J.ClassID,
			J.JobEngineered																										AS IngAprobado,
			J.JobReleased																										AS Liberado,
			J.JobClosed																											AS OTCerrada,
			J.CantidaEnsamble,
			LB.SeriesProducidasPendientes,
			ISNULL(LD.LaborQty, 0)																								AS CantidadDeclarada,
			ISNULL(PT.TranQty, 0)																								AS CantidaTransferida, 
			ISNULL(P.PendientesT, 0)																							AS PendientesTranferir,
			--ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)											AS Cuenta,
			CASE
					   WHEN					(
													ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)	>=	40
											AND		ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)	<=	LB.SeriesProducidasPendientes
											)
					   THEN					40
					   WHEN					(
													(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0))	>	0 
											 AND	(ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) - ISNULL(P.PendientesT, 0)) >=	LB.SeriesProducidasPendientes 
											)
					   THEN					LB.SeriesProducidasPendientes
					   
					   ELSE					0
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
											--VALIDA QUE LA CANTIDAD TRANSFERIDA SEA MENOR O IGUAL A LA DECLARADA
											--O QUE HAYA CANTIDADES DECLARADA
							AND				(
												PT.TranQty				<=		LD.LaborQty
												OR
												LD.LaborQty				<>		0
											)
											--Valida que la OT este cumplida
							AND				J.ProdQty					<>		ISNULL(PT.TranQty, 0)
											--Valida que haya pendientes por transferir
							AND				(ISNULL(LD.LaborQty, 3) - ISNULL(P.PendientesT, 0) -  ISNULL(PT.TranQty, 0)) <> 0

							--AND				LB.SeriesProducidas			<>		
							
						THEN											CAST(1 AS BIT)
						ELSE											CAST(0 AS BIT)
			END																													AS AutorizaTP,
			GETDATE()																											AS Fecha
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
										WHERE		Estado		=		'Integrado'
										AND			OT		between		@OTIni and @OTFin 
									) A
				GROUP BY			A.Company, A.OT, A.PartNum,A.SeriesProducidasPendientes

			) LB
LEFT JOIN	(
					/******************************************************************
						OBTEGO INF. DE ENSAMBLE, MATERIALES Y CABEZERA DE OT
					******************************************************************/
				SELECT				Company, 
									JobNum, 
									ProdQty, 
									AssemblySeq, 
									PartNum,
									ClassID,
									JobEngineered,
									JobReleased, 
									JobClosed, 
									CantidaEnsamble, 
									JobComplete,
									CreateDate
				FROM				[CORPE11-SSRS].[RVF_Local].dbo.[RVF_VW_WS_INFORMACION_OTS_ABIERTAS] OT WITH (NoLock)

				WHERE				CreateDate			between		@FechaDesde and @FechaHasta 
					AND				JobNum				between		@OTIni and @OTFin 


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
									LaborQty
				FROM				[CORPE11-SSRS].[RVF_Local].dbo.[RVF_VW_WS_CANTIDAD_DECLARADA_OTS_ABIERTAS] OT WITH (NoLock)
				--WHERE				
									--CreateDate >= '2023-06-01' 									
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
									TranQty
				FROM				[CORPE11-SSRS].[RVF_Local].dbo.[RVF_VW_WS_CANTIDAD_SERIES_TRANSFERIDAS] OT WITH (NoLock)
				
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
				AND			Estado				in		('Integrado')
				GROUP BY	Company, OT, AutorizaTP/*,Estado*/

			) AS P
ON			J.Company			=		P.Company
AND			J.JobNum			=		P.OT

WHERE		j.JobClosed IS NOT NULL





-----------------------------------------------------------------

END

------------------------------------------------------------------------------------------------------------------
