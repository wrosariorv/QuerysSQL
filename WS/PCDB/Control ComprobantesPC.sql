select * from RV.RV_TBL_SIP_LOG_PC
order by Fecha desc

select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where
        TranNum not in (select TranNum from RV.RV_TBL_SIP_DETALLE_COMPROBANTE)
TranNum=3335

--Update RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
--set Estado='ErrorLinea'
--where
--TranNum=3335
--Estado='Pendiente'
TranNum>3323

select LEN(Comentario) AS CanitdadComentario,* from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where
TranNum>3323

select * from RV.RV_TBL_SIP_TAXES
where
TranNum>3323
		TranNum in (3305,
3306,
3307,
3308,
3309)
order by TranNum

select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where
		TranNum in (3305,
3306,
3307,
3308,
3309)
order by TranNum



select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where
		/*Estado<>'Integrado'
		and*/ TranNum=3335
order by TranNum

select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where
		
		/*Estado<>'Integrado'
		and*/ TranNum=3335
order by TranNum

SELECT				'SO' AS Tabla, ID AS id_caso, id_estado , nota_credito_debito, NC_INTERNO
FROM				[dbo].[casos]
WHERE				ID		in		(23173)

select * from [RV].[RV_TBL_SIP_JOB_ACTUALIZA_ESTADO_PC]
where TranNum=3335

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
where /*FechaModificacion is not null
and  Estado <> 'Pendiente'
and */TranNum in (3335)

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

