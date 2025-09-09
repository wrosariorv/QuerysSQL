USE [WS]
GO

/*
ALTER PROCEDURE [AS].[RVF_PRC_SIG_VALIDA_SERIES_OLD]
AS
--*/


	DECLARE @InfoPart AS TABLE			( 
											[Company][VARCHAR](10) COLLATE SQL_Latin1_General_CP1_CI_AS,
											[Plant][VARCHAR](20) COLLATE SQL_Latin1_General_CP1_CI_AS,
											[PartNum][VARCHAR](50) COLLATE SQL_Latin1_General_CP1_CI_AS,
											[WarehouseCode][varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS, 
											[BinNum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS
										)

	INSERT INTO			@InfoPart	
	

			/******************************************************************
				Busca los  WarehouseCode y BinNun disponible para la Parte
			******************************************************************/
 
			SELECT			DISTINCT
							PW.Company,W.Plant , PW.PartNum, PW.WarehouseCode, 
							WB.BinNum 
							
			FROM			[CORPL11-EPIDB].[EpicorERPTest].Erp.PartWhse		PW
			INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.WhseBin			WB
				ON			PW.Company				=					WB.Company
				AND			PW.WarehouseCode		=					WB.WarehouseCode
			INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Warehse			W
				ON			PW.Company				=					W.Company
				AND			PW.WarehouseCode		=					W.WarehouseCode
			INNER JOIN		(
								SELECT		*
								FROM		WS.[AS].RV_TBL_SIP_ACTUALIZA_SERIE
								WHERE		Estado ='Pendiente'
							)	AS Y
 
			ON				PW.Company				=					Y.Company
			AND				W.Plant					=					Y.Plant
			AND				PW.PartNum				=					Y.PartNum
			--AND				PW.WarehouseCode		=					Y.Warehouse
			--AND				WB.BinNum				=					Y.BinNum



		


Select * from (

											SELECT				ISNULL(W.GroupID, '') as GroupID,ISNULL(W.Compania, '') as Company, ISNULL(W.Planta, '') as Plant, ISNULL(W.CodigoProducto, '') as PartNum, ISNULL(W.SerialNumberActualizar, '') as SerialNumberActualizar, ISNULL(W.SerialNumber, '') as SerialNumber,
																ISNULL(W.SNStatus, '') as SNStatus, ISNULL(W.Almacen, '') as WareHouseCode, ISNULL(W.Deposito, '') as BinNum, ISNULL(W.Letra, '') as Letra ,ISNULL(W.Voided, 0) as Voided , 
										
																	/******************************************************************************
																	Se verifica que la planta, estado, usuario, almacen y ubicacion sean correctos
																	******************************************************************************/

																CASE
																	WHEN	W.Company										<>					W.Compania
																		THEN																	1
																	WHEN	(	w.SerialNumber							IS NULL
																				OR
																				W.SerialNumber									<>					W.SerialNumberActualizar

																			)
																		THEN																	1
																	WHEN	W.PartNum										is null
																		THEN																	1
																	--WHEN	W.PartNum										<>					W.PartNum
																	--	THEN																	1
																	WHEN	W.Voided										=					1
																		THEN																	1
																	
																	WHEN	W.SNStatus										NOT IN				('INVENTORY')
																		THEN		1
																	--Valido que warehouse y binNum correpondan al 
																	WHEN	W.WareHouseCode									is null						
																		THEN		1
																	WHEN	W.BinNum										is null						
																		THEN		1

																	WHEN	(
																				W.Plant											is null
																				OR
																				W.Plant											<>					W.Planta
																			)
																		THEN		1
																	WHEN	W.CodeID										<>					W.Letra							
																		THEN		1

																	
																	ELSE																		0
																END
									

																	AS		'Error',
																/******************************************************************************
																******************************************************************************/
																/******************************************************************************
																Se Detalla el error la planta, estado, usuario, almacen y ubicacion sean correctos
																******************************************************************************/
																CASE
																	WHEN	W.Company										<>					W.Compania
																		THEN																	'La compañia '+ W.Compania+' no existe'
																	WHEN	(	
																				w.SerialNumber							IS NULL
																				OR
																				W.SerialNumber									<>					W.SerialNumberActualizar

																			)
																		THEN																	'la Serie '+ W.SerialNumberActualizar+' no existe'
																	WHEN	W.PartNum										is null
																		THEN																	'La parte '+ W.CodigoProducto+' no existe para la company '+ W.Compania+''
																	WHEN	W.PartNum										<>					W.PartNum
																		THEN																	'La serie '+ W.SerialNumberActualizar+' no corresponde a la parte'+ W.CodigoProducto+''
																	WHEN	W.Voided										=					1
																		THEN																	'La serie '+ W.SerialNumberActualizar+'esta anulada'
																	
																	WHEN	W.SNStatus										NOT IN				('INVENTORY')
																		THEN																	'El Estado de la serie '+ W.SerialNumberActualizar+' no es Inventory'
																	--Valido que warehouse y binNum correpondan al 
																	WHEN	W.WareHouseCode									is null						
																		THEN																	'El WarehouseCode '+ W.Almacen +' de la serie '+ W.SerialNumberActualizar+' no esta disponible en la planta '+W.Planta
																	WHEN	W.BinNum										is null						
																		THEN																	'El BinNun '+ W.Deposito +' de la serie '+ W.SerialNumberActualizar+' no esta disponible en el almacen '+W.Almacen	

																	WHEN	(
																				W.Plant											is null
																				OR
																				W.Plant											<>					W.Planta
																			)
																		THEN																	'La planta '+ W.Planta+' no corresponde a la company '+ W.Compania+' y parte '+ W.CodigoProducto+' '
																	WHEN	W.CodeID										<>					W.Letra							
																		THEN																	'La letra '+ W.CodeID+' no existe'

																	
																	ELSE																		''
																END
																
																

																	AS		'DetalleError'
																/******************************************************************************
																******************************************************************************/
											FROM				(
											
																		SELECT				DISTINCT
																							Y.GroupID, CO.Company, Y.Company as Compania , Y.PartNum AS CodigoProducto, P.PartNum, Y.SerialNumber AS SerialNumberActualizar, SN.SerialNumber,
																							SN.SNStatus, Y.WareHouse AS Almacen, PW.WareHouseCode, Y.BinNum AS Deposito, WB.BinNum, SN.Voided
																							--W.Plant, Panta Origen
																							,Y.Plant AS Planta,/*PL.Plant,*/ W.PLANT	--Planta Destino
																							,Y.Letra
																							,UD.Character02 --Letra Outlet
																							,L.CodeID --Letra Outlet
																		FROM				
																							(
																								SELECT		*
																								FROM		WS.[AS].RV_TBL_SIP_ACTUALIZA_SERIE
																								WHERE		Estado ='Pendiente'
																							)	AS Y
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].Erp.Company								CO		WITH(NoLock)
																		ON					CO.Company					=						Y.Company
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].Erp.Plant								PL		WITH(NoLock)
																			ON				PL.Company					=						Y.Company
																			AND				PL.Plant					=						Y.Plant
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].Erp.Part								P		WITH(NoLock)
																			ON				P.Company					=						Y.Company
																			AND				P.PartNum					=						Y.PartNum
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].Erp.SerialNo							SN		WITH(NoLock)
																			ON				SN.Company					=						Y.Company
																			AND				SN.PartNum					=						Y.PartNum																			
																			AND				SN.SerialNumber				=						Y.SerialNumber
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].ERP.SerialNo_UD							UD		WITH (NoLock)
																			ON				SN.SysRowID					=						UD.ForeignSysRowID
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].Erp.PartWhse							PW		WITH (NoLock)
																			ON				PW.Company					=						Y.Company
																			AND				PW.WarehouseCode			=						Y.Warehouse
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].Erp.WhseBin								WB
																			ON				Y.Company					=						WB.Company
																			AND				Y.Warehouse					=						WB.WarehouseCode
																			AND				Y.BinNum					=						WB.BinNum
																		LEFT JOIN			[CORPL11-EPIDB].[EpicorERPTest].Erp.Warehse								W
																			ON				Y.Company					=						W.Company
																			AND				Y.Warehouse					=						W.WarehouseCode
																		/*
																		LEFT JOIN			(
																								SELECT			* 
																								FROM			@InfoPart						
																								
																							)	AS T
																			ON				Y.Company					=					T.Company
																			AND				Y.PartNum					=					T.PartNum
																			AND				Y.Plant						=					T.Plant
																			AND				Y.WareHouse					=					T.WarehouseCode
																			AND				Y.BinNum					=					T.BinNum*/
																		LEFT JOIN			(
																								SELECT	Company, CodeID
																								FROM	[CORPL11-EPIDB].[EpicorERPTest].ICE.UDCodes
																								WHERE	
																										CodeTypeID='CatOutlet'
																								and		IsActive=1
																							)	AS L
																			ON				SN.Company					=					L.Company
																			AND				Y.Letra						=					L.CodeID
																			--AND				SN.BinNum					=					Y.BinNum
																	--Order by Y.GroupID, Y.Company, Y.PartNum, Y.SerialNumber
																	)	W


									)X


GO


