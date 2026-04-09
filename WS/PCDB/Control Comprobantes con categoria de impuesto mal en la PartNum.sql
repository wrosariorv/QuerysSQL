select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where --Estado <>'Integrado'


TranNum in (
3453,
3458,
3469
)

select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where --Estado <>'Integrado'


TranNum in (
3453,
3458,
3469
)

select * delete from RV.RV_TBL_SIP_TAXES
where --Estado <>'Integrado'


TranNum in (
3453,
3458,
3469
)

'SELL OUT $ TCL TAB'

begin tran 

select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where TranNum between 4339 and 4348

select * from RV.RV_TBL_SIP_TAXES
where TranNum between 4339 and 4348

update RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
set FechaModificacion = null,
Estado='Pendiente',
InvoiceNum = null,
GroupoAsignado = null,
Eliminado = null
where /*FechaModificacion is not null
and  Estado <> 'Pendiente'
and */TranNum between 4339 and 4348

in  (
3453,
3458,
3469
)

update RV.RV_TBL_SIP_DETALLE_COMPROBANTE
set FechaModificacion = null,
Estado='Pendiente',
Eliminado = null
where FechaModificacion is not null
and  Estado <> 'Pendiente'
--AND TranNum < 17
and TranNum between 4339 and 4348

TranNum in  (
3453,
3458,
3469
)
Rollback tran

commit tran


			SELECT					DT.*
						FROM					[CORPE11-EPIDB].[EpicorERP].dbo.InvcHead HD
						LEFT JOIN				[CORPE11-EPIDB].[EpicorERP].dbo.InvcDtl DT 
						ON						HD.Company		=		DT.Company				COLLATE Modern_Spanish_CI_AS
						AND						HD.InvoiceNum	=		DT.InvoiceNum			--COLLATE Modern_Spanish_CI_AS
						INNER JOIN				RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE	PCH
						ON						PCH.Company		=			HD.Company			COLLATE Modern_Spanish_CI_AS
						AND						PCH.InvoiceNum		=			HD.InvoiceNum	--COLLATE Modern_Spanish_CI_AS
						INNER JOIN				[CORPE11-EPIDB].[EpicorERP].dbo.PartNum	P
						ON						P.Company		=			
