select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where TipoCaso='SO'
AND id_caso=26598

select nota_credito_debito,NC_INTERNO,id_estado,* from dbo.casos
where id=26598


 

begin tran

update dbo.casos
set nota_credito_debito='NC-A-0257-00001256',NC_INTERNO=496958,id_estado=12
where id=26598

commit tran