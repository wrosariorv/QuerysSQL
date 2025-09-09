USE [WS]
GO





/*
ALTER PROCEDURE [dbo].[RV_PRC_SIP_ENCABEZADO_TP_PENDIENTE_TEST]
AS
*/
-- 1. Crear índices en las columnas utilizadas en las cláusulas de unión y las cláusulas WHERE
--CREATE INDEX IX_JobMtl ON [CORPLAB-EPIDB].[EpicorERP].Erp.JobMtl (Company, JobNum, AssemblySeq, RelatedOperation);
--CREATE INDEX IX_JobOpDtl ON [CORPLAB-EPIDB].[EpicorERP].Erp.JobOpDtl (Company, JobNum, AssemblySeq, OprSeq);
--CREATE INDEX IX_JobAsmbl ON [CORPLAB-EPIDB].[EpicorERP].Erp.JobAsmbl (Company, JobNum, AssemblySeq);
--CREATE INDEX IX_JobHead ON [CORPLAB-EPIDB].[EpicorERP].Erp.JobHead (Company, JobNum);
/*
-- Índice para la tabla [CORPLAB-DB-01].[SIP].[dbo].[SeriesFabricadas]
CREATE NONCLUSTERED INDEX IX_SeriesFabricadas_Estado_Company_OT_PartNum
ON [CORPLAB-DB-01].[SIP].[dbo].[SeriesFabricadas] (Estado, Company, OT, PartNum);

-- Índices para la tabla [CORPLAB-EPIDB].[EpicorERP].Erp.JobHead
CREATE NONCLUSTERED INDEX IX_JobHead_CreateDate
ON [CORPLAB-EPIDB].[EpicorERP].Erp.JobHead (CreateDate);

CREATE NONCLUSTERED INDEX IX_JobHead_JobComplete
ON [CORPLAB-EPIDB].[EpicorERP].Erp.JobHead (JobComplete);

-- Índices para la tabla [CORPLAB-EPIDB].[EpicorERP].Erp.JobAsmbl
CREATE NONCLUSTERED INDEX IX_JobAsmbl_Company_JobNum_AssemblySeq
ON [CORPLAB-EPIDB].[EpicorERP].Erp.JobAsmbl (Company, JobNum, AssemblySeq);

-- Índices para la tabla [CORPLAB-EPIDB].[EpicorERP].Erp.PartTran
CREATE NONCLUSTERED INDEX IX_PartTran_TranType_Company_JobNum_PartNum
ON [CORPLAB-EPIDB].[EpicorERP].Erp.PartTran (TranType, Company, JobNum, PartNum);
*/

SET DATEFORMAT DMY

--INTO [CORPLAB-DB-01].[WS].[Dbo].[RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P]
SELECT				J.Company, 
					J.JobNum									AS OT, 
					J.ProdQty									AS CantidadOT, 
					J.AssemblySeq								AS SecuenciaEnsamble, 
					J.PartNum,
					J.ClassID,
					J.JobEngineered								AS IngAprobado, 
					J.JobReleased								AS Liberado, 
					J.JobClosed									AS OTCerrada,
					J.CantidaEnsamble, 
					LB.SeriesProducidas							AS SeriesProducidas, 
					ISNULL(LD.LaborQty, 0)						AS CantidadDeclarada,
					ISNULL(PT.TranQty, 0)						AS CantidaTransferida, 
					CASE
					   WHEN					ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) >= 40 
					   THEN					40
					   WHEN					ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0) <= 40 
					   THEN					ISNULL(LD.LaborQty, 0) - ISNULL(PT.TranQty, 0)
					   ELSE					0
				   END											AS Transferir,
					CASE
						-- Validación de estado
						WHEN				--VALIDA SI QUE SE HAYA PRODUCIDO AL MENOS UNA SERIE
											LB.SeriesProducidas IS NOT NULL 
											--VALIDA SI LA OT ESTA ABIERTA	
							AND				J.JobClosed			<>		0 
											--VALIDA QUE ESTE APROBADO POR ING
							AND				J.JobEngineered		<>		1
											--VALIDA QUE LAOT ESTE LIBERADA
							AND				J.JobReleased		<>		1 
											--VALIDA QUE LA CANTIDAD TRANSFERIDA SEA MENOR A LA CANTIDAD PRODUCIDA
							AND				PT.TranQty			<=		LB.SeriesProducidas 
											--VALIDA QUE LA CANTIDAD TRANSFERIDA SEA MENOR O IGUAL A LA DECLARADA
							AND				PT.TranQty			<=		LD.LaborQty
						THEN											CAST(0 AS BIT)
						ELSE											CAST(1 AS BIT)
					END							AS AutorizaTP,
					GETDATE() AS Fecha
FROM (
					/******************************************************************
						OBTEGO INF. DE ENSAMBLE, MATERIALES Y CABEZERA DE OT
					******************************************************************/
				SELECT				JH.Company, 
									JH.JobNum, 
									CAST(JH.ProdQty AS INT)					AS ProdQty, 
									CAST(JA.AssemblySeq AS INT)				AS AssemblySeq, 
									JH.PartNum,
									P.ClassID,
									CAST (JH.JobEngineered AS BIT)			AS JobEngineered,
									CAST(JH.JobReleased AS BIT)				AS JobReleased, 
									CAST(JH.JobClosed AS BIT)				AS JobClosed, 
									CAST(JA.QtyPer	AS INT)					AS CantidaEnsamble, 
									JA.JobComplete
				FROM				[CORPLAB-EPIDB].[EpicorERP].Erp.JobMtl JM
				RIGHT JOIN			[CORPLAB-EPIDB].[EpicorERP].Erp.JobOpDtl JO
					ON				JM.Company				=		JO.Company 
					AND				JM.JobNum				=		JO.JobNum 
					AND				JM.AssemblySeq			=		JO.AssemblySeq 
					AND				JM.RelatedOperation		=		JO.OprSeq
				RIGHT JOIN			[CORPLAB-EPIDB].[EpicorERP].Erp.JobAsmbl JA
					ON				JA.Company				=		JO.Company 
					AND				JA.JobNum				=		JO.JobNum 
					AND				JA.AssemblySeq			=		JO.AssemblySeq
				RIGHT JOIN			[CORPLAB-EPIDB].[EpicorERP].Erp.JobHead JH
					ON				JH.Company				=		JA.Company 
					AND				JH.JobNum				=		JA.JobNum
				RIGHT JOIN			[CORPLAB-EPIDB].[EpicorERP].Erp.Part P
					ON				JH.Company				=		P.Company 
					AND				JH.Partnum				=		P.Partnum

				WHERE				JH.CreateDate			>=		'2023-06-01' 
					AND				JA.AssemblySeq			=			0 
					AND				JH.JobComplete			<>			1
	) J
				/******************************************************************
								VALIDO CANTIDADES DECLARADAS EN EPICOR
				******************************************************************/
LEFT JOIN	(
				SELECT			JobNum, 
								AssemblySeq, 
								CAST(SUM(LaborQty) AS INT)					AS LaborQty
				FROM			[CORPLAB-EPIDB].[EpicorERP].Erp.LaborDtl
				WHERE			
								ApprovedDate IS NOT NULL
				GROUP BY		JobNum, AssemblySeq
			) LD 
ON			J.JobNum		=		LD.JobNum 
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
							CAST(SUM(TranQty) AS INT)						AS TranQty
				FROM		[CORPLAB-EPIDB].[EpicorERP].Erp.PartTran
				WHERE		
							TranType		=		'MFG-STK'
				GROUP BY	Company, JobNum, Partnum, TranType
			) PT 
ON			J.JobNum		=		PT.JobNum 
AND			J.PartNum		=		PT.Partnum
					/******************************************************************
								VALIDO SERIES ETIQUETADAS EN EL SIG
					******************************************************************/
LEFT JOIN (
				-- Subconsulta para SeriesProducidas
				SELECT		OT, 
							PartNum, 
							COUNT(*) OVER (PARTITION BY OT)		AS SeriesProducidas
				FROM		[SIP].[dbo].[SeriesFabricadas]
				--WHERE		
				--			TimeMaster		>=		'2023-06-01'
			) LB 
ON			J.JobNum		=		LB.OT 
AND			J.PartNum		=		LB.PartNum

----------------------------------------------------------------------------------------------------------------------------------------------
GROUP BY	J.Company, 	J.JobNum, J.ProdQty, J.AssemblySeq, J.PartNum, J.ClassID, J.JobEngineered,	J.JobReleased, J.JobClosed,	J.CantidaEnsamble, J.JobComplete,
			LD.LaborQty,/*LD.ApprovedDate,*/PT.TranQty	, LB.SeriesProducidas
GO


