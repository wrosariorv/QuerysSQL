USE [RV_Chile]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_API_INSERTA_PEDIDOS_MULTIVENDE_TEST]    Script Date: 30/01/2023 10:30:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






 /*

ALTER PROCEDURE			[dbo].[RVF_PRC_API_INSERTA_PEDIDOS_MULTIVENDE_TEST]
AS

 */

BEGIN

--------------------------------------------

DECLARE				@CanalEntradaExclude		TABLE	(Lista VARCHAR(30))						-- Canales de entrada excluidos

INSERT INTO			@CanalEntradaExclude		VALUES	('Falabella') --, ('paris')						

--------------------------------------------

DECLARE				@ShippingModeExclude		TABLE	(Lista VARCHAR(30))						-- Metodos de envio excluidos

INSERT INTO			@ShippingModeExclude		VALUES	('own logistics') --, ('fulfillment')			

--------------------------------------------

DECLARE				@MaxGroupID					INT

SELECT 				@MaxGroupID			=			ISNULL(MAX(Number05) + 1,1)
FROM				[EpicorPilot11100].Ice.UD10

--------------------------------------------

IF OBJECT_ID('tempdb.dbo.#RVF_PRC_MULTIVENDE_TEMP1','U')IS NOT NULL
TRUNCATE TABLE #RVF_PRC_MULTIVENDE_TEMP1

ELSE

CREATE TABLE		#RVF_PRC_MULTIVENDE_TEMP1	( 
												[NumeroOC][nvarchar](50), 
												[Linea] [INT],
												[CostoEnvio][Decimal](20,9)
												)

INSERT INTO			#RVF_PRC_MULTIVENDE_TEMP1		

SELECT				[NumeroOC], MIN([Linea]) AS Linea, 
					ROUND(
						ISNULL(NULLIF((MIN([CostoEnvio]) / 
						(1 + ISNULL([dbo].[RVF_FNC_BUSCA_TASA_IMPUESTO_CARGO_MISC] (ISNULL(NULLIF([CanalEntrada], ''),'')), 0))), 0),0)			
						, 2) AS CanalEntrada 
FROM				[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]		A			WITH (NoLock)
WHERE				A.ShippingMode		NOT IN	(
												SELECT			*
												FROM			@ShippingModeExclude
												)

	AND				A.[CanalEntrada]	NOT IN	(
												SELECT			*
												FROM			@CanalEntradaExclude
												)
GROUP BY			[NumeroOC], [CanalEntrada]
---------------------------------------------------------------------------------------------------
/**************************************************************************************************
Valida Registros duplicado en la tabla [CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]
***************************************************************************************************/
--
EXEC		[RV_Chile].[dbo].[RVF_PRC_API_BUSCA_REGISTROS_DUPLICADO_MULTIVENDE]
---------------------------------------------------------------------------------------------------
/*

INSERT INTO		[EpicorPilot11100].[ICE].[UD10]	
				(	
				Company, Key1, Key2, Key3, Key4, Key5,
				----------------------------------------------------------------
				ShortChar01, ShortChar02, ShortChar03, ShortChar04, ShortChar05, 
				ShortChar06, ShortChar07, ShortChar08, 
				ShortChar09, ShortChar10, 
				ShortChar11, ShortChar12, ShortChar13, ShortChar14, 
				ShortChar15, ShortChar16, ShortChar17, ShortChar18, ShortChar19,
				----------------------------------------------------------------
				Date01, Date02, Character02, 
				Number01, Number02, Number03, Number04, Number05, 
				CheckBox01, CheckBox02, CheckBox03 
				)

*/


SELECT					
						TOP 10
						MV.Company, 
						MV.Key1, 
						--MV.ID,
						RIGHT('0000000000000' + CAST(MV.Linea AS VARCHAR(10)), 13)			AS		Key2, 
						MV.CanalEntrada, --'SP' AS CanalEntrada,
						MV.NumeroOC, 
						MV.NumeroDocumento, 
						------------------------------------------------------------------------------------------------------------------
						MV.Nombre, 
						MV.Domicilio, 
						MV.Ciudad, 
						MV.Provincia, 
						MV.CodigoPostal, 
						MV.CodigoProvincia, 
						MV.Entrega_Nombre, 
						MV.Entrega_domicilio1, 
						MV.Entrega_domicilio2, 
						MV.Entrega_domicilio3, 
						MV.Entrega_Ciudad, 
						MV.Entrega_Provincia, 
						MV.Entrega_CP, 
						MV.Entrega_Documento, 
						MV.Comentario, 
						MV.CodigoProducto, 
						'PDT'																AS		Estado, 
						'0'																	AS		NumeroOV, 
						'0'																	AS		CustNum, 
						MV.FechaVenta, 
						GETDATE()															AS		FechaAltaOV, 
						MV.InsercionUD10,
						MV.Linea, 
						MV.Cantidad, 
				/*		
						MV.PrecioUnitarioOriginal, 
						MV.AlicuotaImpuestoParte, 
				*/		
						MV.PrecioUnitario, 
				/*
						MV.CostoEnvioOriginal, 
						MV.AlicuotaImpuestoCostoEnvio, 
				*/
						ISNULL(NULLIF(T1.[CostoEnvio], 0),0)								AS		CostoEnvio, 
						@MaxGroupID 														AS		GroupID, 
						MV.RequierFactura													AS		RequiereFactura, 
						0																	AS		Integrado, 
						0																	AS		IntegradoRV							-- Solo marcar en la ultima linea de la integracion

FROM					(
						SELECT				
						
						'CL01'																												AS Company, 
						'TCP-Commerce'																										AS Key1,
						A.[ID]																												AS ID,
						CASE   
												 WHEN (A.[CanalEntrada] = 'mercadolibre')						THEN 'ML'
												 WHEN (A.[CanalEntrada] = 'Linio')								THEN 'LI'
												 WHEN (A.[CanalEntrada] = 'Paris')								THEN 'PA'
												 WHEN (A.[CanalEntrada] = 'Ripley')								THEN 'RP'
												 WHEN (A.[CanalEntrada] = 'Falabella')							THEN 'FL'
												 WHEN (A.[CanalEntrada] = 'shopify')							THEN 'SP'
												 ELSE																 ''  
						END																													AS CanalEntrada, 
						A.[NumeroOC],
						CASE					
												WHEN(A.[NumeroDocumento] like '%-%')							THEN REPLACE( A.[NumeroDocumento] COLLATE Modern_Spanish_CI_AS,'.','')
												WHEN(A.[NumeroDocumento] like '%K%')							THEN REPLACE (A.[NumeroDocumento] COLLATE Modern_Spanish_CI_AS,'K','-K')
												WHEN(A.[NumeroDocumento] = '')									THEN '19648448-5'
												ELSE 
													CONCAT (A.[NumeroDocumento],'-', [dbo].[RVF_FNC_VALIDA_DV_RUT](A.[NumeroDocumento]))
						END	
																																			AS NumeroDocumento,	
						ISNULL(NULLIF(A.[Nombre], ''),'')																					AS Nombre,
						ISNULL(NULLIF(A.[Domicilio], ''),'')																				AS Domicilio,
						ISNULL(NULLIF(A.[Ciudad], ''),'')																					AS Ciudad,
						[dbo].[RVF_FNC_VALIDA_REGION](ISNULL(NULLIF(A.[Provincia], ''),''))													AS Provincia,
						ISNULL(NULLIF(A.[CodigoPostal], ''),'')																				AS CodigoPostal,
						ISNULL(NULLIF(A.[CodigoProvincia], ''),'')																			AS CodigoProvincia,
						ISNULL(NULLIF(A.[Entrega_Nombre], ''), A.[Nombre])																	AS Entrega_Nombre,
						ISNULL(NULLIF(A.[Entrega_domicilio1], ''),A.[Domicilio])															AS Entrega_domicilio1,
						ISNULL(NULLIF(A.[Entrega_domicilio2], ''),'')																		AS Entrega_domicilio2,
						ISNULL(NULLIF(A.[Entrega_domicilio3], ''),'')																		AS Entrega_domicilio3,
						ISNULL(NULLIF(A.[Entrega_Ciudad], ''), A.[Ciudad])																	AS Entrega_Ciudad,
						[dbo].[RVF_FNC_VALIDA_REGION](ISNULL(NULLIF(A.[Entrega_Provincia], ''), A.[Provincia]))								AS Entrega_Provincia,
						
						--ISNULL(NULLIF(A.[Entrega_Provincia], ''), A.[Provincia])															AS Entrega_Provincia,
						ISNULL(NULLIF(A.[Entrega_CP], ''), ISNULL(NULLIF(A.[CodigoPostal], ''),''))											AS Entrega_CP,
						ISNULL(NULLIF(A.[Entrega_Documento], ''), 
						CASE					
												WHEN(A.[NumeroDocumento] like '%-%')							THEN REPLACE( A.[NumeroDocumento] COLLATE Modern_Spanish_CI_AS,'.','')
												WHEN(A.[NumeroDocumento] like '%K%')							THEN REPLACE (A.[NumeroDocumento] COLLATE Modern_Spanish_CI_AS,'K','-K')
												WHEN(A.[NumeroDocumento] = '')									THEN '19648448-5'
												ELSE 
													CONCAT (A.[NumeroDocumento],'-', [dbo].[RVF_FNC_VALIDA_DV_RUT](A.[NumeroDocumento]))
						END
						
						)																													AS Entrega_Documento,
						ISNULL(NULLIF(A.[Comentario], ''),'')																				AS Comentario,
						ISNULL(NULLIF(A.[FechaVenta], ''),GETDATE())																		AS FechaVenta,
						ISNULL(NULLIF(A.[Linea],0),0)																						AS Linea,
						GETDATE()																											AS InsercionUD10,
						ISNULL(NULLIF(A.[CodigoProducto], ''),'')																			AS CodigoProducto,
						ISNULL(NULLIF(A.[Cantidad], 0),0)																					AS Cantidad,
				--		ISNULL(NULLIF((A.[PrecioUnitario]-(A.[PrecioUnitario]*0.19)), 0),0)													AS PrecioUnitario,
				
						A.[PrecioUnitario]																									AS PrecioUnitarioOriginal, 
						(ISNULL([dbo].[RVF_FNC_BUSCA_TASA_IMPUESTO_PARTE] (ISNULL(NULLIF(A.[CodigoProducto], ''),'')), 0))					AS AlicuotaImpuestoParte, 

						ROUND(
						ISNULL(NULLIF((A.[PrecioUnitario] / 
						(1 + ISNULL([dbo].[RVF_FNC_BUSCA_TASA_IMPUESTO_PARTE] (ISNULL(NULLIF(A.[CodigoProducto], ''),'')), 0))), 0),0)			
						, 2)																												AS PrecioUnitario,

						ISNULL(NULLIF(A.[RequiereFactura], ''),'False')																		AS RequierFactura,
				--		ISNULL(NULLIF(A.[CostoEnvio], 0),0)																					AS CostoEnvio, 

						A.[CostoEnvio]																										AS CostoEnvioOriginal, 
						(ISNULL([dbo].[RVF_FNC_BUSCA_TASA_IMPUESTO_CARGO_MISC] (ISNULL(NULLIF(A.[CanalEntrada], ''),'')), 0))				AS AlicuotaImpuestoCostoEnvio, 
				
						ROUND(
						ISNULL(NULLIF((A.[CostoEnvio] / 
						(1 + ISNULL([dbo].[RVF_FNC_BUSCA_TASA_IMPUESTO_CARGO_MISC] (ISNULL(NULLIF(A.[CanalEntrada], ''),'')), 0))), 0),0)			
						, 2)																												AS CostoEnvio, 

						ISNULL(NULLIF(A.[UltimaLinea], ''),'')																				AS UltimaLinea,
						ISNULL(NULLIF(A.[ShippingMode], ''),'Despacho a domicilio')															AS ShippingMode	

						FROM				[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]	A				WITH (NoLock)
						WHERE				A.ShippingMode		NOT IN	(
																		SELECT			*
																		FROM			@ShippingModeExclude
																		)

							AND				A.[CanalEntrada]	NOT IN	(
																		SELECT			*
																		FROM			@CanalEntradaExclude
																		)
						------------------------------------------------------------------------------------------------------------------
							
							AND				A.[CodigoProducto]	<>		''
							/*****************************************************************
													Correccion
							Se controla que no hayan registros repetidos en la tabla intermedia
							******************************************************************/
							AND				A.ID				NOT IN			(
																						SELECT			ID 
																						FROM			[RV_Chile].[dbo].RVF_TBL_API_PEDIDOS_DUPLICADOS_MULTIVENDE
																				)
							/*****************************************************************
										Se controla que solo vengan pedidos de Shopify
							******************************************************************/
							AND				A.[CanalEntrada]		=		'shopify'	


						)		MV 


/************************************************************************************

Se indica el costo de envio solo en la primera linea de la OC

************************************************************************************/

LEFT OUTER JOIN		#RVF_PRC_MULTIVENDE_TEMP1										T1			WITH(NoLock)
	ON				MV.NumeroOC				=				T1.NumeroOC
	AND				MV.Linea				=				T1.Linea


/************************************************************************************

Se verifica que la orden de venta este completamente integrada en la tabla intermedia

************************************************************************************/

INNER JOIN			(
					SELECT				'CL01'																						AS Company, 
										'TCP-Commerce'																				AS Key1, 
										NumeroOC, UltimaLinea
					FROM				[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]	A				WITH (NoLock)
					WHERE				A.[CodigoProducto]	<>		''
						AND				A.[UltimaLinea]		=		1
						AND				A.[ID]				NOT IN			(
																						SELECT			ID 
																						FROM			[RV_Chile].[dbo].RVF_TBL_API_PEDIDOS_DUPLICADOS_MULTIVENDE
																			) 
					)		U
	ON				MV.Company				=				U.Company
	AND				MV.Key1					=				U.Key1 
	AND				MV.NumeroOC				=				U.NumeroOC



/************************************************************************************

Se controla que el pedido no haya sido previamente integrado en la UD10

************************************************************************************/

LEFT OUTER JOIN		[EpicorPilot11100].Ice.UD10										UD			WITH (NoLock)
	ON				MV.CanalEntrada			=				UD.Key3	
	AND				MV.NumeroOC				=				UD.Key4	
	AND				MV.Linea				=				UD.Number01

WHERE				UD.Key3				IS NULL
	AND				UD.Key4				IS NULL

--	AND				MV.NumeroOC			<> '20944179001-A'


------------------------------------------------------------------------------------------------------------------

ORDER BY			MV.Company, MV.Key1, MV.CanalEntrada, MV.NumeroOC, MV.Linea

/************************************************************************************

Se ejecuta el procedimiento que verifica si hay errores en el detalle de las lineas de venta insertadas

************************************************************************************/

EXECUTE				RVF_PRC_API_INSERTA_PEDIDOS_CONTROLA_ERRORES_LINEA_TEST	@MaxGroupID


------------------------------------------------------------------------------------------------------------------


END

GO


