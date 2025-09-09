USE [WSAFIP]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_Ejecutar_CAEA]    Script Date: 5/7/2024 15:40:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--/*
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
    
--Carga de Tabla de WS    
EXEC WSAFIP_SONTEC.dbo.TRAERDATOSAS;    
EXEC WSAFIP_SONTEC.dbo.CAEA2AS;    
    
----------------------------------------------------    
    
--Carga en tabla de AS    
EXEC B_MEGASAT.dbo.IMPORTARTXTCAEA;    
    
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


