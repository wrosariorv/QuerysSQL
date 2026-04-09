USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_DESP_SIG_ESTADO_ORDENES]    Script Date: 4/2/2026 11:59:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- [dbo].[ELIMINAR_SERIE_DE_OV] elimina un serie indicado para una parte undicada, de una orden indicada
-- Retorna "OK" si el serie fue eliminado con éxito
/*
ALTER PROCEDURE	[dbo].[RVF_PRC_DESP_SIG_ESTADO_ORDENES]			@Company		NVARCHAR(8),
																@Plant			NVARCHAR(8),
																@OrderNum		INT,
																@OrderLine		INT = 0,
																@OrderRelNum	INT = 0
AS
*/
---------------------------------------
-- Si no ingreso línea ni liberación
---------------------------------------

IF @OrderLine = 0 AND @OrderRelNum = 0
BEGIN
				SELECT			O.[Company]
								,O.[Plant]
								,O.[OrderNum]
								,O.[OrderLine]
								,O.[OrderRelNum]
								,[FechaInicio]
								,[FechaFin]
								,U.[Nombre] + ' '+ U.[Apellido]				AS	Usuario
								,[FechaDespacho]
								,[Archivo]
								,[EmpaqueProvisorio]
								,ISNULL(S.PackNum,'')	AS	EmpaqueDefinitivo
								,O.Cantidad
			FROM			[CORPSQLMULT2019].[SIG-CD].[dbo].[Ordenes]		O
			LEFT JOIN		[CORPSQLMULT2019].[SIGSeguridad].[dbo].[Usuario]	U
			ON				O.[IdUsuario] = U.[IdUsuarioCD]

			------ TRAIGO EL EMPAQUE DEFINITIVO -------

			LEFT JOIN	[CORPE11-EPIDB].EpicorErp.Erp.ShipDtl										S WITH (NoLock)
			ON			O.Company		=	S.Company		COLLATE database_default
				AND		O.Plant			=	S.Plant			COLLATE database_default
				AND		O.OrderNum		=	S.OrderNum		
				AND		O.OrderLine		=	S.OrderLine		
				AND		O.OrderRelNum	=	S.OrderRelNuM	

			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				AND			O.OrderNum		=	@OrderNum

	--- Agrego las órdenes eliminadas ---
	-------------------------------------
		UNION
	-------------------------------------
	-------------------------------------
			SELECT		  [Company]
						  ,[Plant]
						  ,[OrderNum]
						  ,[OrderLine]
						  ,[OrderRelNum]
						  ,[FechaInicio]
						  ,[FechaFin]
						  ,U.[Nombre] + ' ' + U.[Apellido]				AS	Usuario
						  ,NULL						AS	FechaDespacho
						  ,'Eliminado'				AS	Archivo
						  ,0						AS	EmpaqueProvisorio
						  ,0						AS	EmpaqueDefinitivo
						  ,0						AS	Cantidad
			FROM			[CORPSQLMULT2019].[SIG-CD].[dbo].[Ordenes_borradas]		O
			LEFT JOIN		[CORPSQLMULT2019].[SIGSeguridad].[dbo].[Usuario]	U
			ON				O.[IdUsuario] = U.[IdUsuarioCD]
			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				AND			O.OrderNum		=	@OrderNum

END

ELSE
---------------------------------------
-- Si no ingreso libearación
---------------------------------------
	IF @OrderRelNum = 0
		BEGIN
				SELECT			O.[Company]
								,O.[Plant]
								,O.[OrderNum]
								,O.[OrderLine]
								,O.[OrderRelNum]
								,[FechaInicio]
								,[FechaFin]
								,U.[Nombre] + ' ' + U.[Apellido]				AS	Usuario
								,[FechaDespacho]
								,[Archivo]
								,[EmpaqueProvisorio]
								,ISNULL(S.PackNum,'')	AS	EmpaqueDefinitivo
								,O.Cantidad
			FROM			[CORPSQLMULT2019].[SIG-CD].[dbo].[Ordenes]		O
			LEFT JOIN		[CORPSQLMULT2019].[SIGSeguridad].[dbo].[Usuario]	U
			ON				O.[IdUsuario] = U.[IdUsuarioCD]

			------ TRAIGO EL EMPAQUE DEFINITIVO -------

			LEFT JOIN	[CORPE11-EPIDB].EpicorErp.Erp.ShipDtl										S WITH (NoLock)
			ON			O.Company		=	S.Company		COLLATE database_default
				AND		O.Plant			=	S.Plant			COLLATE database_default
				AND		O.OrderNum		=	S.OrderNum		
				AND		O.OrderLine		=	S.OrderLine		
				AND		O.OrderRelNum	=	S.OrderRelNuM	

			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				AND			O.OrderNum		=	@OrderNum
				AND			O.OrderLine		=	@OrderLine

	--- Agrego las órdenes eliminadas ---
	-------------------------------------
		UNION
	-------------------------------------
	-------------------------------------
			SELECT		  [Company]
						  ,[Plant]
						  ,[OrderNum]
						  ,[OrderLine]
						  ,[OrderRelNum]
						  ,[FechaInicio]
						  ,[FechaFin]
						  ,U.[Nombre] + ' ' + U.[Apellido]				AS	Usuario
						  ,NULL						AS	FechaDespacho
						  ,'Eliminado'				AS	Archivo
						  ,0						AS	EmpaqueProvisorio
						  ,0						AS	EmpaqueDefinitivo
						  ,0						AS	Cantidad
			FROM			[CORPSQLMULT2019].[SIG-CD].[dbo].[Ordenes_borradas]		O
			LEFT JOIN		[CORPSQLMULT2019].[SIGSeguridad].[dbo].[Usuario]	U
			ON				O.[IdUsuario] = U.[IdUsuarioCD]
			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				AND			O.OrderNum		=	@OrderNum
				AND			O.OrderLine		=	@OrderLine

		END


	ELSE

---------------------------------------
-- Si ingreso todos los datos
---------------------------------------
		BEGIN
				SELECT			O.[Company]
								,O.[Plant]
								,O.[OrderNum]
								,O.[OrderLine]
								,O.[OrderRelNum]
								,[FechaInicio]
								,[FechaFin]
								,U.[Nombre] + ' ' + U.[Apellido]				AS	Usuario
								,[FechaDespacho]
								,[Archivo]
								,[EmpaqueProvisorio]
								,ISNULL(S.PackNum,'')							AS	EmpaqueDefinitivo
								,O.Cantidad
			FROM			[CORPSQLMULT2019].[SIG-CD].[dbo].[Ordenes]		O
			LEFT JOIN		[CORPSQLMULT2019].[SIGSeguridad].[dbo].[Usuario]	U
			ON				O.[IdUsuario] = U.[IdUsuarioCD]

			------ TRAIGO EL EMPAQUE DEFINITIVO -------

			LEFT JOIN	[CORPE11-EPIDB].EpicorErp.Erp.ShipDtl										S WITH (NoLock)
			ON			O.Company		=	S.Company		COLLATE database_default
				AND		O.Plant			=	S.Plant			COLLATE database_default
				AND		O.OrderNum		=	S.OrderNum		
				AND		O.OrderLine		=	S.OrderLine		
				AND		O.OrderRelNum	=	S.OrderRelNuM	

			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				AND			O.OrderNum		=	@OrderNum
				AND			O.OrderLine		=	@OrderLine
				AND			O.OrderRelNum	=	@OrderRelNum

	--- Agrego las órdenes eliminadas ---
	-------------------------------------
		UNION
	-------------------------------------
	-------------------------------------
			SELECT		  [Company]
						  ,[Plant]
						  ,[OrderNum]
						  ,[OrderLine]
						  ,[OrderRelNum]
						  ,[FechaInicio]
						  ,[FechaFin]
						  ,U.[Nombre] + ' ' + U.[Apellido]				AS	Usuario
						  ,NULL						AS	FechaDespacho
						  ,'Eliminado'				AS	Archivo
						  ,0						AS	EmpaqueProvisorio
						  ,0						AS	EmpaqueDefinitivo
						  ,0						AS	Cantidad
			FROM			[CORPSQLMULT2019].[SIG-CD].[dbo].[Ordenes_borradas]		O
			LEFT JOIN		[CORPSQLMULT2019].[SIGSeguridad].[dbo].[Usuario]	U
			ON				O.[IdUsuario] = U.[IdUsuarioCD]
			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				AND			O.OrderNum		=	@OrderNum
				AND			O.OrderLine		=	@OrderLine
				AND			O.OrderRelNum	=	@OrderRelNum
		END




GO


