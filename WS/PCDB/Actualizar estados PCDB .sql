SELECT			
				E.Company, E.Tipo, E.GroupoAsignado, E.TipoCaso, E.TranNum,E.Estado,
				D.Linea,D.PartNum, D.Estado, E.Eliminado, D.Eliminado,
				C.id_estado,
				DF.id_estado,
				AC.id_estado,
				H.Posted,
				H.LegalNumber,
				--H.Posted
				CASE
						WHEN 
								D.Estado	=	'Pendiente'
						AND		H.Posted	=	0
						THEN	'En Integracion'
						WHEN 
								D.Estado	=	'Integrado'
						AND		H.Posted	=	0	
						THEN	'En posteo'
						WHEN
								D.Estado	=	'Integrado'
						AND		H.Posted	=	1
						THEN	'Finalizado'

						WHEN	D.Estado	NOT IN ('Pendiente','Integrado')
						THEN	D.Estado

						WHEN	D.Eliminado = 1
						THEN	'Eliminado'
				END											AS ID_ESTADO
				--,E.*, D.*

FROM 
				RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE	E
INNER JOIN		RV.RV_TBL_SIP_DETALLE_COMPROBANTE		D 
ON				E.Company		=		D.Company 
AND				E.TranNum		=		D.TranNum
LEFT JOIN (
						SELECT
									HD.Company COLLATE Modern_Spanish_CI_AS		AS Company,
									HD.InvoiceNum								AS InvoiceNum,
									HD.GroupID COLLATE Modern_Spanish_CI_AS		AS GroupID,
									CAST(SUBSTRING(HD.PONum COLLATE Modern_Spanish_CI_AS, PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) + 3, LEN(HD.PONum) - PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) - 2) AS int) AS TranNumEncabezado,
									HD.PoNum COLLATE Modern_Spanish_CI_AS AS PoNum,
									HD.Posted,
									HD.LegalNumber COLLATE Modern_Spanish_CI_AS AS LegalNumber
						FROM		[CORPL11-EPIDB].[EpicorERPTest].dbo.InvcHead HD
						WHERE
									HD.InvoiceType		=		'MIS' 
						AND			HD.PoNum			LIKE	'PC-%'
						----------
						UNION ALL
						----------
						SELECT
												HD.Company COLLATE Modern_Spanish_CI_AS		AS Company,
												HD.InvoiceNum								AS InvoiceNum,
												HD.GroupID COLLATE Modern_Spanish_CI_AS		AS GroupID,
												CAST(SUBSTRING(HD.PONum COLLATE Modern_Spanish_CI_AS, PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) + 3, LEN(HD.PONum) - PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) - 2) AS int) AS TranNumEncabezado,
												HD.PoNum COLLATE Modern_Spanish_CI_AS AS PoNum,
												HD.Posted,
												HD.LegalNumber COLLATE Modern_Spanish_CI_AS AS LegalNumber
						FROM					[CHILEPIDB].[EpicorPilot11100].dbo.InvcHead HD
						WHERE					
												HD.InvoiceType		=		'MIS' 
						AND						HD.PoNum			LIKE	'PC-%'
		)								H 
ON				E.Company		=		H.Company 
AND				E.TranNum		=		H.TranNumEncabezado	

LEFT JOIN		(
					SELECT		id_evento, id_estado 
					FROM		[dbo].[casos]
					WHERE		id_estado =1
				) C
ON				C.id_evento		=		E.TranNum

LEFT JOIN		(
					SELECT		ID,id_estado  
					FROM		[dbo].[casos_dif_precios]
					WHERE		id_estado=4
				)  DF
ON				DF.id			=		E.TranNum

LEFT JOIN		(
					SELECT		ID,id_estado  
					FROM		[dbo].[casos_acuerdos_comerciales]
					WHERE		id_estado=3
				) AC
ON				AC.id			=		E.TranNum
WHERE			
				E.Estado		<>		'Pendiente'
OR				D.Estado		<>		'Pendiente'

SELECT		id_evento as ID, id_estado 
FROM		[dbo].[casos]
WHERE		id_estado =4

UNION ALL
SELECT		ID,id_estado  
FROM		[dbo].[casos_dif_precios]
WHERE		id_estado=4
UNION ALL
SELECT		ID,id_estado  
FROM		[dbo].[casos_acuerdos_comerciales]
WHERE		id_estado=4

SELECT			E.Company, E.Tipo, E.GroupoAsignado, E.TipoCaso, E.TranNum,
				D.Linea,D.PartNum, D.Estado, E.Eliminado, D.Eliminado
FROM			RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE	E
INNER JOIN		RV.RV_TBL_SIP_DETALLE_COMPROBANTE		D 
ON				E.Company		=		D.Company 
AND				E.TranNum		=		D.TranNum

SELECT		*
FROM		[dbo].[casos]
WHERE		id_estado =1

SELECT * FROM [dbo].[casos_dif_precios]

SELECT * FROM [dbo].[casos_acuerdos_comerciales]

SELECT * FROM rv.RV_TBL_SIP_DETALLE_COMPROBANTE




DECLARE		@TablaTemporal	TABLE	(	
										Company			VARCHAR(10),
										Tipo			VARCHAR(10),
										GroupoAsignado	VARCHAR(50),
										TipoCaso		VARCHAR(20),
										TranNum			INT,
										Linea			INT,
										PartNum			VARCHAR(50),
										Estado			VARCHAR(20),
										EliminadoE		BIT,
										Eliminado		BIT,
										Tabla			VARCHAR(20),
										ID				INT,
										ID_ESTADO		INT,
										Posted			BIT,
										LegalNumber		VARCHAR(50),
										ID_ESTADOC		INT,
										EstadoC			VARCHAR(50)
									)

INSERT INTO @TablaTemporal


SELECT			X.*
				,Y.*
				,H.Posted,
				H.LegalNumber,
				--H.Posted
				CASE
						WHEN 
								X.Estado	=	'Pendiente'
						AND		H.Posted	=	0
						THEN	5
						WHEN 
								X.Estado	=	'Integrado'
						AND		H.Posted	=	0	
						THEN	6
						WHEN
								X.Estado	=	'Integrado'
						AND		H.Posted	=	1
						THEN	8

						--WHEN	X.Estado	NOT IN ('Pendiente','Integrado')
						--THEN	X.Estado

						WHEN	X.Eliminado = 1
						THEN	9
						ELSE    0
				END											AS ID_ESTADOC,
				CASE
						WHEN 
								X.Estado	=	'Pendiente'
						AND		H.Posted	=	0
						THEN	'En Integracion'
						WHEN 
								X.Estado	=	'Integrado'
						AND		H.Posted	=	0	
						THEN	'En posteo'
						WHEN
								X.Estado	=	'Integrado'
						AND		H.Posted	=	1
						THEN	'Finalizado'

						WHEN	X.Estado	NOT IN ('Pendiente','Integrado')
						THEN	X.Estado

						WHEN	X.Eliminado = 1
						THEN	'Eliminado'
				END											AS EstadoC
FROM			(
					SELECT			E.Company, E.Tipo, E.GroupoAsignado, E.TipoCaso, E.TranNum,
									D.Linea,D.PartNum, D.Estado, E.Eliminado AS EliminadoE, D.Eliminado
					FROM			RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE	E
					INNER JOIN		RV.RV_TBL_SIP_DETALLE_COMPROBANTE		D 
					ON				E.Company		=		D.Company 
					AND				E.TranNum		=		D.TranNum
					WHERE			
									E.Estado		<>		'Pendiente'
					OR				D.Estado		<>		'Pendiente'
				)  X
INNER JOIN		(
					SELECT		'casos' AS Tabla, id_evento as ID, id_estado 
					FROM		[dbo].[casos]
					WHERE		id_estado =4

					UNION ALL
					SELECT		'casos_dif_precios' AS Tabla, ID,id_estado  
					FROM		[dbo].[casos_dif_precios]
					WHERE		id_estado=4
					UNION ALL
					SELECT		'casos_acuerdos_comerciales' AS Tabla, ID,id_estado  
					FROM		[dbo].[casos_acuerdos_comerciales]
					WHERE		id_estado=4

				)Y
ON			X.TranNum		=		y.ID
LEFT JOIN (
						SELECT
									HD.Company COLLATE Modern_Spanish_CI_AS		AS Company,
									HD.InvoiceNum								AS InvoiceNum,
									HD.GroupID COLLATE Modern_Spanish_CI_AS		AS GroupID,
									CAST(SUBSTRING(HD.PONum COLLATE Modern_Spanish_CI_AS, PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) + 3, LEN(HD.PONum) - PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) - 2) AS int) AS TranNumEncabezado,
									HD.PoNum COLLATE Modern_Spanish_CI_AS AS PoNum,
									HD.Posted,
									HD.LegalNumber COLLATE Modern_Spanish_CI_AS AS LegalNumber
						FROM		[CORPL11-EPIDB].[EpicorERPTest].dbo.InvcHead HD
						WHERE
									HD.InvoiceType		=		'MIS' 
						AND			HD.PoNum			LIKE	'PC-%'
						----------
						UNION ALL
						----------
						SELECT
												HD.Company COLLATE Modern_Spanish_CI_AS		AS Company,
												HD.InvoiceNum								AS InvoiceNum,
												HD.GroupID COLLATE Modern_Spanish_CI_AS		AS GroupID,
												CAST(SUBSTRING(HD.PONum COLLATE Modern_Spanish_CI_AS, PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) + 3, LEN(HD.PONum) - PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) - 2) AS int) AS TranNumEncabezado,
												HD.PoNum COLLATE Modern_Spanish_CI_AS AS PoNum,
												HD.Posted,
												HD.LegalNumber COLLATE Modern_Spanish_CI_AS AS LegalNumber
						FROM					[CHILEPIDB].[EpicorPilot11100].dbo.InvcHead HD
						WHERE					
												HD.InvoiceType		=		'MIS' 
						AND						HD.PoNum			LIKE	'PC-%'
		)								H 
ON				X.Company		=		H.Company 
AND				X.TranNum		=		H.TranNumEncabezado	

select * from	@TablaTemporal
/*
-- Actualizar la tabla [dbo].[casos]
UPDATE C
SET C.id_estado = T.ID_ESTADOC
FROM dbo.casos AS C
JOIN @TablaTemporal AS T ON C.id_evento = T.ID AND T.Tabla = 'casos'
WHERE C.id_estado = 4;

-- Actualizar la tabla [dbo].[casos_dif_precios]
UPDATE CDP
SET CDP.id_estado = T.ID_ESTADOC
FROM dbo.casos_dif_precios AS CDP
JOIN @TablaTemporal AS T ON CDP.ID = T.ID AND T.Tabla = 'casos_dif_precios'
WHERE CDP.id_estado = 4;

-- Actualizar la tabla [dbo].[casos_acuerdos_comerciales]
UPDATE CAC
SET CAC.id_estado = T.ID_ESTADOC
FROM dbo.casos_acuerdos_comerciales AS CAC
JOIN @TablaTemporal AS T ON CAC.ID = T.ID AND T.Tabla = 'casos_acuerdos_comerciales'
WHERE CAC.id_estado = 4;
*/
-- Verificar el contenido de la tabla temporal
SELECT * FROM @TablaTemporal;

