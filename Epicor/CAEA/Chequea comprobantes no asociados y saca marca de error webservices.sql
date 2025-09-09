
--------------------------
--chequear compobrobantes 
---------------------------
Select * from Comprobantes
where
numeroComprobante in ('907','908','909','911','912')

and numeroPuntoVenta='233'
and codigoTipoComprobante='3'

select * from arrayComprobantesAsociados
where numeroComprobante in ('1292','38517','40751','3809','6372')

and numeroPuntoVenta='159'
and codigoTipoComprobante='1'

Select * from Comprobantes
where
resultado = 'R'

SELECT resultado FROM Comprobantes
group by resultado
--------------------------
--Saca marca de error del comproboante
---------------------------
begin tran 
update Comprobantes
set resultado= Null, CAEAAsignado= Null, FechaProceso= Null, ResultadoObservaciones= Null, ResultadoErrores= Null
where
numeroComprobante in ('907')

and numeroPuntoVenta='233'
and codigoTipoComprobante='3'



--commit tran
rollback tran