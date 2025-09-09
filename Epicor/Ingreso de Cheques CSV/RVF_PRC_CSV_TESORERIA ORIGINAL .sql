USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_CSV_TESORERIA]    Script Date: 6/2/2024 16:22:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--/*
ALTER PROCEDURE			[dbo].[RVF_PRC_CSV_TESORERIA]						
																			@Ruta				VARCHAR(500) 

AS
--*/
--------------
Begin try
--------------
			SET NOCOUNT ON

			DECLARE
			/*	 
				--@Ruta				VARCHAR(500)	= '\\CORPFILESRV01\Grupos\Padrones\CSV\CSV de Cobranzas ERROR.csv',

				@Ruta				VARCHAR(500)	= '\\CORPE11-SSRS\Cheques_Recibidos\mpaz0011000075943309202311021337020780000174260030446ConsultaChequesRecibidos - Original 15112023.csv',
			*/

			---------------------------------------------

				@Proceso			DATETIME		= GETDATE(), 
				@Consulta			VARCHAR(Max), 					-- 0 - display only,  1 - display and update
				@FileOK				INT,
				@FilasCSV			INT,
				@Error_Fila			VARCHAR(Max)
			---------------------------------------------

			---------------------------------------------
			BEGIN    
    
			DECLARE  @EnUso VARCHAR(5),     @Error_Control VARCHAR(5), @Error_Mensaje nvarchar (1000), @Error_Status bit , @Filas_Actualizadas int;   
			SELECT  @EnUso			=	[EnUso], 
					@Error_Control	=	[Error_Control]
			FROM	[CORPE11-SSRS].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]    
    
			IF   (ISNULL(@EnUso, 0)  =  0  )
    
				BEGIN    
  
				DELETE FROM [CORPE11-SSRS].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]     
				INSERT INTO [CORPE11-SSRS].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL] VALUES (GETDATE(), '1','0','',null)

    
				END    
			---------------------------------------------    
			END   
			--------------------------------------------- 
			/*********************************************************************
					CREO TABLA TEMPORAL
			*********************************************************************/

				IF OBJECT_ID('tempdb.dbo.#DATA', 'U') IS NOT NULL
							TRUNCATE TABLE #DATA	
					ELSE

							CREATE TABLE #DATA(
												ROW nvarchar(MAX)
												)
			

			/*********************************************************************
			Vaciado de la tabla temporal donde se cargan los REGISTROS
			*********************************************************************/

			DELETE FROM		[CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_DATA

			
			/*********************************************************************
						VALIDO QUE EL ARCHIVO EXISTA EN LA RUTA DE ORIGEN
			*********************************************************************/
			EXEC xp_fileExist  @Ruta,@FileOK OUTPUT	
			IF @FileOK = 1
			BEGIN
			
			/*********************************************************************
							Insercion masiva de registros 
			*********************************************************************/
			
					SET			@Consulta = 'BULK INSERT #DATA FROM ''' + @Ruta + ''''

						BEGIN TRY  
		
							SET		@Consulta = @consulta + 'WITH (		 ROWTERMINATOR = ''\n'', FIRSTROW = 2);'
		
							EXEC		(@Consulta)
		

						END TRY  

						BEGIN CATCH  
									SET			@Error_Mensaje='Error en la linea '+CONVERT(varchar(1000), ERROR_LINE())+' del SP, Mensaje: '+ERROR_MESSAGE() 
									SET			@Error_Status=ERROR_STATE()
					
									IF (@Error_Status is null)

									UPDATE		[CORPE11-SSRS].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]
									SET 		[EnUso]			=		'0',
												[Error_Control]	=		'0',
												[Error_Mensaje]	=		@Error_Mensaje,
												[Filas_Actualizadas]=@Filas_Actualizadas

									--PRINT		@Error_Mensaje
		

						END CATCH
			
			
			
				/*********************************************************************
						Cuentos cantidas de Filas del csv y EXCEl
				*********************************************************************/
						--SET @FilasCSV	=	SELECT COUNT([ROW]) FROM #DATA			
						SELECT @FilasCSV=COUNT([ROW]) FROM #DATA	
		
				/*********************************************************************
						Vaciado de la tablas RVF_CSV_ROW_DATA y RVF_CSV_DATA
				*********************************************************************/

				DELETE FROM		[CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_ROW_DATA

				DELETE FROM		[RVF_Local].[dbo].RVF_CSV_DATA

			
				/*********************************************************************
						Inseto datos ajustados en la tabla RVF_CSV_ROW_DATA
				*********************************************************************/
				INSERT INTO RVF_CSV_ROW_DATA
				SELECT	REPLACE(REPLACE(REPLACE(REPLACE([ROW], '&quot;', ''),'null',''),'&amp;', ''),'"','') 
				FROM	#DATA


				/*********************************************************************
						Vuelco informacion en un archivo de texto
				*********************************************************************/

				EXEC xp_cmdshell 'bcp "SELECT * FROM [CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_ROW_DATA" queryout "G:\Cheques_Recibidos\correccion.CSV" -T -c -t,' ,NO_OUTPUT;

			
				/*********************************************************************
						Extraigo informacion del archivo de texto
				*********************************************************************/
				BULK INSERT [RVF_Local].[dbo].RVF_CSV_DATA FROM N'G:\Cheques_Recibidos\correccion.CSV'

				WITH (		FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', FIRSTROW = 1);

			
				/*********************************************************************
								Controlo que los bancos exista en Epicor
				*********************************************************************/
							DECLARE		
									@ErrorBancos VARCHAR(2000),
									@mensajeError VARCHAR(MAX),
									@Bancos VARCHAR(MAX) 
									SET @Bancos=''

							DECLARE
										@BancosCSV Table (Bancos VARCHAR(2000))

										INSERT INTO @BancosCSV
										SELECT			A.[Banco_Emisor]
										FROM			[CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_DATA	A
						
										GROUP BY		A.[Banco_Emisor]


							SELECT			@Bancos=@Bancos + A.Bancos+', '
							FROM			(
						
												SELECT		
															--@Bancos=@Bancos + Y.Bancos+', '
															y.[Description],y.Bancos,Z.LongDesc
							

												FROM		(
																SELECT			B.[Description],X.Bancos

																FROM			[CORPE11-EPIDB].EpicorErp.Erp.BankBrnch		B
						
																RIGHT JOIN		(
																						SELECT		
																									'CO01' AS Company,
																									Bancos
																						FROM		@BancosCSV	
																				) AS X
																ON				X.Company		=	B.company
																AND				X.Bancos		=	B.[Description]
															)	AS Y
												left JOIN		(
																	SELECT		UC.CodeDesc, UC.LongDesc
																	FROM		[CORPE11-EPIDB].EpicorErp.ICE.UDCodes	UC
																	WHERE		CodeTypeID='BANCOS_CSV'
																	AND			ISaCTIVE = 1
																) AS Z
													ON			Y.Bancos		=		Z.CodeDesc

												WHERE Y.[Description]	IS NULL
											) AS A
							WHERE	
											A.[Description] IS NULL
							AND				A.LongDesc IS NULL


				IF		@Bancos		<>		''
				BEGIN
			  
				  SET	@Bancos		=	 LEFT(@Bancos, LEN(@Bancos) - 1)
			  


				  SET	@mensajeError = 'Los siguientes bancos no se encuentran en el maestro de código de banco en Epicor ( ' + @Bancos + ' )'
				  RAISERROR(@mensajeError, 16, 1)

				END
				/*********************************************************************
				 Controlo que los datos devuelto del excele coincidan con los del csv
				*********************************************************************/
			------------------------
			--Atrapa cantidad de filas devueltas
			------------------------
SELECT @Filas_Actualizadas=COUNT(*)
FROM	(
				
					SELECT			
									W.Company,
									W.Razon_Social_U				AS Character01,
									'ChequesElectronicos'			AS Key1,
									W.BankBranchCode				AS Key2,
									W.Numero_cheque					AS Key3,
									W.Estado						AS ShortChar01,
									W.Monto_u						AS Number01,
									W.Fecha_Pago					AS Date01,
									W.[Fecha_Emisión]				AS Date02, --Se agrego campo para grabar la fecha de emision
									W.Cuit_Emisor_U					AS Key4,
									''								AS Key5
								


					FROM			(


										SELECT			
															B.Company,
															CASE
																WHEN	A.[Endoso_Razon_Social] is not null  
																THEN	A.[Endoso_Razon_Social]

																WHEN	A.[Nombre_Cedente]	is not null
																THEN	A.[Nombre_Cedente]
									
																ELSE	LTRIM(A.[Razon_Social])
															END AS Razon_Social_U,
															LTRIM(A.[Razon_Social]) AS Razon_Social, 
															A.[Numero_cheque],
															B.[BankBranchCode],
															B.[Description],
															A.[Banco_Emisor],
															--X.LongDesc,
															A.[Estado],
															FORMAT(CAST(A.[Monto] AS MONEY), 'N', 'es-ES') AS [Monto_u],
															 A.[Monto],
															A.[Fecha_Pago],
															A.[Fecha_Emisión],
															CASE
																WHEN	A.[Endoso_Documento] is not null 
																THEN	A.[Endoso_Documento]
									
																WHEN	A.[Numero_Documento_Cesionario] is not null
																THEN	A.[Documento_Cedente]

																ELSE	A.[Cuit_Emisor]
															END AS Cuit_Emisor_U,
															A.[Cuit_Emisor] 
								
								
											FROM			[CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_DATA	A
										
											/*********BUSCO LOS BANCON EN EL MAESTRO DE CODIGOS DE BANCO EN EPICOR*********/
											LEFT JOIN		[CORPE11-EPIDB].EpicorErp.Erp.BankBrnch		B
											ON				A.Banco_Emisor	=	B.[Description]
											WHERE			
															B.Company		=	'CO01'


									) AS W

				---------
				UNION ALL
				---------
				--*/


					SELECT			
									W.Company,
									W.Razon_Social_U				AS Character01,
									'ChequesElectronicos'			AS Key1,
									--W.BankBranchCode				AS Key2,
									W.CodeID						AS Key2,
									W.Numero_cheque					AS Key3,
									W.Estado						AS ShortChar01,
									W.Monto_u						AS Number01,
									W.Fecha_Pago					AS Date01,
									W.[Fecha_Emisión]				AS Date02,--Se agrego campo para grabar la fecha de emision
									W.Cuit_Emisor_U					AS Key4,
									''								AS Key5
									--,UC.LongDesc


					FROM			(


										SELECT			
															X.Company,
															CASE
																WHEN	A.[Endoso_Razon_Social] is not null  
																THEN	A.[Endoso_Razon_Social]

																WHEN	A.[Nombre_Cedente]	is not null
																THEN	A.[Nombre_Cedente]
									
																ELSE	LTRIM(A.[Razon_Social])
															END AS Razon_Social_U,
															LTRIM(A.[Razon_Social]) AS Razon_Social, 
															A.[Numero_cheque],
															--B.[BankBranchCode],
															--B.[Description],
															A.[Banco_Emisor],
															X.LongDesc,
															X.CodeDesc,
															X.CodeID,
															A.[Estado],
															FORMAT(CAST(A.[Monto] AS MONEY), 'N', 'es-ES') AS [Monto_u],
															 A.[Monto],
															A.[Fecha_Pago],
															A.[Fecha_Emisión],
															CASE
																WHEN	A.[Endoso_Documento] is not null 
																THEN	A.[Endoso_Documento]
									
																WHEN	A.[Numero_Documento_Cesionario] is not null
																THEN	A.[Documento_Cedente]

																ELSE	A.[Cuit_Emisor]
															END AS Cuit_Emisor_U,
															A.[Cuit_Emisor] 
								
								
											FROM			[CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_DATA	A
										
											/*********BUSCO LOS BANCON DE LA USER CODE BANCOS_CS*********/
											LEFT JOIN		(
																		SELECT			
																						*
																		FROM			(
						
																							SELECT		
																									
																										y.Company, y.[Description],y.Bancos,Z.LongDesc, Z.CodeDesc, Z.CodeID
							

																							FROM		(
																											SELECT			X.Company,B.[Description],X.Bancos

																											FROM			[CORPE11-EPIDB].EpicorErp.Erp.BankBrnch		B
						
																											RIGHT JOIN		(
																																	SELECT		
																																				'CO01' AS Company,
																																				Bancos
																																	FROM		@BancosCSV	
																															) AS X
																											ON				X.Company		=	B.company
																											AND				X.Bancos		=	B.[Description]
																										)	AS Y
																							LEFT JOIN		(
																												SELECT		UC.CodeDesc, UC.LongDesc, UC.CodeID
																												FROM		[CORPE11-EPIDB].EpicorErp.ICE.UDCodes	UC
																												WHERE		CodeTypeID='BANCOS_CSV'
																												AND			ISaCTIVE = 1
																											) AS Z
																								ON			Y.Bancos		=		Z.CodeDesc

																							WHERE Y.[Description]	IS NULL
																						) AS A
																	
																		WHERE	
																						A.[Description] IS NULL
																		AND				A.LongDesc IS NOT NULL


															) AS X
												ON			A.Banco_Emisor	=	X.Bancos

											WHERE			
															X.LongDEsc		IS NOT NULL

									) AS W

				)  AS X


			/*********************************************************************
								Controles de salida
			*********************************************************************/
			
			IF(@FilasCSV <> @Filas_Actualizadas)
			BEGIN
					------------------------
					--Control de FILAS y error de ejecucion
					------------------------
					
							SET			@Error_Fila='Hubo un error en la ejecuccion del SP: Filas no coinciden '+CONVERT (VARCHAR(10), @FilasCSV)+' , '+CONVERT (VARCHAR(10),@Filas_Actualizadas)
					
									RAISERROR(@Error_Fila,16, 1 )
					
			END
			

				/*********************************************************************
						Muestro Salida comparando con el maestro de codigo de banco
				*********************************************************************/
					SELECT			
									W.Company,
									W.Razon_Social_U				AS Character01,
									'ChequesElectronicos'			AS Key1,
									W.BankBranchCode				AS Key2,
									W.Numero_cheque					AS Key3,
									W.Estado						AS ShortChar01,
									W.Monto_u						AS Number01,
									W.Fecha_Pago					AS Date01,
									W.[Fecha_Emisión]				AS Date02,--Se agrego campo para grabar la fecha de emision
									W.Cuit_Emisor_U					AS Key4,
									''								AS Key5
								


					FROM			(


										SELECT			
															B.Company,
															CASE
																WHEN	A.[Endoso_Razon_Social] is not null  
																THEN	A.[Endoso_Razon_Social]

																WHEN	A.[Nombre_Cedente]	is not null
																THEN	A.[Nombre_Cedente]
									
																ELSE	LTRIM(A.[Razon_Social])
															END AS Razon_Social_U,
															LTRIM(A.[Razon_Social]) AS Razon_Social, 
															A.[Numero_cheque],
															B.[BankBranchCode],
															B.[Description],
															A.[Banco_Emisor],
															--X.LongDesc,
															A.[Estado],
															FORMAT(CAST(A.[Monto] AS MONEY), 'N', 'es-ES') AS [Monto_u],
															 A.[Monto],
															A.[Fecha_Pago],
															A.[Fecha_Emisión],
															CASE
																WHEN	A.[Endoso_Documento] is not null 
																THEN	A.[Endoso_Documento]
									
																WHEN	A.[Numero_Documento_Cesionario] is not null
																THEN	A.[Documento_Cedente]

																ELSE	A.[Cuit_Emisor]
															END AS Cuit_Emisor_U,
															A.[Cuit_Emisor] 
								
								
											FROM			[CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_DATA	A
										
											/*********BUSCO LOS BANCON EN EL MAESTRO DE CODIGOS DE BANCO EN EPICOR*********/
											LEFT JOIN		[CORPE11-EPIDB].EpicorErp.Erp.BankBrnch		B
											ON				A.Banco_Emisor	=	B.[Description]
											WHERE			
															B.Company		=	'CO01'


									) AS W




				---------
				UNION ALL
				---------
				--*/



				/*********************************************************************
						Muestro Salida comparando con el maestro de codigo de banco
				*********************************************************************/
					SELECT			
									W.Company,
									W.Razon_Social_U				AS Character01,
									'ChequesElectronicos'			AS Key1,
									--W.BankBranchCode				AS Key2,
									W.CodeID						AS Key2,
									W.Numero_cheque					AS Key3,
									W.Estado						AS ShortChar01,
									W.Monto_u						AS Number01,
									W.Fecha_Pago					AS Date01,
									W.[Fecha_Emisión]				AS Date02,--Se agrego campo para grabar la fecha de emision
									W.Cuit_Emisor_U					AS Key4,
									''								AS Key5
									--,UC.LongDesc


					FROM			(


										SELECT			
															X.Company,
															CASE
																WHEN	A.[Endoso_Razon_Social] is not null  
																THEN	A.[Endoso_Razon_Social]

																WHEN	A.[Nombre_Cedente]	is not null
																THEN	A.[Nombre_Cedente]
									
																ELSE	LTRIM(A.[Razon_Social])
															END AS Razon_Social_U,
															LTRIM(A.[Razon_Social]) AS Razon_Social, 
															A.[Numero_cheque],
															--B.[BankBranchCode],
															--B.[Description],
															A.[Banco_Emisor],
															X.LongDesc,
															X.CodeDesc,
															X.CodeID,
															A.[Estado],
															FORMAT(CAST(A.[Monto] AS MONEY), 'N', 'es-ES') AS [Monto_u],
															 A.[Monto],
															A.[Fecha_Pago],
															A.[Fecha_Emisión],
															CASE
																WHEN	A.[Endoso_Documento] is not null 
																THEN	A.[Endoso_Documento]
									
																WHEN	A.[Numero_Documento_Cesionario] is not null
																THEN	A.[Documento_Cedente]

																ELSE	A.[Cuit_Emisor]
															END AS Cuit_Emisor_U,
															A.[Cuit_Emisor] 
								
								
											FROM			[CORPE11-SSRS].[RVF_Local].[dbo].RVF_CSV_DATA	A
										
											/*********BUSCO LOS BANCON DE LA USER CODE BANCOS_CS*********/
											LEFT JOIN		(
																		SELECT			
																						*
																		FROM			(
						
																							SELECT		
																									
																										Y.Company, y.[Description],y.Bancos,Z.LongDesc, Z.CodeDesc, Z.CodeID
							

																							FROM		(
																											SELECT			X.Company,B.[Description],X.Bancos

																											FROM			[CORPE11-EPIDB].EpicorErp.Erp.BankBrnch		B
						
																											RIGHT JOIN		(
																																	SELECT		
																																				'CO01' AS Company,
																																				Bancos
																																	FROM		@BancosCSV	
																															) AS X
																											ON				X.Company		=	B.company
																											AND				X.Bancos		=	B.[Description]
																										)	AS Y
																							LEFT JOIN		(
																												SELECT		UC.CodeDesc, UC.LongDesc, UC.CodeID
																												FROM		[CORPE11-EPIDB].EpicorErp.ICE.UDCodes	UC
																												WHERE		CodeTypeID='BANCOS_CSV'
																												AND			ISaCTIVE = 1
																											) AS Z
																								ON			Y.Bancos		=		Z.CodeDesc

																							WHERE Y.[Description]	IS NULL
																						) AS A
																	
																		WHERE	
																						A.[Description] IS NULL
																		AND				A.LongDesc IS NOT NULL


															) AS X
												ON			A.Banco_Emisor	=	X.Bancos

											WHERE			
															X.LongDEsc		IS NOT NULL

									) AS W



				

				END

			ELSE
					SET			@Error_Status='No se encontro el archivo '+@Ruta

			



			/*********************************************************************
								Ejecuto Controles de salida
			*********************************************************************/

			
			BEGIN
					------------------------
					--Control de uso y error de ejecucion
					------------------------

					
							IF (@Error_Status is null)

							UPDATE		[CORPE11-SSRS].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]
							SET 		[EnUso]			=		'0',
										[Error_Control]	=		'0',
										[Error_Mensaje]	=		'',
										[Filas_Actualizadas]=	@Filas_Actualizadas
			

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
						BEGIN
							UPDATE		[CORPE11-SSRS].[RVF_Local].dbo.[CSV_TESORERIA_CONTROL]
							SET 		[EnUso]			=		'0',
										[Error_Control]	=		@Error_Status,
										[Error_Mensaje]	=		@Error_Mensaje,
										[Filas_Actualizadas]=@Filas_Actualizadas
							--Marco error
							RAISERROR(@Error_Mensaje,16, 1 )
						END
			END

------------------------

END CATCH

GO


