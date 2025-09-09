USE [Automatica]
GO

/*
ALTER PROCEDURE [dbo].[RV_PRC_SIP_ACTUALIZA_ESTADO_REPOSITORIO_LICENCIA]		

AS
--*/

/**********************************************************
	BUSCA REPOSITORIOS QUE NO GENERARON LICENCIA
**********************************************************/

SELECT		
			CAST(A.ID AS NVARCHAR(MAX)) AS ID,A.GroupID, A.Directorio, ISNULL(B.Licencia,0) AS CantidadLicencia ,a.CantidadArchivo, 
			
			ISNULL(B.Estado,'Cancelado') AS Estado
			--, a.* ,b.*
			

FROM		RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE	A

LEFT JOIN	RV_TBL_SIP_LICENCIAS_GENERADAS		B

ON			A.GroupID		=		B.GroupID

where				B.GroupID		is null
AND			(
					A.Estado		=		'Pendiente'
			and		A.Estado		=		'Pendiente'
			)

---------
UNION ALL
---------

/**********************************************************
		BUSCA REPOSITORIOS QUE GENERARON LICENCIA
**********************************************************/

SELECT		Y.ID, Y.GroupID,Y.Directorio,Y.CantidadLicencia,Y.CantidadArchivo,
			CASE
					WHEN	(
								Y.CantidadLicencia < Y.CantidadArchivo
							--OR
							--	Y.CantidadLicencia = Y.CantidadArchivo
							)
					THEN	'Parcial'
					--WHEN	(
					--			Y.CantidadLicencia = Y.CantidadArchivo
					--		 OR
					--			Y.CantidadLicencia > Y.CantidadArchivo
					--		)
					--THEN	'Completado'
					ELSE	'Completado'
			END							AS Estado

FROM		(


				SELECT		
							STRING_AGG(CAST(W.ID AS NVARCHAR(MAX)), '~') AS ID, W.GroupID, w.Directorio, SUM(CantidadLicencia) AS CantidadLicencia, w.CantidadArchivo,		
							w.Estado

				FROM		(
								SELECT		DISTINCT
											b.ID, b.GroupID, A.Directorio, b.Licencia, COUNT(*) OVER (PARTITION BY B.Licencia)	AS CantidadLicencia,
											a.CantidadArchivo, B.Estado

			

								FROM		RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE	A

								INNER JOIN	RV_TBL_SIP_LICENCIAS_GENERADAS		B

								ON			A.GroupID		=		B.GroupID

								where		(
													A.Estado		=		'Pendiente'
											and		A.Estado		=		'Pendiente'
											)
								order by 3
								--AND			A.GroupID					=		'490869BD-46E0-4BF4-903E-0D11AEE0EE00'
							)	AS W

				GROUP BY	W.GroupID, w.Directorio, w.CantidadArchivo, w.Estado			
				--ORDER BY	w.Directorio
			) AS Y


GO

select * from RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE	A
where  GroupID='A95C465A-4206-4D5E-A554-FC6E5879863E'
select * from RV_TBL_SIP_LICENCIAS_GENERADAS		B
where Estado='Pendiente'
Tipo='DeviceID\tcl_unknown_model'
