USE [Automatica]
GO
select Nombre+',' as Ruta,* from RV_TBL_SIP_REPOSITORIO a
inner join RV_TBL_SIP_REPOSITORIO_DATA b
on a.ID	= b.IDRepositorio
where
	A.Habilitado=1
	and Nombre='LIC_MT15\HDCP2.0'
Nombre like '%MT9615_Amati%'

ALTER TABLE RV_TBL_SIP_REPOSITORIO_DATA ADD [ClientReference] nvarchar (200) not null DEFAULT ''

select		id, GroupID, Tipo 
from		RV_TBL_SIP_LICENCIAS_GENERADAS
where
		Estado ='Completado'
and		Tipo='Attestation\TCL_MT9221'
and		id in (984, 985, 986, 987, 988)

select		id, GroupID, Tipo 
from		RV_TBL_SIP_LICENCIAS_GENERADAS
where
		Estado ='Completado'
and		Tipo='MAC\TCL'
and		id in (1320, 1321, 1322, 1323, 1324)

select * from [dbo].[RV_TBL_LICENCIAS_DISPONIBLE]

select * from [dbo].RV_TBL_SOLICITA_LICENCIA
order by id desc


select * from [dbo].RV_TBL_SIP_LOG_LA
order by id desc

select * from [dbo].[RV_TBL_LICENCIAS_DISPONIBLE]
where estado = 'Pendiente_old'
order by id desc

begin tran
update [dbo].[RV_TBL_LICENCIAS_DISPONIBLE]
set estado='Pendiente_old'
where estado = 'Pendiente'

commit tran

update [dbo].[RV_TBL_LICENCIAS_DISPONIBLE]
set estado='Pendiente',Asignado=0, AsignadoCliente=null,	FechaAsignacion=null
where estado <> 'Pendiente'
and Fecha >'2024-09-19 12:00:00.000'
--and ID in (2150) 


ALTER TABLE RV_TBL_LICENCIAS_DISPONIBLE ADD [RowVersion] rowversion NULL;

select * from RV_TBL_SIP_LICENCIAS_GENERADAS
where Estado NOT IN ''

select * from RV_TBL_SIP_LICENCIAS_REPOSITORIO_PENDIENTE

select * from 