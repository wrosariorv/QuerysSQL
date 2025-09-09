
select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where
		TranNum in (683)
order by TranNum

select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where
		TranNum in (683)
order by TranNum



select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where
		Estado<>'Integrado'
		and TranNum>1701
order by TranNum

select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where
		
		Estado<>'Integrado'
		and TranNum>1701
order by TranNum


update RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
set 
select * from rv.RV_TBL_SIP_LOG_PC
where TranNum in (1702,1769)

SELECT DISTINCT
    E.Company,
    E.Tipo,
    E.TranNum,
	D.Linea,
	D.PartNum,
    E.GroupID,
    E.SoldToCustID,
    E.InvoiceDate,
    E.InvoiceRef,
    E.InvRefLegNum,
    E.TermsCode,
    E.Comentario,
    E.Fecha,
	D.Estado AS 'EstadoLinea',
    E.Estado,
    E.FechaModificacion,
    E.Eliminado,
    E.InvoiceNum,
    E.GroupoAsignado
FROM
    RV.RV_TBL_SIP_DETALLE_COMPROBANTE D
JOIN
    RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE E
    ON D.Company = E.Company AND D.TranNum = E.TranNum
WHERE
    D.Estado = 'Error en la linea'
    AND E.Estado = 'Integrado'

	

select * from RV.RV_TBL_SIP_LOG_PC
where descripcion like '%[%'
or descripcion like '%]%'

select * from RV.RV_TBL_SIP_LOG_PC
where Codigo like '%BC008%'

select * from RV.RV_TBL_SIP_LOG_MENSAJE
where Detalle like '%tableName%'

alter table RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE add GroupoAsignado nvarchar(50) null
begin tran 

update RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
set FechaModificacion = null,
Estado='Pendiente',
InvoiceNum = null,
GroupoAsignado = null,
Eliminado = null
where FechaModificacion is not null
and  Estado <> 'Pendiente'
--and TranNum in (4,15)

update RV.RV_TBL_SIP_DETALLE_COMPROBANTE
set FechaModificacion = null,
Estado='Pendiente',
Eliminado = null
where FechaModificacion is not null
and  Estado <> 'Pendiente'
--AND TranNum < 17
--and TranNum in (4,15)
Rollback tran

commit tran

