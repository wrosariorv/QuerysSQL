USE [RV_Chile]
GO

/****** Object:  View [dbo].[RVF_VW_API_PEDIDOS_ESTADO_FACTURADO_ORDEN]    Script Date: 2/02/2023 11:59:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*************************************************************
Estructura de datos pedida para confirmar si la orden de venta ha sido facturada.
{"resultado":"true","documento":"BOL_ELEC_WEBTCL","folio":"12345","mensaje":null}
{"resultado":"false","documento":null,"folio":null,"mensaje":"Error: DTE no existe"}

Los documentos de ventas se identifican de la siguiente manera:
  BE-00007102	->	39-7102.pdf
  BE-00007103	->	39-7103.pdf
  FE-00002009	->	33-2009.pdf
  FE-00002010	->	33-2010.pdf
*************************************************************/

--/*

ALTER VIEW		[dbo].[RVF_VW_API_PEDIDOS_ESTADO_FACTURADO_ORDEN]
AS

--*/

/*************************************************************
Pedidos de ventas no integrados
*************************************************************/

SELECT			convert(varchar,Key4)								AS		orden,
				0													AS		resultado, 
				'NULL'												AS		documento, 
				'NULL'												AS		folio, 
				'DTE no existe'										AS		error 

FROM			[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
WHERE			UD.Company					=			'CL01'
	AND			UD.ShortChar18				=				0						-- Registros de la UD10 no integrados como pedidos de venta en Epicor
-- Se excluyen los pedidos que no son del  TCLStore
AND				UD.Key3='TC'

----------------
UNION ALL 
----------------

/*************************************************************
Pedidos de ventas integrados
*************************************************************/

SELECT			orden, 
				MIN(resultado)										AS		resultado, 
				MAX(documento)										AS		documento, 
				MAX(folio)											AS		folio,
				MIN(error)											AS		error

FROM			(
				SELECT			convert(varchar,Key4)								AS		orden,		
								Number01											AS		linea,  
								CASE 
										WHEN		IH.LegalNumber		IS NULL 
										THEN							0
										ELSE							1
								END													AS		resultado, 
								CASE 
										WHEN		IH.LegalNumber		IS NULL 
										THEN							'NULL'
										ELSE							'BOL_ELEC_WEBTCL'
								END													AS		documento, 
								----------------------------------------------------------------------
								/*********************************************************************
								CASE 
										WHEN		IH.LegalNumber		IS NULL 
										THEN							'NULL'
										ELSE							IH.LegalNumber
								END													AS		folio, 
								*********************************************************************/
								----------------------------------------------------------------------
								CASE 
										WHEN		IH.LegalNumber		IS NULL 
										THEN							'NULL'
										ELSE							CASE	dbo.[GetColumnValue]  (IH.LegalNumber, '-', 1)		
																				WHEN		'FE'		THEN		'33'
																				WHEN		'BE'		THEN		'39'
																				ELSE								'00'
																		END		+		'-'		+
																		CAST(CAST(dbo.[GetColumnValue]  (IH.LegalNumber, '-', 2) AS INT) AS VARCHAR(10))
								END													AS		folio,
								----------------------------------------------------------------------
								CASE 
										WHEN		IH.LegalNumber		IS NULL 
										THEN							'DTE no existe'
										ELSE							'NULL'
								END													AS		error 
				/*		
								,
								UD.ShortChar18, 
								ID.InvoiceNum, ID.OrderNum, ID.OrderLine, 
								IH.LegalNumber 
				*/ 

				FROM			[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
				LEFT OUTER JOIN	[EpicorLive11100].[Erp].[InvcDtl]		ID		WITH(NoLock)
					ON 			UD.Company			=				ID.Company	
					AND			UD.ShortChar18		=				CAST(ID.OrderNum AS VARCHAR (50))
				LEFT OUTER JOIN	[EpicorLive11100].[Erp].[InvcHead]		IH		WITH(NoLock)
					ON 			ID.Company			=				IH.Company	
					AND			ID.InvoiceNum 		=				IH.InvoiceNum 
				LEFT OUTER JOIN	[EpicorLive11100].[Erp].[OrderHed]		OH		WITH(NoLock)
					ON 			UD.Company			=				OH.Company	
					AND			UD.ShortChar18		=				CAST(OH.OrderNum AS VARCHAR (50))

				WHERE			UD.Company					=			'CL01'
					AND			UD.ShortChar18				<>				0						-- Registros de la UD10 integrados como pedidos de venta en Epicor
					-- Se excluyen los pedidos que no son del  TCLStore
					AND				UD.Key3='TC'
					-- Se excluyen las ordenes de venta eliminadas en Epicor
					AND			OH.OpenOrder				IS NOT NULL 							
					
					-- Se excluyen las ordenes de venta cerradas en Epicor y que no tengan numero legal de factura
					AND			(																	
								IH.LegalNumber				IS NOT NULL
								OR 
								OH.OpenOrder				=				1 
								)

				)		A

GROUP BY		orden




GO


