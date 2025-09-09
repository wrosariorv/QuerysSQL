DECLARE		@TablaTemporal	TABLE	(	
														Company					VARCHAR(10),
														Tipo					VARCHAR(10),
														--GroupoAsignado			VARCHAR(50),
														TipoCaso				VARCHAR(20),
														id_caso					INT,
														--TranNum					INT,
														--Linea					INT,
														--PartNum					VARCHAR(50),
														Estado					VARCHAR(20),
														--EliminadoE				BIT,
														--Eliminado				BIT,														
														id_estado				INT,
														nota_credito_debito		VARCHAR(50),
														Posted					BIT,
														FechaModificacion		datetime,
														LegalNumber				VARCHAR(50),
														New_ID_Estado			INT,
														--EstadoC					VARCHAR(50),
														--Fecha					DATETIME,
														InvoiceNum				INT
													)

				INSERT INTO @TablaTemporal


SELECT							DISTINCT
								Z.Company, 
								Z.Tipo, 
								--Z.GroupoAsignado, 
								Z.TipoCaso,
								Z.id_caso, 
								--Z.TranNum,
								--Z.Linea,
								--Z.PartNum, 
								Z.Estado,
								--Z.EliminadoE, 
								--Z.Eliminado,
								Z.id_estado,
								Z.nota_credito_debito,
								Z.Posted,
								z.FechaModificacion,
								Z.LegalNumber,
								Z.New_ID_Estado,
								--Z.EstadoC,
								--Z.Fecha,
								Z.InvoiceNum
								
				FROM
				
								(
				
								SELECT			X.Company, 
												X.Tipo, 
												--X.GroupoAsignado, 
												X.TipoCaso,
												X.id_caso, 
												X.TranNum,
												--X.Linea,
												--X.PartNum, 
												X.Estado,
												--X.EliminadoE, 
												--X.Eliminado,
												Y.id_estado,
												Y.nota_credito_debito,
												H.Posted,												
												H.LegalNumber,
												
												CASE
														WHEN 
																		X.Estado	=	'Pendiente'
														AND				H.Posted	=	0
														THEN			5
				
														WHEN 
																		X.Estado	=	'Integrado'
														AND				H.Posted	=	0	
														THEN			6
														
														WHEN
																		X.Estado	=	'Integrado'
														AND				H.Posted	=	1
														AND				x.TipoCaso	in ('DP','AC')
														THEN			8

														WHEN
																		X.Estado	=	'Integrado'
														AND				H.Posted	=	1
														AND				x.TipoCaso	in ('SO')
														THEN			12

														WHEN			X.Estado	NOT IN ('Pendiente','Integrado')
														AND				x.TipoCaso	in ('DP','AC')
														OR				(
																			X.Eliminado		=	1
																		OR
																			X.EliminadoE	=	1
																		)
														THEN			9
				
														WHEN			X.Estado	NOT IN ('Pendiente','Integrado')
														AND				x.TipoCaso	in ('SO')
														OR				(
																			X.Eliminado		=	1
																		OR
																			X.EliminadoE	=	1
																		)
														THEN			13
				
														ELSE			0
												END											AS New_ID_Estado,
				
												CASE
														WHEN 
																		X.Estado	=	'Pendiente'
														AND				H.Posted	=	0
														THEN			'En Integracion'
				
														WHEN 
																		X.Estado	=	'Integrado'
														AND				H.Posted	=	0	
														THEN			'En posteo'
				
														WHEN
																		X.Estado	=	'Integrado'
														AND				H.Posted	=	1
														THEN			'Finalizado'
				
														WHEN			X.Estado	NOT IN ('Pendiente','Integrado')
														OR				(
																			X.Eliminado		=	1
																		OR
																			X.EliminadoE	=	1
																		)
														THEN			X.Estado
				
														WHEN			(
																			X.Eliminado		=	1
																		OR
																			X.EliminadoE	=	1
																		)
														THEN			'Eliminado'
														ELSE			'SIN ESTADO'
												END											AS EstadoC,
												GETDATE()									AS Fecha,
												H.InvoiceNum,
												X.FechaModificacion
								FROM			(
													SELECT				E.Company, E.Tipo, E.GroupoAsignado, E.TipoCaso,id_caso, E.TranNum,E.FechaModificacion, 
																		D.Linea,D.PartNum, D.Estado, ISNULL(E.Eliminado,0) AS EliminadoE, ISNULL(D.Eliminado, 0) AS Eliminado
													FROM				RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE	E
													INNER JOIN			RV.RV_TBL_SIP_DETALLE_COMPROBANTE		D 
													ON					E.Company		=		D.Company 
													AND					E.TranNum		=		D.TranNum
													WHERE				
																		E.Estado		<>		'Pendiente'
													OR					D.Estado		<>		'Pendiente'
												)						X
								INNER JOIN		(
													SELECT				'SO' AS Tabla, ID AS id_caso, id_estado , nota_credito_debito, NC_INTERNO
													FROM				[dbo].[casos]
													WHERE				id_estado		in		(12)--(5,6,13)
													AND					NC_INTERNO		IS NULL
													UNION ALL
				
													SELECT				'DP' AS Tabla, ID AS id_caso, id_estado  , nota_credito_debito, NC_INTERNO
													FROM				[dbo].[casos_dif_precios]
													WHERE				id_estado		in		(8)--(5,6,9)
													AND					NC_INTERNO		IS NULL
													UNION ALL
													
													SELECT				'AC' AS Tabla, ID AS id_caso, id_estado , nota_credito_debito, NC_INTERNO 
													FROM				[dbo].[casos_acuerdos_comerciales]
													WHERE				id_estado		in		(8)--(5,6,9)
													AND					NC_INTERNO		IS NULL
												)						Y
								ON				X.TipoCaso		=		Y.Tabla
								AND				X.id_caso		=		y.id_caso
								LEFT JOIN (
													SELECT
																HD.Company COLLATE Modern_Spanish_CI_AS		AS Company,
																HD.InvoiceNum								AS InvoiceNum,
																HD.GroupID COLLATE Modern_Spanish_CI_AS		AS GroupID,
																CAST(SUBSTRING(HD.PONum COLLATE Modern_Spanish_CI_AS, PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) + 3, LEN(HD.PONum) - PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) - 2) AS int) AS TranNumEncabezado,
																HD.PoNum COLLATE Modern_Spanish_CI_AS AS PoNum,
																HD.Posted,
																HD.LegalNumber COLLATE Modern_Spanish_CI_AS AS LegalNumber
													FROM		[CORPE11-EPIDB].[EpicorERP].dbo.InvcHead HD
													WHERE
																HD.InvoiceType		=		'MIS' 
													AND			HD.PoNum			LIKE	'PC-%'
													AND			HD.EntryPerson		='Usr_TRANSFER'
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
													FROM					[CHILEPIDB].[EpicorLive11100].dbo.InvcHead HD
													WHERE					
																			HD.InvoiceType		=		'MIS' 
													AND						HD.PoNum			LIKE	'PC-%'
													AND						HD.EntryPerson		='Usr_TRANSFER'
										)								H 
								ON				X.Company		=		H.Company 
								AND				X.TranNum		=		H.TranNumEncabezado
				
								)  Z 
				
				--LEFT OUTER JOIN		(
				--						SELECT		Company, Tipo, GroupoAsignado, TipoCaso, id_caso, TranNum, Linea, PartNum, New_ID_Estado
				--						FROM		[RV].[RV_TBL_SIP_JOB_ACTUALIZA_ESTADO_PC]	J					
				--						GROUP BY	Company, Tipo, GroupoAsignado, TipoCaso, id_caso, TranNum, Linea, PartNum, New_ID_Estado
				--					) J
				--ON				Z.Company			=		J.Company
				--AND				Z.TranNum			=		J.TranNum
				--AND				Z.PartNum			=		J.PartNum
				--AND				Z.New_ID_Estado		=		J.New_ID_Estado
				--/*
				WHERE
								/*J.New_ID_Estado IS NULL
				AND				Z.New_ID_Estado		<>		0
				AND				*/Z.INVOICEnUM		IS NOT NULL
				--and				z.Posted		=1
				--and				LEFT(z.Tipo, 2) = LEFT(z.LegalNumber, 2)
				--*/
				/*AND				CAST (Fecha AS date) >'2024-09-18'
				AND				*/--TranNum  in (268,269,270,271,274,275,298,299,300,301)
				--TranNum		in (311,320,316,323,308,306,321,312,323,302,315,303,305,318,310,314,304,309,319,317,322,307,313)
				
				--ORDER BY		X.Company,X.TranNum,X.Linea,X.PartNum desc
				--IF EXISTS (SELECT 1 FROM @TablaTemporal)
				--SELECT * FROM @TablaTemporal
	--BEGIN
					/* Insertar los datos en la tabla física
					INSERT INTO [RV].[RV_TBL_SIP_JOB_ACTUALIZA_ESTADO_PC]
					SELECT		* 
					FROM 		@TablaTemporal
				
					--*/
			/*********************************************************************************
			*********************************ACTUALIZA TABLAS*********************************
			**********************************************************************************/
			BEGIN TRANSACTION;
					--/*
					/***** Actualizar la tabla [dbo].[casos]*****/
					UPDATE C
					SET				
									C.NC_INTERNO						=		CASE
																						WHEN		T.New_ID_Estado	=	12 
																						THEN		T.InvoiceNum 
																						ELSE		C.NC_INTERNO
																				END						
					FROM			dbo.casos							AS C
					JOIN			@TablaTemporal						AS T 
					ON				C.ID								=		T.id_caso 
					AND				T.TipoCaso							=		'SO'
					WHERE			C.id_estado							>=		4

					/***** Actualizar la tabla [dbo].[casos_dif_precios]*****/
					UPDATE CDP
					SET				
									CDP.NC_INTERNO						=		CASE
																						WHEN		T.New_ID_Estado	=	8 
																						THEN		T.InvoiceNum 
																						ELSE		CDP.NC_INTERNO
																				END

					FROM			dbo.casos_dif_precios				AS CDP
					JOIN			@TablaTemporal						AS T 
					ON				CDP.ID								=		T.id_caso 
					AND				T.TipoCaso							=		'DP'
					WHERE			CDP.id_estado						>=		4

					/***** Actualizar la tabla [dbo].[casos_acuerdos_comerciales]*****/
					UPDATE CAC
					SET				
									CAC.NC_INTERNO						=		CASE
																						WHEN		T.New_ID_Estado	=	8 
																						THEN		T.InvoiceNum 
																						ELSE		CAC.NC_INTERNO
																				END
					FROM			dbo.casos_acuerdos_comerciales		AS CAC
					JOIN			@TablaTemporal						AS T 
					ON				CAC.ID								=		T.id_caso 
					AND				T.TipoCaso							=		'AC'
					WHERE			CAC.id_estado						>=		3
					--*/
				
					/****Verificar el contenido de la tabla temporal*****/
					/*

					SELECT		* 
					FROM 		@TablaTemporal

					--*/

			--COMMIT TRANSACTION;
			/*********************************************************************************
			**********************************************************************************
			**********************************************************************************/


	SELECT				'SO' AS Tabla, ID AS id_caso, id_estado , nota_credito_debito, NC_INTERNO
	FROM				[dbo].[casos]
	WHERE				id_estado		in		(12)--(5,6,13)
	AND					NC_INTERNO		IS NULL
	UNION ALL
				
	SELECT				'DP' AS Tabla, ID AS id_caso, id_estado  , nota_credito_debito, NC_INTERNO
	FROM				[dbo].[casos_dif_precios]
	WHERE				id_estado		in		(8)--(5,6,9)
	AND					NC_INTERNO		IS NULL
	UNION ALL
													
	SELECT				'AC' AS Tabla, ID AS id_caso, id_estado , nota_credito_debito, NC_INTERNO 
	FROM				[dbo].[casos_acuerdos_comerciales]
	WHERE				id_estado		in		(8)--(5,6,9)
	AND					NC_INTERNO		IS NULL

	--ROLLBACK TRANSACTION