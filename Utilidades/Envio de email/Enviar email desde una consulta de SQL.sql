---SSRS Argentina
EXEC    msdb.dbo.sp_send_dbmail
    @profile_name    =    'Notificaciones Grupo Epicor',  
    @recipients        =    'wrosario@radiovictoria.com.ar',  
    @importance        =    'HIGH',  
    @subject        =    'Error en procedimieto',
    @body            =    'El procedimiento fallo'

--Chile
EXEC			msdb.dbo.sp_send_dbmail
    @profile_name    =    'Grupo Epicor Chile',  
    @recipients        =    'wrosario@radiovictoria.com.ar',  
    @importance        =    'HIGH',  
    @subject        =    'Error en procedimieto',
    @body            =    'El procedimiento fallo'

DECLARE @Error_Mensaje nvarchar (1000) ='No hay Conexon con el Servicor de Base de datos',
		@BodyEmail nvarchar (2000);
		
		SET @BodyEmail ='El procedimiento almacenado [CHILEPIDB].[RV_Chile].[dbo].[RVF_PRC_API_INSERTA_PEDIDOS_MULTIVENDE] a fallo, por favor revisar el error y habilitar nuevamente el SP. Error: '+ @Error_Mensaje;

		--SELECT @BodyEmail

EXEC			msdb.dbo.sp_send_dbmail
    @profile_name    =    'Grupo Epicor Chile',  
    @recipients        =    'wrosario@radiovictoria.com.ar',  
    @importance        =    'HIGH',  
    @subject        =    'Error en la ejecucion del SP RVF_PRC_API_INSERTA_PEDIDOS_MULTIVENDE',
    @body            =    @BodyEmail