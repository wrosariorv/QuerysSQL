USE [RVF_Local]
GO

 /*

ALTER PROCEDURE	[dbo].[RVF_PRC_PSI_INFORME_CONSOLIDADO_MENSUAL]
								@Periodo		SMALLINT, 
								@Mes			SMALLINT

AS

 */

-- /*

DECLARE				@Periodo		SMALLINT		=		2021, 
					@Mes			SMALLINT		=		8

-- */

--------------------------------------------------------------------------

DECLARE			@ClassID				TABLE	(Lista VARCHAR(15))	

INSERT INTO		@ClassID				VALUES	('PTF'), ('PTCO'),											-- Productos terminados fabricados
												('SK'), ('SKCO'), 											-- Kits de ventas de AA
												('REVI')													-- Productos de reventa importada

--------------------------------------------------------------------------

DECLARE			@ClassID2				TABLE	(Lista VARCHAR(15))	

INSERT INTO		@ClassID2				VALUES	('SUBA'), ('SUCO')											-- Subconjuntos de ventas de AA

--------------------------------------------------------------------------

DECLARE			@ProdCode				TABLE	(Lista VARCHAR(15))	

INSERT INTO		@ProdCode				VALUES	('CEL'), ('TAB'), ('TV-LED'), ('AA-SPLIT'), ('MWO')			-- Grupos de productos analizados

--------------------------------------------------------------------------

DECLARE			@ReminderCodeExclude	TABLE	(Lista VARCHAR(15))	

INSERT INTO		@ReminderCodeExclude	VALUES	('Interemp')												-- Grupos de clientes excluidos

--------------------------------------------------------------------------

DECLARE			@WhseExclude			TABLE	(Lista VARCHAR(15))	

INSERT INTO		@WhseExclude			VALUES	('TERCER') 													-- Stock excluido del analisis

--------------------------------------------------------------------------

DECLARE			@UnNegExclude	TABLE	(Lista VARCHAR(15))	

INSERT INTO		@UnNegExclude	VALUES	('NE') 														-- Unidades de Negocio a Excluir

--------------------------------------------------------------------------

SELECT				Company, ProdCode, SellingShipQty, VentaLinea, MargenTotal, IngresoTotal, OnHandQty, 
					CASE 
						WHEN	UnNeg		IN			('RCA', 'KEL')
						THEN							'RCA / KEL'
						ELSE							UnNeg
					END									AS		UnNeg  
FROM				(

					SELECT				ISNULL(Vtas.Company, Stock.Company)				AS		Company, 
										ISNULL(Vtas.ProdCode, Stock.ProdCode)			AS		ProdCode, 
										ISNULL(Vtas.UnNeg, Stock.UnNeg)					AS		UnNeg,  
										ISNULL(Vtas.SellingShipQty, 0)					AS		SellingShipQty, 
										ISNULL(Vtas.VentaLinea, 0)						AS		VentaLinea, 
										ISNULL(Vtas.MargenTotal, 0)						AS		MargenTotal, 
										ISNULL(Vtas.IngresoTotal, 0)					AS		IngresoTotal, 
										ISNULL(Stock.OnHandQty, 0)						AS		OnHandQty
					FROM				(
										--------------------------------------------------------------------------

										SELECT				Company, ProdCode, UnNeg, 
															SUM(SellingShipQty)					AS		SellingShipQty, 
															SUM(VentaLinea)						AS		VentaLinea, 
															SUM(MargenTotal)					AS		MargenTotal, 
															SUM(IngresoTotal)					AS		IngresoTotal
										FROM				[dbo].[RVF_TBL_PSI_REPOSITORIO_VENTAS_MES]					WITH (NoLock)
										WHERE				PeriodoActual			=			@Periodo
											AND				MesActual				=			@Mes
											--------------------------------------------------------------------------
											AND				ClassID					IN			(
																								SELECT				Lista
																								FROM				@ClassID
																								)
											--------------------------------------------------------------------------
											AND				ProdCode				IN			(
																								SELECT				Lista
																								FROM				@ProdCode
																								)
											--------------------------------------------------------------------------
											AND				ReminderCode			NOT	IN		(
																								SELECT				Lista
																								FROM				@ReminderCodeExclude
																								)
											--------------------------------------------------------------------------
											AND				UnNeg					NOT	IN		(
																								SELECT				Lista
																								FROM				@UnNegExclude
																								)
											--------------------------------------------------------------------------

										GROUP BY			Company, ProdCode, UnNeg 

										)	Vtas

					FULL OUTER JOIN		
					
										(
										SELECT				Company, ProdCode, UnNeg,  
															SUM(OnHandQty)						AS		OnHandQty 
										FROM				[dbo].[RVF_TBL_PSI_REPOSITORIO_STOCK_DIARIO]				WITH (NoLock)
										WHERE				PeriodoActual			=			@Periodo
											AND				MesActual				=			@Mes
											AND				(
															ComponenteKit			=			0					-- Productos que no son Kits de Venta
															OR
															(
															ComponenteKit			=			1					-- Productos que son Kits de Venta
															AND
															ComponentePpal			=			1					-- Componente principal de los Kits de Venta
															)
															)
											--------------------------------------------------------------------------
											AND				(
															ClassID					IN			(
																								SELECT				Lista
																								FROM				@ClassID
																								)
															OR
															ClassID					IN			(
																								SELECT				Lista
																								FROM				@ClassID2
																								)
															)
											--------------------------------------------------------------------------
											AND				ProdCode				IN			(
																								SELECT				Lista
																								FROM				@ProdCode
																								)
											--------------------------------------------------------------------------
											AND				WareHouseCode			NOT	IN		(
																								SELECT				Lista
																								FROM				@WhseExclude
																								)
											--------------------------------------------------------------------------
											AND				UnNeg					NOT	IN		(
																								SELECT				Lista
																								FROM				@UnNegExclude
																								)
											--------------------------------------------------------------------------

										GROUP BY			Company, ProdCode, UnNeg 

										)	Stock
							ON			Vtas.Company				=				Stock.Company
							AND			Vtas.ProdCode				=				Stock.ProdCode
							AND			Vtas.UnNeg					=				Stock.UnNeg

					) A