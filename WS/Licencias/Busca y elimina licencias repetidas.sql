USE [Automatica]
GO

/*

ALTER VIEW	[dbo].[RV_VW_SIP_LICENCIAS_GENERADAS_PENDIENTE]
AS

--*/
/*
SELECT				
			A.ID,
			A.GroupID,
			A.Tipo,
			A.Licencia,
			C.[Key],
			C.[Value],
			A.Estado,
			A.Fecha

FROM		RV_TBL_SIP_LICENCIAS_GENERADAS	A

left JOIN  (
				SELECT		A.Nombre, 
							A.Ruta, 
							B.[Key], 
							B.[Value],
							A.Habilitado

				FROM		RV_TBL_SIP_REPOSITORIO A
				INNER JOIN	RV_TBL_SIP_REPOSITORIO_DATA B
				ON			A.ID			=		B.IDRepositorio
				WHERE 
							A.Habilitado	=		1

			) aS c
ON			A.Tipo			=			C.Nombre

WHERE		
			Estado ='Pendiente'
*/


SELECT				B.ID, A.GroupID, B.Tipo, A.CantidadArchivo,B.Licencia, C.[key], C.[Value], B.Estado, A.Fecha 
FROM				RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE A
LEFT JOIN			RV_TBL_SIP_LICENCIAS_GENERADAS B
ON					A.GroupID		=		B.GroupID
LEFT JOIN			(
						SELECT		A.Nombre, 
									A.Ruta, 
									B.[Key], 
									B.[Value]

						FROM		RV_TBL_SIP_REPOSITORIO A
						INNER JOIN	RV_TBL_SIP_REPOSITORIO_DATA B
						ON			A.ID			=		B.IDRepositorio
						WHERE 
									A.Habilitado	=		1

					)									aS C
ON					A.Directorio			=			C.Nombre			

WHERE				
					(
					A.Estado		=		'Pendiente'
			AND		B.Estado		=		'Pendiente'
					)
--ORDER BY			A.Directorio



GO


select *  FROM				RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE A
where
GroupID	='9C64EC96-0BD7-4AB8-84C3-500BDC1C1AF6'	
and Directorio='Attestation\MT9615_Amati'

select *  FROM				RV_TBL_SIP_LICENCIAS_GENERADAS 
where
GroupID	='9C64EC96-0BD7-4AB8-84C3-500BDC1C1AF6'	
and Tipo='Attestation\MT9615_Amati'

select *  FROM				RV_TBL_SIP_LICENCIAS_GENERADAS_bk
where
GroupID	='9C64EC96-0BD7-4AB8-84C3-500BDC1C1AF6'	
and Tipo='Attestation\MT9615_Amati'

SELECT Licencia,Tipo, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS_bk
GROUP BY Licencia, tipo
HAVING COUNT(*) > 1;

SELECT Licencia, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS_bk
GROUP BY Licencia
HAVING COUNT(*) > 1;

SELECT MIN(ID),Licencia, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS_bk
GROUP BY Licencia
HAVING COUNT(*) > 1;


SELECT Licencia,Tipo, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS
where Estado='Pendiente'
GROUP BY Licencia, tipo
HAVING COUNT(*) > 1;

SELECT Licencia, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS
where Estado='Pendiente'
GROUP BY Licencia
HAVING COUNT(*) > 1;

begin tran 
WITH LicenciasRepetidas AS (
    SELECT Licencia, ROW_NUMBER() OVER (PARTITION BY Licencia ORDER BY ID) AS RowNumber
    FROM RV_TBL_SIP_LICENCIAS_GENERADAS
)

WITH LicenciasRepetidas AS (
    SELECT Licencia, ROW_NUMBER() OVER (PARTITION BY Licencia ORDER BY ID DESC) AS RowNumber
    FROM RV_TBL_SIP_LICENCIAS_GENERADAS
	where Estado='Pendiente'
)
DELETE FROM LicenciasRepetidas
WHERE RowNumber > 1;


DELETE FROM LicenciasRepetidas
WHERE RowNumber > 1;
rollback tran
commit tran

select * from RV_TBL_SIP_LICENCIAS_GENERADAS
where
ID in (
193,
179,
189
)