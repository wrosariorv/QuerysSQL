select IdUsuario,* from Ordenes  
where
ORderNum=296877
and OrderLine =1 
and OrderRelNum =1

begin tran

UPDATE Ordenes
set FechaFin = null, IdUsuario=null, FechaDespacho=null,Archivo=null
where
ORderNum=296877
and OrderLine =1 
and OrderRelNum =1
commit tran

rollback tran

CO01-CDEE-296877-1-1