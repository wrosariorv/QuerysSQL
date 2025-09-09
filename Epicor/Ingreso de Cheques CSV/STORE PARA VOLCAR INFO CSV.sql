



--/*
ALTER PROCEDURE			[dbo].[RVF_PRC_CSV_TESORERIA]						
																			@Ruta				VARCHAR(500) 

AS
--*/
--------------
Begin try
--------------
			set nocount on

			DECLARE
			/*	 
				@Ruta				VARCHAR(500)	= '\\CORPFILESRV01\Grupos\Padrones\CSV\CSV de Cobranzas.csv',
			*/

			---------------------------------------------

				@Proceso			DATETIME		= GETDATE(), 
				@Consulta			VARCHAR(Max) 					-- 0 - display only,  1 - display and update
			---------------------------------------------

			---------------------------------------------
			BEGIN    
    
			DECLARE  @EnUso VARCHAR(5),     @Error_Control VARCHAR(5), @Error_Mensaje nvarchar (1000), @Error_Status bit , @Filas_Actualizadas int;   
			SELECT  @EnUso			=	[EnUso], 
					@Error_Control	=	[Error_Control]
			FROM	[CORPEPISSRS01].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]    
    
			IF   (ISNULL(@EnUso, 0)  =  0  )
    
				BEGIN    
  
				DELETE FROM [CORPEPISSRS01].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]     
				INSERT INTO [CORPEPISSRS01].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL] VALUES (GETDATE(), '0','0','',null)

    
				END    
			---------------------------------------------    
			END   
			--------------------------------------------- 

			

			/*********************************************************************
			Vaciado de la tabla temporal donde se cargan los REGISTROS
			*********************************************************************/

			DELETE FROM		[CORPEPISSRS01].[RVF_Local].[dbo].RVF_CSV_DATA

			/*********************************************************************
			Insercion masiva de registros 
			*********************************************************************/
			BEGIN
				SET			@Consulta = 'BULK INSERT [RVF_Local].[dbo].RVF_CSV_DATA FROM ''' + @Ruta + ''''

					BEGIN TRY  
		
						SET		@Consulta = @consulta + 'WITH (		FIELDTERMINATOR = '';'', ROWTERMINATOR = ''\n'', FIRSTROW = 2);'
		
						EXEC		(@Consulta)
		

					END TRY  

					BEGIN CATCH  
     
								SET			@Error_Status=ERROR_STATE()
					
								IF (@Error_Status is null)

								UPDATE		[CORPEPISSRS01].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]
								SET 		[EnUso]			=		'0',
											[Error_Control]	=		'0',
											[Error_Mensaje]	=		'',
											[Filas_Actualizadas]=@Filas_Actualizadas
		

					END CATCH
					select @Consulta
				SELECT * FROM [CORPEPISSRS01].[RVF_Local].[dbo].RVF_CSV_DATA

			END
/*
			BEGIN

				EXECUTE		RVF_Local.dbo.RVF_PRC_Integracion_Padrones_Reducidos @Tipo, @Jurisdiccion

			END 
*/

			------------------------
			--Atrapa cantidad de filas devueltas
			------------------------
			SET			@Filas_Actualizadas=@@ROWCOUNT

			--SELECT @Filas_Actualizadas AS Filas_Actualizadas
			------------------------
			--Control de uso y error de ejecucion
			------------------------
			BEGIN
			
					SET			@Error_Status=ERROR_STATE()
					
					IF (@Error_Status is null)

					UPDATE		[CORPEPISSRS01].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]
					SET 		[EnUso]			=		'0',
								[Error_Control]	=		'0',
								[Error_Mensaje]	=		'',
								[Filas_Actualizadas]=@Filas_Actualizadas
					
					
					
			END
			--/*

------------------------
END TRY
------------------------
------------------------
BEGIN CATCH
------------------------
			set nocount on
			BEGIN


					SET			@Error_Mensaje='Error en la linea '+CONVERT(varchar(1000), ERROR_LINE())+' del SP, Mensaje: '+ERROR_MESSAGE() 
					SET			@Error_Status=ERROR_STATE()

					IF			(@Error_Status=1)

					UPDATE		[CORPEPISSRS01].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]
					SET 		[EnUso]			=		'0',
								[Error_Control]	=		@Error_Status,
								[Error_Mensaje]	=		@Error_Mensaje,
								[Filas_Actualizadas]=@Filas_Actualizadas

					
			END

------------------------

END CATCH

GO

