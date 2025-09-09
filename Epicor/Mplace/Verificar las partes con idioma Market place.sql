select 

	[Part].[PartNum] 
	
from [CORPEPIDB].EpicorERP.Erp.Part as Part
left outer join [CORPEPIDB].EpicorERP.Erp.PartLangDesc as PartLangDesc on 
	Part.Company = PartLangDesc.Company
	and Part.PartNum = PartLangDesc.PartNum
	and ( PartLangDesc.LangNameID = 'mpl'  )

inner join [CORPEPIDB].EpicorERP.Erp.PriceLstParts as PriceLstParts on 
	Part.Company = PriceLstParts.Company
	and Part.PartNum = PriceLstParts.PartNum
	and ( PriceLstParts.ListCode like 'P160-%'  )

left outer join [CORPEPIDB].EpicorERP.Erp.PriceLstParts as PriceLstParts161 on 
	Part.Company = PriceLstParts161.Company
	and Part.PartNum = PriceLstParts161.PartNum
	and ( PriceLstParts161.ListCode like 'P161-%'  )

	where
	[Part].[PartNum]  not in (select PartNum from [CORPEPIDB].EpicorERP.Erp.PartLangDesc)