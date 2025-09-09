GroupList	CompList
SYS-AN-ADM	CO01~CO02~CO03


2021-07-15

select GroupList,CompList,* from Erp.UserFile
WHERE DCDUserID='WROSARIO'

select* from Erp.UserFile_ud



DECLARE @today DATETIME = SYSDATETIME()

SELECT						A.DCDUserID,
							A.Name,
							CASE
									WHEN
									A.UserDisabled=0	THEN	'Habilitado'
									Else						'Deshabilitado'
							END									AS Estado,
							'SIN VENCIMIENTO'					AS PExpiration,	--No hay fecha de vencimiento por grupo
							B.SecGroupDesc						AS Pgroups,
							isnull(A.LastDate,'')				AS LastDate



FROM						Erp.UserFile	A
INNER JOIN					ICE.SecGroup	b
on							a.GroupList		=		B.SecGroupCode

ORDER by 1


--Detalle del grupo
SELECT * FROM ICE.SecGroup
WHERE
SecGroupCode='SYS-AN-ADM'

--Usuario vs Grupo
select * from Erp.UserFile
where GroupList like '%SYS-AN-ADM%'
--Grupo vs objeto del menu vs seguridad
select * from ice.Security
where EntryList like '%SYS-AN-ADM%'
--Segurida vs Menu
select * from ice.Menu
where SecCode like '%SYS-AN-ADM%'
