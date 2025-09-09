
DECLARE			@B_PlantaOrigen VARCHAR(15)			=		'MfgSys', 
				@C_PlantaDestino VARCHAR(15)		=		'CDEE'

select 
				[PlantTran].[Company]					as [PlantTran_Company],
				[PlantTran].[FromPlant]					as [PlantTran_FromPlant],
				[PlantTran].[ToPlant]					as [PlantTran_ToPlant],
				[PlantTran].[TranStatus]				as [PlantTran_TranStatus],
				[ShipVia].[Description]					as [ShipVia_Description],
				[Part_UD].[Character02]					as [Part_Character02],
				[PlantTran].[PartNum]					as [PlantTran_PartNum],
				[PlantTran].[PartDescription]			as [PlantTran_PartDescription],
				[PlantTran].[TranQty]					as [PlantTran_TranQty],
				[PlantTran].[UM]						as [PlantTran_UM],
				((case when  ((MscShpDt_UD.Number12) is null) then  PriceLstParts.BasePrice  else  MscShpDt_UD.Number12 end)) as [Calculated_PrecioC],
	--			(PlantTran.TranQty * PrecioC) as [Calculated_ValorSeguro],
				[Part].[SearchWord]						as [Part_SearchWord],
				[TFShipHead_UD].[ShortChar05]			as [TFShipHead_ShortChar05],
				[TFShipHead_UD].[ShortChar06]			as [TFShipHead_ShortChar06],
				((case when  PlantTran.TranStatus = 'CLOSED'  then  'Descargado'  else  '' end)) as [Calculated_Estado],
				[PlantTran].[TranDate]					as [PlantTran_TranDate],
				[PlantTran].[EntryPerson]				as [PlantTran_EntryPerson],
				[PlantTran].[RecTranDate]				as [PlantTran_RecTranDate],
				[PlantTran].[RecEntryPerson]			as [PlantTran_RecEntryPerson],
				[Part].[ProdCode]						as [Part_ProdCode],
				(datepart(year, PlantTran.TranDate))	as [Calculated_AnoCarga],
				(datepart(month, PlantTran.TranDate))	as [Calculated_MesCarga],
				(Part.NetVolume * PlantTran.TranQty)	as [Calculated_VolumenM3],
				[Part].[NetVolumeUOM]					as [Part_NetVolumeUOM],
				[TFShipDtl_UD].[ShortChar01]			as [TFShipDtl_ShortChar01],
				[TFShipHead].[LegalNumber]				as [TFShipHead_LegalNumber],
				[TFShipDtl_UD].[ShortChar02]			as [TFShipDtl_ShortChar02], 

--------------------------------------------------------------- 
				MscShpDt.PackNum						AS MscShpDt_PackNum, 
				TFShipDtl.PackNum						AS TFShipDtl_PackNum, 
				PriceLstParts.BasePrice					AS PriceLstParts_BasePrice, 
				MscShpDt_UD.Number12					AS MscShpDt_UD_Number12
---------------------------------------------------------------

from			[CORPEPIDB].EpicorErp.Erp.PlantTran		as PlantTran
inner join		[CORPEPIDB].EpicorErp.Erp.Part			as Part on 
	PlantTran.Company = Part.Company
	and PlantTran.PartNum = Part.PartNum
inner join		[CORPEPIDB].EpicorErp.Erp.PriceLstParts as PriceLstParts on 
	Part.Company = PriceLstParts.Company
	and Part.PartNum = PriceLstParts.PartNum
inner join		[CORPEPIDB].EpicorErp.Erp.PriceLst		as PriceLst on 
	PriceLstParts.Company = PriceLst.Company
	and PriceLstParts.ListCode = PriceLst.ListCode
	and ( PriceLst.ListCode like 'P100%'  )

inner join		[CORPEPIDB].EpicorErp.Erp.TFShipDtl		as TFShipDtl on 
	PlantTran.Company = TFShipDtl.Company
	and PlantTran.PackNum = TFShipDtl.PackNum
	and PlantTran.PackLine = TFShipDtl.PackLine
	and PlantTran.TFOrdNum = TFShipDtl.TFOrdNum
	and PlantTran.TFOrdLine = TFShipDtl.TFOrdLine
inner join		[CORPEPIDB].EpicorErp.Erp.TFShipHead	as TFShipHead on 
	TFShipDtl.Company = TFShipHead.Company
	and TFShipDtl.PackNum = TFShipHead.PackNum
inner join		[CORPEPIDB].EpicorErp.Erp.ShipVia		as ShipVia on 
	TFShipHead.Company = ShipVia.Company
	and TFShipHead.ShipViaCode = ShipVia.ShipViaCode
left outer join [CORPEPIDB].EpicorErp.Erp.MscShpDt		as MscShpDt on 
	TFShipDtl.Company = MscShpDt.Company
	and TFShipDtl.PackNum = MscShpDt.PackNum
	and TFShipDtl.PartNum = MscShpDt.PartNum
---------------------------------------------------------------

inner join		[CORPEPIDB].EpicorErp.Erp.Part_UD		as Part_UD on 
	Part.SysRowID = Part_UD.ForeignSysRowID

left outer join		[CORPEPIDB].EpicorErp.Erp.MscShpDt_UD	as MscShpDt_UD on 
	MscShpDt.SysRowID = MscShpDt_UD.ForeignSysRowID

inner join		[CORPEPIDB].EpicorErp.Erp.TFShipHead_UD as TFShipHead_UD on 
	TFShipHead.SysRowID = TFShipHead_UD.ForeignSysRowID

inner join		[CORPEPIDB].EpicorErp.Erp.TFShipDtl_UD	as TFShipDtl_UD on 
	TFShipDtl.SysRowID = TFShipDtl_UD.ForeignSysRowID

---------------------------------------------------------------

where			(
		--		PlantTran.TranStatus	=	@A_Status  
		--		and 
				PlantTran.FromPlant		=	@B_PlantaOrigen  
				and 
				PlantTran.ToPlant		=	@C_PlantaDestino
				)

	AND			[PlantTran].[Company]		=	'CO02'
--	AND			[MscShpDt_UD].[Number12]	IS	NOT NULL

ORDER BY		PlantTran_Company, PlantTran_TranDate DESC 
