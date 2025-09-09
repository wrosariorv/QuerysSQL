--Notificaciones

select * from [CORPSQLMULT01].[Multivende].[DBO].[RVF_TBL_API_ESTADO_PEDIDOS_MULTIVENDE]	
where
NumeroOC='255981783'
--Envio de documento

select * from [CORPSQLMULT01].[Multivende].[DBO].[RVF_TBL_API_ENVIO_DOCUMENTOS_MULTIVENDE]
where type='electronic_billing_not_taxed_electronic_invoice'
and FechaInformado is not NULL