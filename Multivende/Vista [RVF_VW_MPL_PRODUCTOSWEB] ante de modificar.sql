USE [RVF_Local]
GO

/****** Object:  View [dbo].[RVF_VW_MPL_PRODUCTOSWEB]    Script Date: 5/13/2021 12:08:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--/*
ALTER VIEW [dbo].[RVF_VW_MPL_PRODUCTOSWEB]

AS
--*/
SELECT				*
FROM				(

					/******************************************************************************
					Todos los productos, salvo los acondicionadores de aire
					******************************************************************************/

					SELECT				a.Company, 
										a.PartNum								AS 'CodigoProducto', 
										a.PartDescription						AS 'DescripcionProducto',
										a.ProdCode								AS 'GrupoProducto', 
										a.SearchWord							AS 'CodigoComercial', 
										a.GrossWeight							AS 'Peso', 
										a.GrossWeightUOM						AS 'UMPeso', 
										a.NetVolume								AS 'Volumen',
										a.NetVolumeUOM							AS 'UMVolumen',
										a.CommercialBrand, 
										a.CommercialSubBrand, 
										a.CommercialCategory, 
										a.CommercialSubCategory, 
										a.CommercialStyle, 
										a.CommercialSize1, 
										a.CommercialSize2, 
										a.CommercialColor, 
										a.AttrClassID, 
										a.PartLength, 
										a.PartWidth, 
										a.PartHeight, 
										a.DiameterInside, 
										a.DiameterUM, 
										a.DiameterOutside, 
										ISNULL(po.BasePrice, pl.BasePrice)		AS 'Thickness', --Este titulo fue definido por Fulljaus no cambiar nombre del titulo
										--a.Thickness, 
										a.ThicknessUM, 
										--a.ThicknessMax,
										ISNULL(pl.BasePrice, 0)					AS 'ThicknessMax', --Este titulo fue definido por Fulljaus no cambiar nombre del titulo
										a.Durometer, 
										a.Specification, 
										a.EngineeringAlert, 
										a.Condition, 
										a.IsCompliant, 
										a.IsSafetyItem, 
										a.IsRestricted, 
										a.CommentText, 
										c.Plant, 
										ISNULL(LEFT(m.[Description], 1000), '')	AS 'DescripcionMPL', 
										ISNULL(b.WarehouseCode, '')				AS 'Almacen',
										ISNULL(b.BinNum, '')					AS 'Ubicacion',
										ISNULL(b.OnhandQty, 0)					AS 'Cantidad', 
										ISNULL(po.BasePrice, pl.BasePrice)		AS 'Precio', 
										ISNULL(pl.BasePrice, 0)					AS 'PrecioLista', 
										a.ClassID + '-' + a.TaxCatID			AS 'CatImp', 
										ISNULL(e.ProdCode, '')					AS 'EAN13', 
										ISNULL(IVA.IVATaxPercent, 0)			AS 'IVATaxPercent', 
										ISNULL(IMPINT.INTTaxPercent, 0)			AS 'INTTaxPercent'

					from				[CORPEPIDB].EpicorERP.Erp.Part				a			WITH(NoLock)
					left outer join		(
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PartBin						WITH(NoLock)
										WHERE				BinNum				=				'ECOM'
										)											b
						on				a.Company = b.Company 
						and				a.PartNum = b.PartNum
										
					left outer join		[CORPEPIDB].EpicorERP.Erp.Warehse			c			WITH(NoLock)
						on				b.WarehouseCode		=		c.WarehouseCode

					left outer join		(
										SELECT				Company, PartNum, [Description] 
										FROM				[CORPEPIDB].EpicorERP.Erp.PartLangDesc					WITH(NoLock)
										WHERE				LangNameID			=		'Mpl'
										)					m
						on				a.Company			=			m.Company
						and				a.PartNum			=			m.PartNum

						inner join		(
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PriceLstParts				WITH(NoLock)
										WHERE				ListCode			LIKE			'P160%'
										)					pl
						on				a.Company			=			pl.Company
						and				a.PartNum			=			pl.PartNum

						left outer join (
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PriceLstParts				WITH(NoLock)
										WHERE				ListCode			LIKE			'P161%'
										)					po
						on				a.Company			=			po.Company
						and				a.PartNum			=			po.PartNum

						left outer join (
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PartPC							WITH(NoLock)
										WHERE				PCType					=			'EAN-13'
										)					e
						on				a.Company			=			e.Company
						and				a.PartNum			=			e.PartNum
						
						left outer join	(
										SELECT				Company, TaxCatID, SUM(TaxPercent)	AS	IVATaxPercent
										FROM				RVF_VW_MPL_PRODUCTOSWEB_ALICUOTAS_IMPUESTOS			WITH(NoLock)
										WHERE				RptCatCode		=			'IVA'
										GROUP BY			Company, TaxCatID
										)					IVA
						on				a.Company			=			IVA.Company
						and				a.TaxCatID			=			IVA.TaxCatID

						left outer join	(
										SELECT				Company, TaxCatID, SUM(TaxPercent)	AS	INTTaxPercent
										FROM				RVF_VW_MPL_PRODUCTOSWEB_ALICUOTAS_IMPUESTOS			WITH(NoLock)
										WHERE				RptCatCode		=			'IMPINT'
										GROUP BY			Company, TaxCatID
										)					IMPINT
						on				a.Company			=			IMPINT.Company
						and				a.TaxCatID			=			IMPINT.TaxCatID

					where				a.ClassID			NOT IN		('SUBA', 'SUCO')		-- Clases de parte de Subconjuntos

					-------------------------------------------------------------------------------
					UNION ALL
					-------------------------------------------------------------------------------

					/******************************************************************************
					Componente principal de los acondicionadores de aire
					******************************************************************************/

					SELECT				Pa.Company, 
										d.PartNum								AS 'CodigoProducto', 
										d.PartDescription						AS 'DescripcionProducto',
										d.ProdCode								AS 'GrupoProducto', 
										d.SearchWord							AS 'CodigoComercial', 
										d.GrossWeight							AS 'Peso', 
										d.GrossWeightUOM						AS 'UMPeso', 
										d.NetVolume								AS 'Volumen',
										d.NetVolumeUOM							AS 'UMVolumen',
										d.CommercialBrand, 
										d.CommercialSubBrand, 
										d.CommercialCategory, 
										d.CommercialSubCategory, 
										d.CommercialStyle, 
										d.CommercialSize1, 
										d.CommercialSize2, 
										d.CommercialColor, 
										d.AttrClassID,
										d.PartLength, 
										d.PartWidth, 
										d.PartHeight, 
										d.DiameterInside, 
										d.DiameterUM, 
										d.DiameterOutside, 
										--d.Thickness, 
										ISNULL(po.BasePrice, pl.BasePrice)		AS 'Thickness', --Este titulo fue definido por Fulljaus no cambiar nombre del titulo
										d.ThicknessUM, 
										--d.ThicknessMax,
										ISNULL(pl.BasePrice, 0)					AS 'ThicknessMax', --Este titulo fue definido por Fulljaus no cambiar nombre del titulo
										d.Durometer, 
										d.Specification, 
										d.EngineeringAlert, 
										d.Condition, 
										d.IsCompliant, 
										d.IsSafetyItem, 
										d.IsRestricted, 
										d.CommentText,
										c.Plant, 
										ISNULL(LEFT(m.[Description], 1000), '')	AS 'DescripcionMPL', 
										ISNULL(b.WarehouseCode, '')				AS 'Almacen',
										ISNULL(b.BinNum, '')					AS 'Ubicacion',
										ISNULL(b.OnhandQty, 0)					AS 'Cantidad', 
										ISNULL(po.BasePrice, pl.BasePrice)		AS 'Precio',
										ISNULL(pl.BasePrice, 0)					AS 'PrecioLista', 
										d.ClassID + '-' + d.TaxCatID			AS 'CatImp', 
										ISNULL(e.ProdCode, '')					AS 'EAN13', 
										ISNULL(IVA.IVATaxPercent, 0)			AS 'IVATaxPercent', 
										ISNULL(IMPINT.INTTaxPercent, 0)			AS 'INTTaxPercent'

					from				(
										select				a.Company, a.PartNum, a.PartDescription, a.ProdCode, a.SearchWord, a.ClassID, a.TaxCatID, 
															a.GrossWeight, a.GrossWeightUOM, a.NetVolume, a.NetVolumeUOM, a.CommercialBrand, 
															a.CommercialSubBrand, a.CommercialCategory, a.CommercialSubCategory, a.CommercialStyle, 
															a.CommercialSize1, a.CommercialSize2, a.CommercialColor, a.AttrClassID, a.PartLength, 
															a.PartWidth, a.PartHeight, a.DiameterInside, a.DiameterUM, a.DiameterOutside, a.Thickness, 
															a.ThicknessUM, a.ThicknessMax, a.Durometer, a.Specification, a.EngineeringAlert, 
															a.Condition, a.IsCompliant, a.IsSafetyItem, a.IsRestricted, a.CommentText,
															u.ShortChar05
				
										from				[CORPEPIDB].EpicorERP.Erp.Part				a			WITH(NoLock)
										left outer join		[CORPEPIDB].EpicorERP.Erp.Part_UD			u			WITH(NoLock)
											on				a.SysRowID			=			u.ForeignSysRowID
										where				a.ClassID			IN			('SUBA', 'SUCO')		-- Clases de parte de Subconjuntos
											and 			u.CheckBox06		=			1						-- Componente de Kit
											and				u.CheckBox07		=			0						-- Componente Principal
										)										Pa

					left outer join		(
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PartBin						WITH(NoLock)
										WHERE				BinNum				=				'ECOM'
										)										b
						on				Pa.Company			=			b.Company 
						and				Pa.PartNum			=			b.PartNum
				
					left outer join		[CORPEPIDB].EpicorERP.Erp.Warehse			c			WITH(NoLock)
						on				b.WarehouseCode		=		c.WarehouseCode			

					left outer join		[CORPEPIDB].EpicorERP.Erp.Part				d			WITH(NoLock)
						on				Pa.Company						=		d.Company
						and				LTRIM(RTRIM(Pa.ShortChar05))	=		d.PartNum

					left outer join		(
										SELECT				Company, PartNum, [Description] 
										FROM				[CORPEPIDB].EpicorERP.Erp.PartLangDesc					WITH(NoLock)
										WHERE				LangNameID			=		'Mpl'
										)					m
						on				Pa.Company			=			m.Company
						and				Pa.PartNum			=			m.PartNum
						inner join (
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PriceLstParts				WITH(NoLock)
										WHERE				ListCode			LIKE			'P160%'
										)					pl
						on				Pa.Company							=			pl.Company
						and				LTRIM(RTRIM(Pa.ShortChar05))		=			pl.PartNum

						left outer join (
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PriceLstParts				WITH(NoLock)
										WHERE				ListCode			LIKE			'P161%'
										)					po
						on				Pa.Company			=			po.Company
						and				Pa.PartNum			=			po.PartNum

						left outer join (
										SELECT				*
										FROM				[CORPEPIDB].EpicorERP.Erp.PartPC						WITH(NoLock)
										WHERE				PCType					=			'EAN-13'
										)					e
						on				Pa.Company							=			e.Company
						and				LTRIM(RTRIM(Pa.ShortChar05))			=			e.PartNum

						left outer join	(
										SELECT				Company, TaxCatID, SUM(TaxPercent)	AS	IVATaxPercent
										FROM				RVF_VW_MPL_PRODUCTOSWEB_ALICUOTAS_IMPUESTOS			WITH(NoLock)
										WHERE				RptCatCode		=			'IVA'
										GROUP BY			Company, TaxCatID
										)					IVA
						on				Pa.Company			=			IVA.Company
						and				Pa.TaxCatID			=			IVA.TaxCatID
						
						left outer join	(
										SELECT				Company, TaxCatID, SUM(TaxPercent)	AS	INTTaxPercent
										FROM				RVF_VW_MPL_PRODUCTOSWEB_ALICUOTAS_IMPUESTOS			WITH(NoLock)
										WHERE				RptCatCode		=			'IMPINT'
										GROUP BY			Company, TaxCatID
										)					IMPINT
						on				Pa.Company			=			IMPINT.Company
						and				Pa.TaxCatID			=			IMPINT.TaxCatID

					-------------------------------------------------------------------------------
					)		Z 

WHERE				Z.Company			=			'CO01'
	AND				Z.Plant				=			'MPlace' 


GO


