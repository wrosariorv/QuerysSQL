DECLARE
			@JobNum		VARCHAR(100)		=			'RV948005',--'RV295001',--'RV213030'-- Sin declarara'RV000014'
			@Declarado	bit					=			0

Select			J.Company, 
				J.JobNum,
				J.ProdQty										AS	CantidadOT,
				J.AssemblySeq									AS	SecuenciaEnsamble, 
				J.PartNum,
				J.JobEngineered									AS	IngAprobado,
				J.JobReleased									AS	Liberado,
				J.JobClosed										AS	EstadoOT,

				J.CantidaEnsamble, 
				J.JobComplete,
				LB.NumeroFilas								AS	FilasEtiquedtadas,
				ISNULL(LD.LaborQty,0)									AS  CantidadDeclarada,
				--LD.ApprovedDate								AS	FechaDeclaracion,
				ISNULL(PT.TranQty,0)									AS	CantidaTransferida,						
				CASE
						--VALIDA SI LA OT ESTA ABIERTA
						WHEN	J.JobClosed		<>		0
						THEN	0
						--VALIDA QUE ESTE APROBADO POR ING
						WHEN	J.JobEngineered	<>		1
						THEN	0
						--VALIDA QUE LAOT ESTE LIBERADA
						WHEN	J.JobReleased	<>		1
						THEN	0
						----VALIDA QUE LA CANTIDAD DECLARADA SEA LA MISMA QUE LA CANTIDAD DE SERIES ETIQUETADAS
						--WHEN	LD.LaborQty		<>		LB.NumeroFilas
						--THEN	0					
						----VALIDA QUE LA CANTIDAD DE LA OT SEA LA MISMA QUE LA CANTIDAD DE SERIES ETIQUETADAS
						--WHEN	J.ProdQty		<>		LB.NumeroFilas
						--THEN	0

						ELSE	1
					
				END						AS Estado,
				GETDATE()				AS Fecha

				--, LB.*
FROM
								
								(
									/******************************************************************
										OBTEGO INF. DE ENSAMBLE, MATERIALES Y CABEZERA DE OT
									******************************************************************/
									SELECT				JH.Company, 
														JH.JobNum,
														JH.ProdQty,
														JA.AssemblySeq, 
														JH.PartNum,
														JH.JobEngineered,
														JH.JobReleased,
														JH.JobClosed,

														JA.QtyPer								AS	CantidaEnsamble, 
														JA.JobComplete,

														JM.RelatedOperation, 
														JM.MtlSeq								AS	SecuenciaMateriales, 
														JM.PartNum								AS	ParteMaterial, 
														JM.QtyPer								AS	Cant, 
														JM.RequiredQty, 
														JM.IssuedQty,
														JM.IssuedComplete						AS	EmisioMaterial
													
														--,LB.*
										
									FROM				[CORPEPIDB].EpicorERP.Erp.JobMtl				JM			WITH (NoLock)
		
									---------------------------------------------------------------------------------------------------------------

									RIGHT  JOIN	[CORPEPIDB].EpicorERP.Erp.JobOpDtl				JO			WITH (NoLock)				
										ON				JM.Company					=			JO.Company
										AND				JM.JobNum					=			JO.JobNum
										AND				JM.AssemblySeq				=			JO.AssemblySeq
										AND				JM.RelatedOperation			=			JO.OprSeq
						
									---------------------------------------------------------------------------------------------------------------

									RIGHT  JOIN	[CORPEPIDB].EpicorERP.Erp.JobAsmbl				JA			WITH (NoLock)
										ON				JA.Company					=			JO.Company
										AND				JA.JobNum					=			JO.JobNum
										AND				JA.AssemblySeq				=			JO.AssemblySeq
						
									---------------------------------------------------------------------------------------------------------------

									RIGHT  JOIN	[CORPEPIDB].EpicorERP.Erp.JobHead				JH			WITH (NoLock)
										ON				JH.Company					=			JA.Company
										AND				JH.JobNum					=			JA.JobNum

									---------------------------------------------------------------------------------------------------------------

									WHERE				JH.JobNum			=		@JobNum
										--AND				JA.AssemblySeq		=		0
									---------------------------------------------------------------------------------------------------------------
								) AS J
-----------------------------------------------------------------------------------------------------------------------------------------------
/******************************************************************
				VALIDO CANTIDADES DECLARADAS
******************************************************************/
LEFT  JOIN		(
					SELECT		JobNum,
								AssemblySeq,
								SUM(LaborQty)		AS LaborQty
								--,ApprovedDate
								--,LD.Complete
						
					FROM		[CORPEPIDB].EpicorERP.Erp.LaborDtl			WITH (NoLock)
					WHERE		jobnum		 =			@JobNum
					AND			ApprovedDate	is not null
					GROUP BY	JobNum,AssemblySeq--,ApprovedDate
					--HAVING		MAX(CAST(Complete AS int)) = 0
				)	LD
	ON				J.JobNum					=			LD.JobNum
	AND				J.AssemblySeq				=			LD.AssemblySeq
----------------------------------------------------------------------------------------------------------------------------------------------
/******************************************************************
			VALIDO SERIES ETIQUETADAS EN EL SIG
******************************************************************/					
LEFT  JOIN		(
					SELECT			*,
									COUNT(*) OVER() AS NumeroFilas 
					FROM 			[PLANSQLMULT01].[SIP].[dbo].[Labels]					WITH (NoLock)
					WHERE			OT			=			@JobNum
					--Consultar a Fede 'RV295001'
					AND				TimeMaster	IS NOT NULL

				) AS LB
	ON				J.JobNum					=			LB.OT
	AND				J.PartNum					=			LB.ModeloRV
----------------------------------------------------------------------------------------------------------------------------------------------
LEFT  JOIN		(
						SELECT		Company,JobNum,Partnum,TranType
									,SUM(TranQty)AS TranQty
						FROM		[CORPEPIDB].EpicorERP.Erp.PartTran
						WHERE		JobNum		=			@JobNum
						AND			TranType	=			'MFG-STK'
						GROUP BY	Company,JobNum,Partnum,TranType
				)	AS PT
	ON				J.JobNum					=			PT.JobNum
	AND				J.PartNum					=			PT.Partnum
----------------------------------------------------------------------------------------------------------------------------------------------
WHERE
		J.AssemblySeq			=			0
----------------------------------------------------------------------------------------------------------------------------------------------
GROUP BY	J.Company, 	J.JobNum, J.ProdQty, J.AssemblySeq, J.PartNum, J.JobEngineered,	J.JobReleased, J.JobClosed,	J.CantidaEnsamble, J.JobComplete,
			LD.LaborQty,/*LD.ApprovedDate,*/PT.TranQty	, LB.NumeroFilas	
----------------------------------------------------------------------------------------------------------------------------------------------


select		
			JobNum,
			AssemblySeq,
			LaborQty,
			Complete,
			*
FROM		[CORPEPIDB].EpicorERP.Erp.LaborDtl			WITH (NoLock)
WHERE		jobnum			=			@jobnum
AND			ApprovedDate	is not null


SELECT		JobNum,
			AssemblySeq,
			SUM(LaborQty)		AS LaborQty,
			ApprovedDate
			--,LD.Complete
						
FROM		[CORPEPIDB].EpicorERP.Erp.LaborDtl			WITH (NoLock)
WHERE		jobnum			=			@JobNum
AND			ApprovedDate	is not null
GROUP BY	JobNum,AssemblySeq,ApprovedDate
HAVING		MAX(CAST(Complete AS int)) = 1