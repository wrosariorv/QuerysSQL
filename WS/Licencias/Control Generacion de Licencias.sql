alter table RV_TBL_SIP_REPOSITORIO_DATA add CantidadMinima int not null


--ALTER TABLE RV_TBL_SIP_REPOSITORIO_DATA 
--ADD CantidadMinima int NOT NULL DEFAULT 10;

--ALTER TABLE RV_TBL_SIP_LICENCIAS_GENERADAS 
--ADD FechaModificacion datetime NULL ;

--ALTER TABLE RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE 
--ADD GroupID uniqueidentifier NULL ;

select * from RV_TBL_SIP_LICENCIAS_GENERADAS
order by Fecha desc
Select * from RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE

select * from RV_TBL_SIP_REPOSITORIO
where Habilitado=1
SELECT repositorios.Nombre AS Directorio, repositorios.Ruta, repositorios.Habilitado
FROM (
    SELECT directorio
    FROM RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE
    WHERE Estado = 'Pendiente'
    GROUP BY directorio
) AS directorios
JOIN RV_TBL_SIP_REPOSITORIO AS repositorios ON directorios.directorio = repositorios.Nombre
WHERE repositorios.Habilitado = 1
    AND directorios.directorio NOT LIKE 'old_directorio%'
ORDER BY repositorios.Nombre;



select				a.GroupID, a.Directorio, a.CantidadArchivo, A.Estado, a.Fecha, a.FechaModificacion, 
					b.Licencia, b.Estado, b.Fecha as FechaLicencia,b.FechaModificacion as  FechaModificacionLicencia
from				RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE a
inner join			RV_TBL_SIP_LICENCIAS_GENERADAS b
on					a.GroupID		=		b.GroupID
where				
					(
					a.Estado		=		'Pendiente'
			and		b.Estado		=		'Pendiente'
					)
order by			a.Directorio

select * from RV_TBL_SIP_LICENCIAS_GENERADAS
where Estado='Pendiente'
order by Fecha desc

Select * from RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE
Select			W.GroupID,
				W.Tipo,
				SUM(W.CatidadLicencia) AS TotalLicencias
from			(
					select		GroupID,Tipo,Licencia,COUNT(*) OVER (PARTITION BY Licencia)	AS CatidadLicencia
					from		RV_VW_SIP_LICENCIAS_GENERADAS_PENDIENTE
					where
								Tipo ='Attestation\TCL_RT51M'
				) AS W
Group by  W.GroupID, W.Tipo

select * from RV_VW_SIP_LICENCIAS_GENERADAS_PENDIENTE
where
GroupID='8BDD6B68-359A-42B3-9D7C-74C9FE7E5090'	
and Tipo ='Widevine\Global_MT9221'


select * from RV_TBL_SIP_LICENCIAS_GENERADAS
where
ID=7
GroupID='490869BD-46E0-4BF4-903E-0D11AEE0EE00'
and	Tipo='Attestation\TCL_RT51M'

select * from RV_VW_SIP_LICENCIAS_GENERADAS_PENDIENTE
/*
update RV_TBL_SIP_LICENCIAS_GENERADAS
set Estado='Pendiente'
where id between 132 and 192
and Estado= 'Cancelada'

*/

begin tran

UPDATE LG
SET LG.GroupID = RP.GroupID
FROM RV_TBL_SIP_LICENCIAS_GENERADAS LG
INNER JOIN RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE RP
ON LG.Tipo = RP.Directorio AND LG.Estado = 'Cancelada';

rollback tran
commit tran


/*Busca Licencias repetidas*/

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

SELECT Licencia,LEN(Licencia)AS Longitud ,Tipo, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS_bk
GROUP BY Licencia, tipo
HAVING COUNT(*) > 1;

SELECT Licencia, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS_bk
GROUP BY Licencia
HAVING COUNT(*) > 1;

SELECT MIN(ID), Tipo,Licencia, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS_bk
GROUP BY Licencia,Tipo
HAVING COUNT(*) > 1;


SELECT Licencia,Tipo, COUNT(*) AS Cantidad
FROM RV_TBL_SIP_LICENCIAS_GENERADAS

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
	--where Estado='Pendiente'
)
DELETE FROM LicenciasRepetidas
WHERE RowNumber > 1;


DELETE FROM LicenciasRepetidas
WHERE RowNumber > 1;
rollback tran
commit tran

select * from RV_TBL_SIP_LICENCIAS_GENERADAS_bk

where
ID in (
132,
134,
144
)

--ALTER TABLE [dbo].[RV_TBL_SIP_LICENCIAS_GENERADAS]
--ADD CONSTRAINT UQ_Licencia UNIQUE (Licencia);


select * 
from RV_TBL_SIP_REPOSITORIO
where Nombre in (
'MGKKEY\TCL_RT51A_4k',
'widevine\RT51A_Amati'
)

select * 
from RV_TBL_SIP_REPOSITORIO_DATA
where IDRepositorio in (
3,
7,
54
)


---------------

Select * from RV_TBL_SIP_REPOSITORIO
WHERE ruta LIKE '\\Corpmngmds02\software%';

begin tran
update RV_TBL_SIP_REPOSITORIO_DATA
set CantidadMinima =20

where 
		CantidadMinima=10

UPDATE RV_TBL_SIP_REPOSITORIO
SET ruta = REPLACE(ruta, '\\Corpmngmds02\software', 'E:\SOFTWARE')
WHERE ruta LIKE '\\Corpmngmds02\software%';

update RV_TBL_SIP_REPOSITORIO
set Ruta= REPLACE(ruta, 'E:\SOFTWARE\Licencia\Datadir', 'E:\LicenciasTEST\DataDir')
where Ruta like 'E:\SOFTWARE\Licencia\Datadi%'

update RV_TBL_SIP_REPOSITORIO
set Ruta= REPLACE(ruta, 'E:\LicenciasTEST\DataDir', 'E:\SOFTWARE\Licencia\Datadir')
where Ruta like 'E:\LicenciasTEST\DataDir%'

update RV_TBL_SIP_REPOSITORIO
set Habilitado=0
where
 Nombre in (
'MGKKEY\TCL_RT51A_4k',
'widevine\RT51A_Amati'
)
		commit tran
		rollback tran


		----------------------------------
		select * from RV_TBL_SIP_REPOSITORIO

where Nombre in 
(
'Attestation\TCL_MT9221',
'MGKKEY\TCL_RT51A_4K',
'PlayReady\MT9615',
'PlayReady\RT51A_Amati',
'PlayReady\TCL_RT51M',
'Widevine\RT51A_Amati',
'WSTKey\MT9615_PLUS_QDA'
)

begin tran
update RV_TBL_SIP_REPOSITORIO
set Habilitado=1
where
		Habilitado=0
and		id in 
(
5,
40,
56,
57,
58,
68,
72
)

commit tran

rollback tran


select * from RV_TBL_SIP_LICENCIAS_GENERADAS_BK
where tipo='Attestation\TCL_MT9221'

select * from RV_TBL_SIP_LOG_LA
order by ID Desc

select * from RV_TBL_SOLICITA_LICENCIA
order by ID Desc



select * from RV_TBL_SIP_LICENCIAS_GENERADAS
where
			Estado='Pendiente'


--Obtenere Tipos de licencia genertadas y cantidades
select W.Tipo,SUM(W.RowNumber) AS CantidadLicencia
from

				(
					SELECT Tipo, ROW_NUMBER() OVER (PARTITION BY Licencia ORDER BY ID DESC) AS RowNumber 
					FROM RV_TBL_SIP_LICENCIAS_GENERADAS
					WHERE
							Estado='Pendiente'
				) AS W

Group by Tipo


SELECT			B.IDRepositorio,A.Nombre, A.Habilitado,B.[KEY],B.[VALUE]
FROM			RV_TBL_SIP_REPOSITORIO A
INNER JOIN		RV_TBL_SIP_REPOSITORIO_DATA B
ON	A.ID		=		B.IDRepositorio
WHERE			a.Habilitado=1
AND a.Nombre IN ('Attestation\TCL_MT9221','WSTKey\MT9615_PLUS_QDA')

SELECT			a.Nombre, A.Habilitado,B.[KEY],B.[VALUE]
FROM			RV_TBL_SIP_REPOSITORIO A
INNER JOIN		RV_TBL_SIP_REPOSITORIO_DATA B
ON	A.ID		=		B.IDRepositorio
WHERE			a.Habilitado=1
AND [key] IN ('deviceid','tcl_unknown_model')


SELECT	B.Tipo, MIN(B.Licencia)		AS Licencia,LEN(MIN(B.Licencia)) as CantidadSinConvertir , 
w.Nombre ,w.[key],w.[value], CONVERT(VARBINARY(MAX), REPLACE(MIN(B.Licencia), '-', ''), 2) AS ConvertidoBinary ,LEN(CONVERT(VARBINARY(MAX), REPLACE(MIN(B.Licencia), '-', ''), 2)) as CantidadBytes
FROM 
(
		SELECT			a.Nombre, A.Habilitado,B.[KEY],B.[VALUE]
		FROM			RV_TBL_SIP_REPOSITORIO A
		INNER JOIN		RV_TBL_SIP_REPOSITORIO_DATA B
		ON	A.ID		=		B.IDRepositorio
		WHERE			a.Habilitado=1
		--AND [key]		IN ('MAC')
) AS W
INNER JOIN RV_TBL_SIP_LICENCIAS_GENERADAS B
ON	W.NOMBRE		=		B.Tipo
GROUP BY B.Tipo,  w.Nombre, W.Habilitado,W.[KEY],W.[VALUE]


SELECT
				LG.ID,
				LG.Tipo,
				LG.LicenciaAPI,				
				LEN(LG.LicenciaAPI) AS ByteAPI,
				CONVERT(VARBINARY(MAX), REPLACE(LG.LicenciaAPI, '-', ''), 2) AS LicenciaAPI_Hex,
				REPLACE(CONVERT(VARCHAR(MAX), CONVERT(VARBINARY(MAX), REPLACE(LG.LicenciaAPI, '-', '')), 2), '0x', '') AS HexValue,
				LEN(REPLACE(CONVERT(VARCHAR(MAX), CONVERT(VARBINARY(MAX), REPLACE(LG.LicenciaAPI, '-', '')), 2), '0x', '')) AS Bytes,
				LEN(CONVERT(VARBINARY(MAX), REPLACE(LG.LicenciaAPI, '-', ''), 2)) AS BYTECAL,
				LG.Licencia,
				LEN(LG.Licencia) AS BYTEFILE,
				LG.Fecha
FROM
				RV_TBL_SIP_LICENCIAS_GENERADAS LG
INNER JOIN		(
					SELECT
								Tipo,
								MAX(Fecha) AS UltimaFechaModificacion
					FROM
								RV_TBL_SIP_LICENCIAS_GENERADAS
					WHERE
								Estado not IN ('Completado', 'Parcial')
								AND Tipo IN (
												SELECT			Nombre
												FROM			RV_TBL_SIP_REPOSITORIO
												WHERE			Habilitado = 1
												--AND				Nombre IN	(
												--								'DeviceID\tcl_unknown_model',																				
												--								'WSTKey\MT9615_PLUS_QDA',
												--								'Attestation\TCL_MT9221'
												--								--,'Attestation\MT9615_Amati'
												--								--,'PlayReady\MT9221'
												--							)
											)
								AND CAST (Fecha AS date)='2024-04-16'
					GROUP BY	Tipo
				) W
ON	LG.Tipo		=		W.Tipo 
AND LG.Fecha	=		W.UltimaFechaModificacion
ORDER BY     LG.Tipo;

select *
from RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE
where Fecha >'2024-09-19 12:00:00.000'
order by Directorio

select COUNT(Tipo) OVER(PARTITION BY Tipo) AS Cantidad_Tipo,* from RV_TBL_LICENCIAS_DISPONIBLE
where Fecha >'2024-09-19 12:00:00.000'
and Estado='Pendiente'
--and Tipo='LIC_MT15\MGKKEY'

select COUNT(Tipo) OVER(PARTITION BY Tipo) AS Cantidad_Tipo,* from RV_TBL_SIP_LICENCIAS_GENERADAS
where CAST(Fecha as date) ='2024-09-19'
and Estado<>'Completado'

select * from RV_TBL_SIP_LOG_LA
where Fecha >'2024-09-19 12:00:00.000'
order by ID Desc

BEGIN TRAN
UPDATE RV_TBL_LICENCIAS_DISPONIBLE
SET		Estado='Pendiente_old'
where	CAST(Fecha as date) ='2024-09-19'
and Estado='Pendiente'

COMMIT TRAN
rollback tran

select COUNT(Tipo) OVER(PARTITION BY Tipo) AS Cantidad_Tipo,* from RV_TBL_SIP_LICENCIAS_GENERADAS
where CAST(Fecha as date) ='2024-09-19'
and Estado<>'Completado'
and Tipo in ('LIC_MT15\HDCP2.0','LIC_MT15\HDCP')
order by Tipo

--delete from RV_TBL_LICENCIAS_DISPONIBLE
where CAST(Fecha as date) ='2024-09-18'


select * from RV_TBL_SIP_LOG_LA
where CAST(Fecha as date) ='2024-09-19'
order by ID Desc


