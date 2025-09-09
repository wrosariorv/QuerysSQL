--------------------------------------------- 
BEGIN TRY
--------------------------------------------- 


--------------------------------------------- 
--Control de errores
---------------------------------------------
BEGIN    
    
DECLARE  @EnUso VARCHAR(5),     @Error_Control VARCHAR(5), @Error_Mensaje nvarchar (1000), @Error_Status bit , @Filas_Recuperadas int;   
SELECT  @EnUso			=	[EnUso], 
		@Error_Control	=	[Error_Control]
FROM	[CHILEPIDB\EPICHILEDB].[RV_Chile].dbo.[RV_TBL_INSERTA_PEDIDO_MULTIVENDE_CONTROL]   

    
IF   (ISNULL(@EnUso, 0)  =  0  )
    
	BEGIN    
  
	DELETE FROM [CHILEPIDB\EPICHILEDB].[RV_Chile].dbo.[RV_TBL_INSERTA_PEDIDO_MULTIVENDE_CONTROL]     
	INSERT INTO [CHILEPIDB\EPICHILEDB].[RV_Chile].dbo.[RV_TBL_INSERTA_PEDIDO_MULTIVENDE_CONTROL] VALUES (GETDATE(), '0','0','',null)

    
	END    
---------------------------------------------    
END   
--------------------------------------------- 


exec [CHILEPIDB\EPICHILEDB].[RV_Chile].dbo.[RVF_PRC_API_INSERTA_PEDIDOS_MULTIVENDE]


------------------------
--Atrapa cantidad de filas devueltas
------------------------
SET			@Filas_Recuperadas=@@ROWCOUNT


------------------------
--Control de uso y error de ejecucion
------------------------
BEGIN
			
		SET			@Error_Status=ERROR_STATE()
					
		IF (@Error_Status is null)

		UPDATE		[CHILEPIDB\EPICHILEDB].[RV_Chile].dbo.[RV_TBL_INSERTA_PEDIDO_MULTIVENDE_CONTROL]
		SET 		[EnUso]			=		'0',
					[Error_Control]	=		'0',
					[Error_Mensaje]	=		'',
					[Filas_Recuperadas]=@Filas_Recuperadas
					
					
					
END
--/*


--------------------------------------------- 
END TRY
--------------------------------------------- 
BEGIN CATCH
------------------------
--Deshabilito el Job 'PRUEBA'
------------------------
set nocount on

USE msdb 

EXEC dbo.sp_update_job  
    @job_name = N'RVF_PRC_API_INSERTA_PEDIDOS_MULTIVENDE',  
    @new_name = N'RVF_PRC_API_INSERTA_PEDIDOS_MULTIVENDE Disable',  
    @description = N'Inserta pedidos deshabilitado por error en la ejecucion.',  
    @enabled = 0  ;


BEGIN


		SET			@Error_Mensaje='Error en la linea '+CONVERT(varchar(1000), ERROR_LINE())+' del SP, Mensaje: '+ERROR_MESSAGE() 
		SET			@Error_Status=ERROR_STATE()

		IF			(@Error_Status=1)

		UPDATE		[CHILEPIDB\EPICHILEDB].[RV_Chile].dbo.[RV_TBL_INSERTA_PEDIDO_MULTIVENDE_CONTROL]
		SET 		[EnUso]			=		'0',
					[Error_Control]	=		@Error_Status,
					[Error_Mensaje]	=		@Error_Mensaje,
					[Filas_Recuperadas]=@Filas_Recuperadas

					
END



END CATCH



--select * from [CHILEPIDB\EPICHILEDB].[RV_Chile].dbo.[RV_TBL_INSERTA_PEDIDO_MULTIVENDE_CONTROL]


