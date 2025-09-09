

SELECT			Y.Company,
				Y.CanalEntrada,
				Y.PONum,
				Y.OrderNum,
				Y.OrderDate,
				CASE
						WHEN			VoidOrder		=	1
								AND		(
												Y.resultado		is null
										AND		Y.estado		is null
										)
								OR		(
												Y.resultado		is null
										AND		Y.estado		is null
										)
						THEN		'Cerrada'
						WHEN			VoidOrder		=	1
								AND		(
											Y.resultado		=	0
										OR	Y.estado		=	0
										)
						THEN			'Cerrada'
						WHEN			VoidOrder		=	0
								AND		Y.resultado		is null
								AND		Y.estado		is null
						THEN		'Abierta'
						WHEN			VoidOrder		=	0
								AND		(
												Y.resultado		=	1
										OR		Y.estado		=	1
										)
						THEN		'Facturada'
						WHEN			VoidOrder		=		1
								AND		(
												Y.resultado		=	1
										OR		Y.estado		=	1
										)
						THEN		'Facturada'
				END								AS EstadoOV,

				CASE
						WHEN			VoidOrder		=	1
								AND		(
												Y.resultado		is null
										AND		Y.estado		is null
										)
								OR		(
												Y.resultado		is null
										AND		Y.estado		is null
										)
						THEN			0
						WHEN			VoidOrder		=	1
								AND		(
											Y.resultado		=	0
										OR	Y.estado		=	0
										)
						THEN			0
						WHEN			Y.TotalOrden	<>		Y.CCDocTotal
						THEN			Y.TotalOrden - Y.CCDocTotal
						ELSE			0
								

				END								AS DifTotal1,

				CASE
						WHEN
										Y.TotalOrden	<>		Y.CCDocTotal
						THEN			Y.TotalOrden - Y.CCDocTotal
						ELSE			0
				END								AS DifTotal,

				CASE
						WHEN			VoidOrder		=	1
								AND		(
												Y.resultado		is null
										AND		Y.estado		is null
										)
								OR		(
												Y.resultado		is null
										AND		Y.estado		is null
										)
						THEN			0
						WHEN			VoidOrder		=	1
								AND		(
											Y.resultado		=	0
										OR	Y.estado		=	0
										)
						THEN			0
						WHEN
										Y.CostoEnvio	<>		Y.DocTotalMisc
						THEN			Y.CostoEnvio - Y.CostoEnvio
						ELSE			0
								

				END								AS DifEnvio1,

				CASE
						WHEN
										Y.CostoEnvio	<>		Y.DocTotalMisc
						THEN			Y.CostoEnvio - Y.CostoEnvio
						ELSE			0
				END								AS DifEnvio

				

FROM			(
					SELECT				OH.Company,W.CanalEntrada,OH.PONum,OH.OrderNum,OH.OrderDate,OH.VoidOrder,OH.CCDocAmount,OH.DocTotalMisc,OH.CCTax,OH.CCDocTotal
										,TM.TotalProducto, TM.CostoEnvio,	TM.TotalOrden
										,TCLSTORE.resultado,M.estado--,OH.*
					FROM				[EpicorLive11100].ERP.OrderHed				OH			WITH (NoLock)
					INNER JOIN			(
											SELECT CanalEntrada,NumeroOC 
											FROM	[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]				A			WITH (NoLock)
											GROUP BY CanalEntrada,NumeroOC
											----------
											UNION ALL
											----------
											SELECT		UD.Key3 AS	CanalEntrada, 
														UD.Key4	AS	NumeroOC
											FROM		[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
											WHERE		UD.Key3='TC'
											GROUP BY	UD.Key3,UD.Key4
										) AS W
						ON				OH.PONum			=			W.NUMEROOC

					LEFT OUTER JOIN		RVF_VW_API_PEDIDOS_ESTADO_FACTURADO_ORDEN							AS TCLSTORE
						ON				OH.PONum			=			TCLSTORE.Orden
					LEFT OUTER JOIN		RVF_VW_API_PEDIDOS_ESTADO_FACTURADO_DESPACHO_ORDEN_MULTIVENDE		AS M
						ON				OH.PONum			=			M.NumeroOrden
					LEFT OUTER JOIN		RVF_VW_API_CONSULTA_TOTAL_ORDEN_MULTIVENDE				AS TM	WITH (NoLock)
						ON				OH.PONum			=			TM.NumeroOC

					WHERE				Company				=			'CL01'
						AND				OrderDate			>			'05-23-2022'


				) AS Y


Order by 2,6
			
				

				Select * from RVF_VW_API_PEDIDOS_ESTADO_FACTURADO_ORDEN
				WHere orden in ('3914','3915')

				select * from RVF_VW_API_PEDIDOS_ESTADO_FACTURADO_DESPACHO_ORDEN_MULTIVENDE
				where NumeroOrden in ('3914','3915')
				/*
				3914 Cerrada	2000004375672622

				3915 Facturada	2000004377753934

				*/


				SELECT CanalEntrada,NumeroOC,* 
				FROM	[CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB]				A			WITH (NoLock)
				where
				NumeroOC='257417172'

				select * from RVF_VW_API_CONSULTA_TOTAL_ORDEN_MULTIVENDE
				where numeroOC='257417172'

				Select OH.Company,OH.PONum,OH.OrderNum,OH.OrderDate,OH.VoidOrder,OH.CCDocAmount,OH.DocTotalMisc,OH.CCTax,OH.CCDocTotal
				FROM				[EpicorLive11100].ERP.OrderHed				OH			WITH (NoLock)
				where PONum='257417172'

				
SELECT			convert(varchar,Key4)								AS		orden,
				0													AS		resultado, 
				'NULL'												AS		documento, 
				'NULL'												AS		folio, 
				'DTE no existe'										AS		error,
				UD.ShortChar18,
				Character01

FROM			[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
WHERE			UD.Company					=			'CL01'
	AND			UD.ShortChar18				=				0						-- Registros de la UD10 no integrados como pedidos de venta en Epicor
-- Se excluyen los pedidos que no son del  TCLStore
AND				UD.Key3='TC'