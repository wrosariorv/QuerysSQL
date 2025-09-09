EXEC [CORPSQLMULT2019].[WSAFIP].dbo.RVF_PRC_Ejecutar_CAEA

select * from [CORPSQLMULT2019].WSAFIP.dbo.CAEA_Control 
/* Prueba RV*/
select * from [CORPSQLMULT2019].WSAFIP.dbo.Comprobantes								where (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(288)) or (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(289))
select * from [CORPSQLMULT2019].WSAFIP.dbo.arrayItems								where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP.dbo.arraySubtotalesIVA						where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP.dbo.arrayOtrosTributos						where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP.dbo.arrayComprobantesAsociados				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))

SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.COMPROBANTES
SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arrayItems
SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arrayOtrosTributos
SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arraySubtotalesIVA
SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arrayComprobantesAsociados

/* Prueba SO*/
select * from [CORPSQLMULT2019].WSAFIP_SONTEC.dbo.Comprobantes						where (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(288)) or (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(289))
select * from [CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arrayItems						where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arraySubtotalesIVA				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arrayOtrosTributos				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arrayComprobantesAsociados		where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))

SELECT * FROM [CORPSQLMULT2019].B_SONTEC.dbo.COMPROBANTES
SELECT * FROM [CORPSQLMULT2019].B_SONTEC.dbo.arrayItems
SELECT * FROM [CORPSQLMULT2019].B_SONTEC.dbo.arrayOtrosTributos
SELECT * FROM [CORPSQLMULT2019].B_SONTEC.dbo.arraySubtotalesIVA
SELECT * FROM [CORPSQLMULT2019].B_SONTEC.dbo.arrayComprobantesAsociados

/* Prueba ME*/
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.Comprobantes						where (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(288)) or (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(289))
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayItems						where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arraySubtotalesIVA				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayOtrosTributos				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayComprobantesAsociados		where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))

SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.COMPROBANTES
SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arrayItems
SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arrayOtrosTributos
SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arraySubtotalesIVA
SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arrayComprobantesAsociados

EXEC [CORPSQLMULT2019].B_SONTEC.dbo.IMPORTARTXTCAEA;    
		SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.COMPROBANTES
		SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arrayItems
		SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arrayOtrosTributos
		SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arraySubtotalesIVA
		SELECT * FROM [CORPSQLMULT2019].AS400_WSAFIP.dbo.arrayComprobantesAsociados

		SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.COMPROBANTES
		SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arrayItems
		SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arrayOtrosTributos
		SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arraySubtotalesIVA
		SELECT * FROM [CORPSQLMULT2019].B_MEGASAT.dbo.arrayComprobantesAsociados

EXEC [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.[TraerDatosAS]

EXEC [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.TRAERDATOSAS; 


		select * from [CORPSQLMULT2019].WSAFIP.dbo.CAEA_Control

select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.Comprobantes where codigoTipoComprobante	=1 and numeroPuntoVenta=35 and 	numeroComprobante in(288,289)
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayItems where refTC	=1 and refPV=35 and 	refNum in(288,289)
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arraySubtotalesIVA where refTC	=1 and refPV=35 and 	refNum in(288,289)
select * from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayOtrosTributos where refTC	=1 and refPV=35 and 	refNum in(288,289)



begin tran
/* Prueba ME*/
delete from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.Comprobantes where (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(288)) or (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(289))
delete from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayItems where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arraySubtotalesIVA where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayOtrosTributos where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from [CORPSQLMULT2019].WSAFIP_MEGASAT.dbo.arrayComprobantesAsociados where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))

/* Prueba SO*/
delete from	[CORPSQLMULT2019].WSAFIP_SONTEC.dbo.Comprobantes						where (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(288)) or (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(289))
delete from	[CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arrayItems						where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from	[CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arraySubtotalesIVA				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from	[CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arrayOtrosTributos				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from	[CORPSQLMULT2019].WSAFIP_SONTEC.dbo.arrayComprobantesAsociados		where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))

/* Prueba RV*/
delete from	[CORPSQLMULT2019].WSAFIP.dbo.Comprobantes								where (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(288)) or (codigoTipoComprobante	in (1) and numeroPuntoVenta=35 and 	numeroComprobante in(289))
delete from	[CORPSQLMULT2019].WSAFIP.dbo.arrayItems								where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from	[CORPSQLMULT2019].WSAFIP.dbo.arraySubtotalesIVA						where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from	[CORPSQLMULT2019].WSAFIP.dbo.arrayOtrosTributos						where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))
delete from	[CORPSQLMULT2019].WSAFIP.dbo.arrayComprobantesAsociados				where (refTC	=1 and refPV=35 and 	refNum in(288)) or (refTC	=1 and refPV=35 and 	refNum in(289))




 TRUNCATE TABLE AS400_WSAFIP.dbo.COMPROBANTES
 TRUNCATE TABLE AS400_WSAFIP.dbo.arrayItems
 TRUNCATE TABLE AS400_WSAFIP.dbo.arrayOtrosTributos
 TRUNCATE TABLE AS400_WSAFIP.dbo.arraySubtotalesIVA
 TRUNCATE TABLE AS400_WSAFIP.dbo.arrayComprobantesAsociados

 TRUNCATE TABLE B_SONTEC.dbo.COMPROBANTES
 TRUNCATE TABLE B_SONTEC.dbo.arrayItems
 TRUNCATE TABLE B_SONTEC.dbo.arrayOtrosTributos
 TRUNCATE TABLE B_SONTEC.dbo.arraySubtotalesIVA
 TRUNCATE TABLE B_SONTEC.dbo.arrayComprobantesAsociados

 TRUNCATE TABLE B_MEGASAT.dbo.COMPROBANTES
 TRUNCATE TABLE B_MEGASAT.dbo.arrayItems
 TRUNCATE TABLE B_MEGASAT.dbo.arrayOtrosTributos
 TRUNCATE TABLE B_MEGASAT.dbo.arraySubtotalesIVA
 TRUNCATE TABLE B_MEGASAT.dbo.arrayComprobantesAsociados

commit tran
rollback tran