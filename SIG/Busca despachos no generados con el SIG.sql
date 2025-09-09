USE [RVF_Local]
GO




/*
-- [dbo].[ELIMINAR_SERIE_DE_OV] elimina un serie indicado para una parte undicada, de una orden indicada
-- Retorna "OK" si el serie fue eliminado con éxito
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
DECLARE
@Company		NVARCHAR(8)='CO01',
@Plant			NVARCHAR(8)='CDEE'


--IF @OrderLine = 0 AND @OrderRelNum = 0
--BEGIN
SELECT 
			w.Company,
			W.Plant,
			W.OrderNum,
			W.ORderLine,
			W.ORderRelNum,
			A.Key3,
			W.Archivo
			
FROM (
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
			FROM			[CORPSQLMULT01].[Despacho CD_H].[dbo].[Ordenes]		O
			LEFT JOIN		[CORPSQLMULT01].[Despacho CD_H].[dbo].[Usuarios]	U
			ON				O.[idusuario] = U.[Id]

			------ TRAIGO EL EMPAQUE DEFINITIVO -------

			LEFT JOIN	CORPEPIDB.EpicorErp.Erp.ShipDtl										S WITH (NoLock)
			ON			O.Company		=	S.Company		COLLATE database_default
				AND		O.Plant			=	S.Plant			COLLATE database_default
				AND		O.OrderNum		=	S.OrderNum		
				AND		O.OrderLine		=	S.OrderLine		
				AND		O.OrderRelNum	=	S.OrderRelNuM	

			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				--AND			O.OrderNum		=	@OrderNum

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
			FROM			[CORPSQLMULT01].[Despacho CD_H].[dbo].[Ordenes_borradas]		O
			LEFT JOIN		[CORPSQLMULT01].[Despacho CD_H].[dbo].[Usuarios]	U
			ON				O.[idusuario] = U.[Id]
			WHERE			O.Company		=	@Company
				AND			O.Plant			=	@Plant
				--AND			O.OrderNum		=	@OrderNum

--END
) AS w
Inner join [CORPEPIDB].[EpicorERP].[Ice].UD110A AS A
ON		W.Company		=		A.Company COLLATE SQL_Latin1_General_CP1_CI_AS
AND		W.OrderNum		=		A.Number01
AND		W.ORderLine		=		A.Number02
AND		W.ORderRelNum	=		A.Number03

where
Convert (date,w.FechaInicio) ='2023-02-24'
AND archivo ='Eliminado'
