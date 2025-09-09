USE [WSAFIP]
GO
/*
ALTER PROCEDURE [dbo].[RVF_PRC_Ejecutar_CAEA]
AS
--*/
  
----------------------------------------------------  

BEGIN    
    
DECLARE  @EnUso VARCHAR(5)    
    
SELECT  @EnUso  =  EnUso    
FROM  CAEA_Control    
    
IF   ISNULL(@EnUso, 0)  =  0    
    
 BEGIN    
    
  DELETE FROM CAEA_Control     
  INSERT INTO CAEA_Control VALUES (GETDATE(), '1')     
    
 END    
    
END    
    

----------------------------------------------------    
 --Eejecuto Job para mover los archivos del \\Corpe11-ssrs\caea\Archivos

 --exec msdb.dbo.sp_start_job         @job_name ='Mueve_Archivos'
 
-- WAITFOR DELAY '00:00:45';


--Carga en tabla de AS    
  

--SELECT * FROM AS400_WSAFIP.dbo.COMPROBANTES  
EXEC AS400_WSAFIP.dbo.IMPORTARTXTCAEA;    
--SELECT * FROM AS400_WSAFIP.dbo.COMPROBANTES    

----------------------------------------------------    

--Carga de Tabla de WS    
EXEC WSAFIP.dbo.TRAERDATOSAS;    
EXEC WSAFIP.dbo.CAEA2AS;    
    
----------------------------------------------------    
    
--Carga en tabla de AS    
EXEC B_SONTEC.dbo.IMPORTARTXTCAEA;    
    SELECT * FROM B_SONTEC.dbo.COMPROBANTES  
--Carga de Tabla de WS    
EXEC WSAFIP_SONTEC.dbo.TRAERDATOSAS;    
EXEC WSAFIP_SONTEC.dbo.CAEA2AS;    
    
----------------------------------------------------    
    
--Carga en tabla de AS    
EXEC B_MEGASAT.dbo.IMPORTARTXTCAEA;    
SELECT * FROM B_MEGASAT.dbo.COMPROBANTES   

--Carga de Tabla de WS    
EXEC WSAFIP_MEGASAT.dbo.TRAERDATOSAS;    
EXEC WSAFIP_MEGASAT.dbo.CAEA2AS; 

------------------------

BEGIN

UPDATE		WSAFIP.dbo.CAEA_Control
SET 		EnUso		=		'0'
WHERE		EnUso		=		'1'

END

------------------------
    
GO


select * from WSAFIP_MEGASAT.dbo.Comprobantes
where

codigoAutorizacion IN ('34249778494421','34247396879835')


select * from CAEA_Control

select * from WSAFIP_MEGASAT.dbo.Comprobantes where codigoTipoComprobante	=1 and numeroPuntoVenta=35 and 	numeroComprobante in(288,289)
select * from WSAFIP_MEGASAT.dbo.arrayItems where refTC	=1 and refPV=35 and 	refNum in(288,289)
select * from WSAFIP_MEGASAT.dbo.arraySubtotalesIVA where refTC	=1 and refPV=35 and 	refNum in(288,289)
select * from WSAFIP_MEGASAT.dbo.arrayOtrosTributos where refTC	=1 and refPV=35 and 	refNum in(288,289)

begin tran

delete from WSAFIP_MEGASAT.dbo.Comprobantes where codigoTipoComprobante	=1 and numeroPuntoVenta=35 and 	numeroComprobante in(288,289)
delete from WSAFIP_MEGASAT.dbo.arrayItems where refTC	=1 and refPV=35 and 	refNum in(288,288)
delete from WSAFIP_MEGASAT.dbo.arraySubtotalesIVA where refTC	=1 and refPV=35 and 	refNum in(288,289)
delete from WSAFIP_MEGASAT.dbo.arrayOtrosTributos where refTC	=1 and refPV=35 and 	refNum in(288,289)

commit tran

EXEC [CORPSQLMULT2019].[WSAFIP].dbo.RVF_PRC_Ejecutar_CAEA