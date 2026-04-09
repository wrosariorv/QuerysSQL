USE [SIG-CD]
GO

/****** Object:  StoredProcedure [dbo].[PRC_DESP_SELECT_OV_PLANTA_EMPRESA]    Script Date: 24/12/2025 08:51:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- [dbo].[PRC_DESP_SELECT_OV_PLANTA_EMPRESA] busca los datos de una OV indicada
-- Retorna 'NO_EXISTE_EPICOR' si la OV no existe en la DB de Epicor
-- Retorna 'ERROR_SK' si la OV indicada corresponde a un SK de un AA
-- Retorna 'NO_DISP_CERRADA' si la OV está cerrada
-- Retorna 'ASIGNADA_A_OTRA_Usuario' si la OV está tomada por otra Usuario
-- Retorna 'NO_DISP_EPICOR' y el empaque si la OV ya está despachada
-- Retorna 'ERROR_PLANTA' si la planta de la OrderRel y OrderPicekd no coinciden, en caso de ser AC evalua todo el kit (SK,UE y UI)
--/*

ALTER PROCEDURE	[dbo].[PRC_DESP_SELECT_OV_PLANTA_EMPRESA]			@Company		NVARCHAR(8)
																	,@Plant			NVARCHAR(8)
																	,@OrderNum		INT
																	,@OrderLine		INT
																	,@OrderRelNum	INT
																	,@Usuario		NVARCHAR(50) 
AS

--*/
/*
DECLARE																@Company		NVARCHAR(8) = 'CO01' 
																	,@Plant			NVARCHAR(8)	= 'CDEE'
																	,@OrderNum		INT			= 286027
																	,@OrderLine		INT		    = 2
																	,@OrderRelNum	INT         = 1
																	,@Usuario		NVARCHAR(50) 
																	
--*/
DECLARE @IdUsuario INT = 0,
		@Estado VARCHAR(50) = '',
		@PackNum INT = 0



--Busco el Id de la Usuario en base a su Usuario
SET @IdUsuario = (SELECT IdUsuarioCD FROM [SIGSeguridad].dbo.Usuario WHERE NombreUsuario = @Usuario)




IF EXISTS	(
				SELECT			1
				FROM			[CORPE11-EPIDB].EpicorErp.Erp.PickedOrders			PO			WITH(NoLock)
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.Customer				C			WITH(NoLock)
					ON			PO.Company			=			C.Company
					AND			PO.CustNum			=			C.CustNum 
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.OrderHed				OH			WITH(NoLock)
					ON			PO.Company			=			OH.Company
					AND			PO.OrderNum			=			OH.OrderNum
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.OrderDtl				OD			WITH(NoLock)
					ON			PO.Company			=			OD.Company
					AND			PO.OrderNum			=			OD.OrderNum
					AND			PO.OrderLine		=			OD.OrderLine 
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.Part					P			WITH(NoLock)
					ON			PO.Company			=			P.Company
					AND			PO.PartNum			=			P.PartNum
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.PartPlant			PP			WITH(NoLock)
					ON			PO.Company			=			PP.Company
					AND			PO.PartNum			=			PP.PartNum
					AND			PO.Plant			=			PP.Plant
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.PlantWhse			PW			WITH(NoLock)
					ON			PO.Company			=			PW.Company
					AND			PO.PartNum			=			PW.PartNum
					AND			PO.Plant			=			PW.Plant
					AND			PO.WareHouseCode	=			PW.WareHouseCode
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.Company				Co			WITH(NoLock)
					ON			PO.Company			=			Co.Company
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.Plant				Pl			WITH(NoLock)
					ON			PO.Company			=			Pl.Company
					AND			PO.Plant			=			Pl.Plant
				----------------------------------------------------------------------
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.PlantConfCtrl		PCC
					ON			PO.Company			=			PCC.Company
					AND			PO.Plant			=			PCC.Plant
				----------------------------------------------------------------------
				WHERE			PO.Company			=			@Company
					AND			PO.Plant			=			@Plant
					AND			PO.OrderNum			=			@OrderNum
					AND			PO.OrderLine		=			@OrderLine
					AND			PO.OrderRelNum		=			@OrderRelNum
			)
BEGIN
	IF EXISTS(
				SELECT			1
				FROM			[CORPE11-EPIDB].EpicorErp.Erp.PickedOrders			PO			WITH(NoLock)
				INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.Part					P			WITH(NoLock)
					ON			PO.Company			=			P.Company
					AND			PO.PartNum			=			P.PartNum
				WHERE			PO.Company			=			@Company
					AND			PO.Plant			=			@Plant
					AND			PO.OrderNum			=			@OrderNum
					AND			PO.OrderLine		=			@OrderLine
					AND			PO.OrderRelNum		=			@OrderRelNum
					AND			P.TypeCode			=			'K'
				)
	BEGIN
		SET @Estado = 'ERROR_SK'		
	END
	IF EXISTS(
				SELECT *
				FROM (
						/* ===== B2: ya tiene AnchorLine + agregados por grupo ===== */
						SELECT
									B1.*,
									/* grupo: todas las líneas del mismo AC comparten AnchorLine.
									   Si no es AC, el grupo es la propia OrderLine */
									MIN(CASE WHEN B1.IsSK = 0 THEN B1.Plant  END) OVER (
									  PARTITION BY B1.Company, B1.OrderNum, ISNULL(B1.AnchorLine, B1.OrderLine)
									) AS MinPlantGrp,

									MAX(CASE WHEN B1.IsSK = 0 THEN B1.Plant  END) OVER (
									  PARTITION BY B1.Company, B1.OrderNum, ISNULL(B1.AnchorLine, B1.OrderLine)
									) AS MaxPlantGrp,

									MIN(CASE WHEN B1.IsSK = 0 AND B1.Planta IS NOT NULL THEN B1.Planta END) OVER (
									  PARTITION BY B1.Company, B1.OrderNum, ISNULL(B1.AnchorLine, B1.OrderLine)
									) AS MinPlantaGrp,

									MAX(CASE WHEN B1.IsSK = 0 AND B1.Planta IS NOT NULL THEN B1.Planta END) OVER (
									  PARTITION BY B1.Company, B1.OrderNum, ISNULL(B1.AnchorLine, B1.OrderLine)
									) AS MaxPlantaGrp,

									
									CASE
										WHEN
											MIN(B1.Plant) OVER (
												PARTITION BY B1.Company, B1.OrderNum, ISNULL(B1.AnchorLine, B1.OrderLine)
											) <>
											MAX(B1.Plant) OVER (
												PARTITION BY B1.Company, B1.OrderNum, ISNULL(B1.AnchorLine, B1.OrderLine)
											)
										THEN 1 ELSE 0
									END AS SKPlantMismatch


									


						FROM (
									/* ===== B1: calcula AnchorLine (kit AA) ===== */
									SELECT
										B0.*,
										MAX(B0.AnchorLineSelf) OVER (
											PARTITION BY B0.Company, B0.OrderNum
											ORDER BY B0.OrderLine
											ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
										) AS AnchorLine
									FROM (
										/* ===== B0: joins base + marca ancla (AA-SPLIT + SK%) ===== */
										SELECT
												REL.Company,
												REL.Plant,              -- planta del REL
												PO.Plant      AS Planta,-- planta de PickedOrders
												REL.OrderNum,
												REL.OrderLine,
												REL.OrderRelNum,
												ART.CodigoCategoria,
												ART.ClassID,
												CASE 
													WHEN ART.CodigoCategoria = 'AA-SPLIT'
													 AND ART.ClassID       LIKE 'SK%'
													THEN OD.OrderLine
													ELSE NULL
												END AS AnchorLineSelf,
												CASE 
												  WHEN ART.CodigoCategoria = 'AA-SPLIT'
												   AND ART.ClassID LIKE 'SK%'
												  THEN 1 ELSE 0
												END AS IsSK
										FROM    [CORPE11-EPIDB].EpicorErp.Erp.OrderHed     OH  WITH (NOLOCK)
										INNER JOIN [CORPE11-EPIDB].EpicorErp.Erp.OrderDtl  OD  WITH (NOLOCK)
												ON  OH.Company   = OD.Company
												AND OH.OrderNum  = OD.OrderNum
										LEFT JOIN [CORPE11-EPIDB].EpicorErp.Erp.OrderRel   REL WITH (NOLOCK)
												ON  OD.Company   = REL.Company
												AND OD.OrderNum  = REL.OrderNum
												AND OD.OrderLine = REL.OrderLine
										LEFT JOIN [CORPE11-SSRS].[RVF_Local].dbo.RVF_VW_MOVI_ARTICULOS ART
												ON  OD.Company   = ART.Compania
												AND OD.PartNum   = ART.CodigoArticulo
										LEFT JOIN [CORPE11-EPIDB].EpicorErp.Erp.PickedOrders PO WITH (NOLOCK)
												ON  REL.Company  = PO.Company
												AND  REL.OrderNum  = PO.OrderNum
												AND  REL.OrderLine = PO.OrderLine
										WHERE   REL.Company		= @Company
										  AND   REL.OrderNum	= @OrderNum
							) AS B0
					) AS B1
				) AS B2
				WHERE   B2.Company   = @Company
				  AND   B2.OrderNum  = @OrderNum
				  AND   B2.OrderLine = @OrderLine     -- línea que estás validando
				  AND   B2.OrderRelNum = @OrderRelNum
				  AND   B2.AnchorLine IS NOT NULL      -- sólo aplica a kits AA (AC)
				  AND (
							(
									B2.MinPlantaGrp IS NOT NULL
								AND 
									B2.MaxPlantaGrp IS NOT NULL
								AND 
									B2.MinPlantaGrp <> B2.MaxPlantaGrp
							)
							OR
								B2.SKPlantMismatch = 1
						)           -- hay plantas/planta distintas en el kit

				)
	BEGIN
		SET @Estado = 'ERROR_PLANTA'		
	END
	ELSE
	BEGIN
		--Si la OV existe en Epicor y no es SK, me fijo si ya está cerrada en la BD.
		IF EXISTS	(
						SELECT			1
						FROM			dbo.Ordenes
						WHERE			Company = @Company
										AND Plant = @Plant
										AND OrderNum = @OrderNum
										AND OrderLine = @OrderLine
										AND OrderRelNum = @OrderRelNum
										AND FechaInicio IS NOT NULL
										AND FechaFin IS NOT NULL
					)
		BEGIN
			--Si está cerrada, devuelvo NO_DISP_CERRADA como estado de la OV
			SET @Estado = 'NO_DISP_CERRADA'				
		END
		ELSE
		BEGIN
			--Si no está cerrada la OV, me fijo si la orden ya está asignada en la BD
			--para otra Usuario
			IF EXISTS	(
								SELECT			1
								FROM			dbo.Ordenes
								WHERE			Company = @Company
												AND Plant = @Plant
												AND OrderNum = @OrderNum
												AND OrderLine = @OrderLine
												AND OrderRelNum = @OrderRelNum
												AND IdUsuario <> @IdUsuario
						)
			BEGIN
					--Si está asignada a otra Usuario, devuelvo el estado NO_DISP_PROCESAMIENTO y
					--el Id de la Usuario que tiene abierta la OV
					SELECT			@Usuario = TER.NombreUsuario
									, @IdUsuario = ORD.idUsuario
									, @Estado = 'ASIGNADA_A_OTRO_USUARIO'
					FROM			dbo.Ordenes ORD
					INNER JOIN		[SIGSeguridad].dbo.Usuario TER
					ON				ORD.idUsuario = TER.IdUsuarioCD
					WHERE			Company = @Company
									AND Plant = @Plant
									AND OrderNum = @OrderNum
									AND OrderLine = @OrderLine
									AND OrderRelNum = @OrderRelNum
			END
			ELSE
			BEGIN
					--Si no está asignada a otra Usuario, devuelvo todos los datos de la OV,
					--y el estado OK
				--EXEC dbo.PRC_DATOS_OV_EPICOR @Company, @Plant, @OrderNum, @OrderLine, @OrderRelNum

				IF EXISTS	(
					SELECT		1
					FROM		[CORPE11-EPIDB].EpicorErp.Erp.OrderDtl
					WHERE		Company = @Company
					AND			OrderNum = @OrderNum
					AND			OrderLine = @OrderLine
					AND			VoidLine = 1
				)
				BEGIN
					--Si no existe en Epicor, devuelvo el estado NO_DISP_EPICOR, y el empaque asociado a la orden
					--SELECT 'NO_DISP_EPICOR' AS Estado
					SET @Estado = 'NO_DISP_EPICOR_ANULADA'
				END
				ELSE
				BEGIN
					SET @Estado = 'OK'
				END
			END
		END
	END
END
ELSE
BEGIN
	IF EXISTS	(
					SELECT		PackNum
					FROM		[CORPE11-EPIDB].EpicorErp.Erp.ShipDtl
					WHERE		Company = @Company
					AND			Plant = @Plant
					AND			OrderNum = @OrderNum
					AND			OrderLine = @OrderLine
					AND			OrderRelNum = @OrderRelNum
				)
	BEGIN
		--Si no existe en Epicor, devuelvo el estado NO_DISP_EPICOR, y el empaque asociado a la orden
		--SELECT 'NO_DISP_EPICOR' AS Estado
		SELECT		@PackNum = PackNum
					, @Estado = 'NO_DISP_EPICOR'
		FROM		[CORPE11-EPIDB].EpicorErp.Erp.ShipDtl			WITH (NoLock)
		WHERE		Company = @Company
		AND			Plant = @Plant
		AND			OrderNum = @OrderNum
		AND			OrderLine = @OrderLine
		AND			OrderRelNum = @OrderRelNum
	END
	ELSE
	BEGIN
		SET @Estado = 'NO_EXISTE_EPICOR'
	END
END

SELECT @Estado AS Estado, @PackNum as PackNum, @Usuario as Usuario, @IdUsuario as IdUsuario





GO


