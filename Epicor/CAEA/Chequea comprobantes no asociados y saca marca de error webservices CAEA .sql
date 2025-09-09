
--------------------------
--chequear compobrobantes 
---------------------------
Select * from Comprobantes
where
numeroComprobante in ('818')

and numeroPuntoVenta='239'
and codigoTipoComprobante='3'

select * from arrayComprobantesAsociados
where numeroComprobante in ('818')

and numeroPuntoVenta='239'
and codigoTipoComprobante='3'

Select * from Comprobantes
where
resultado = 'R'
AND numeroComprobante in ('63','1089')

and numeroPuntoVenta in ('233','237')
and codigoTipoComprobante ='3'


SELECT resultado FROM Comprobantes
group by resultado
--------------------------
--Saca marca de error del comproboante
---------------------------
begin tran 
update Comprobantes
set resultado= Null, CAEAAsignado= Null, FechaProceso= Null, ResultadoObservaciones= Null, ResultadoErrores= Null
where
resultado = 'R'

resultado = 'R' AND
 numeroComprobante in ('870','1089')

and numeroPuntoVenta in ('239','237')
and codigoTipoComprobante ='3'



--commit tran
rollback tran

--------------------------
--chequear compobrobantes a informar
---------------------------
Select codigoTipoDocumento,numeroDocumento,* from Comprobantes
where
codigoTipoDocumento=86
27180747341
20402928728

23127590079
Select * from Comprobantes
where
numeroComprobante in ('41')
and numeroPuntoVenta='231'
and codigoTipoComprobante='8'
or
numeroComprobante in ('539')
and numeroPuntoVenta='231'
and codigoTipoComprobante='6'
or
numeroComprobante in ('1544')
and numeroPuntoVenta='233'
and codigoTipoComprobante='6'
/*
or
numeroComprobante in ('115')
and numeroPuntoVenta='245'
and codigoTipoComprobante='6'
*/
select * from arrayComprobantesAsociados
where 
-------
--Informacio Comprobante ORIGINAL 
-------
refNum ='14'
and refPV='245'
and refTC='8'
OR
refNum ='15'
and refPV='245'
and refTC='8'
OR
refNum ='16'
and refPV='245'
and refTC='8'
--FC-A-0178-00002290
-----------------
--Informacion Comprobantes viculado Epicor 
-----------------
AND numeroComprobante in ('2290')
and numeroPuntoVenta='178'
and codigoTipoComprobante='1'

select * from arrayComprobantesAsociados
where 
-------
--Informacio Comprobante ORIGINAL 
-------
refNum ='1089'
and refPV='233'
and refTC='3'
--FC-A-0233-00010079
-----------------
--Informacion Comprobantes viculado Epicor 
-----------------
AND numeroComprobante in ('10079')
and numeroPuntoVenta='233'
and codigoTipoComprobante='1'
-------------------------------
--Busca Documento Asociado 
-------------------------------

Select * from Comprobantes
where
numeroComprobante in ('41')
and numeroPuntoVenta='231'
and codigoTipoComprobante='8'
or
numeroComprobante in ('539')
and numeroPuntoVenta='231'
and codigoTipoComprobante='6'

Select					legalnumber, IU.ShortChar10, IU.ShortChar09,* 
from					[CORPEPIDB].EpicorERP.ERP.Invchead			I
INNER JOIN				[CORPEPIDB].EpicorERP.ERP.Invchead_ud		IU
	ON					I.SysRowID		=		IU.ForeignSysRowID
where					--legalnumber like '%0231%'
						legalnumber IN ('NC-B-0231-00000031', 'FC-B-0231-00000539')

Select					legalnumber, IU.ShortChar10, IU.ShortChar09,* 
from					[CORPEPIDB].EpicorERP.ERP.Invchead			I
INNER JOIN				[CORPEPIDB].EpicorERP.ERP.Invchead_ud		IU
	ON					I.SysRowID		=		IU.ForeignSysRowID
where					legalnumber IN ('FC-B-0246-00000623','FC-B-0246-00000624','FC-B-0246-00000625')

select top 10 ShortChar10,ShortChar09,* from [CORPEPIDB].EpicorERP.ERP.Invchead_ud
where ForeignSysRowID in  ('6ABC6AB5-6414-4B4E-9D21-9B50DC2E6D8E','41AFB060-E616-4FFB-85E5-C95A04B0731F','DE4606DA-0B76-48F2-8F3F-50D42101D0DB')

Select legalnumber,SysRevID,SysRowID,* from [CORPEPIDB].EpicorERP.ERP.Invchead
where  legalnumber in  ('NC-B-0245-00000014','NC-B-0245-00000015','NC-B-0245-00000016')
--legalnumber LIKE 'ND-A-0241_00000117'
select top 10 ShortChar10,ShortChar09,* from [CORPEPIDB].EpicorERP.ERP.Invchead_ud
where ForeignSysRowID in ( '4A19ACB8-DC98-4D8B-92DA-99387F9B0A11','3CA5F853-00B7-48E6-B72C-7F29AA9E80A6','12121093-7FD1-451C-BEAB-A2E5C6ED4CF9')


numeroDocumento
13480800

ShortChar09
13480800

Remplazados:
13614015
20402928728
-------------------------------
--Verifica comprobantes asociados vs COMPROBANTES
-------------------------------
SELECT * FROM [AS400_WSAFIP].DBO.arrayComprobantesAsociados WHERE NROCBT NOT IN (select numeroComprobante from [WSAFIP].dbo.Comprobantes where CONVERT( DATE ,fechaEmision) >= '2021/06/15' and CONVERT( DATE ,fechaEmision)<= '2021/06/30')

select * from [WSAFIP].dbo.Comprobantes where CONVERT( DATE ,fechaEmision) >= '2021/06/15' and CONVERT( DATE ,fechaEmision)<= '2021/06/30' AND numeroComprobante NOT IN (SELECT NROCBT FROM [AS400_WSAFIP].DBO.arrayComprobantesAsociados)

-------------------------------
--Verifica comprobantes que no poseen ITEM
-------------------------------

SELECT TOP 100 *
FROM Comprobantes
WHERE (
codigoTipoComprobante = 2
AND numeroPuntoVenta = 241
AND numeroComprobante = 116
)
OR (
codigoTipoComprobante = 3
AND numeroPuntoVenta = 239
AND numeroComprobante = 916
)


SELECT TOP 100 *
FROM ArrayItems
WHERE (
RefTC = 2
AND RefPV = 241
AND RefNum = 116
)
OR (
refTC = 1
AND RefPV = 184
AND refNum = 27150
)
OR (
refTC = 3
AND RefPV = 239
AND RefNum = 916
)