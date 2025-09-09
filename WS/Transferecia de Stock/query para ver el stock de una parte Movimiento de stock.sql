SELECT			PB.Company, W.Plant	, PB.PartNum, PB.WareHouseCode, PB.BinNum, PB.OnHandQty, 								
				W.Plant, 							
				PU.Character02 							
FROM			Erp.PartBin			PB					
INNER JOIN		Erp.Warehse			W						
	ON			PB.Company			=			W.Company	
	AND			PB.WareHouseCode	=			W.WareHouseCode			
INNER JOIN		Erp.Part				P					
	ON			PB.Company			=			P.Company	
	AND			PB.PartNum			=			P.PartNum	
INNER JOIN		Erp.Part_UD			PU						
	ON			P.SysRowID			=			PU.ForeignSysRowID	
WHERE			PB.Company			in			('CO01','CO02','CO03')		
	AND			W.Plant				=			'MfgSys'
	AND			(
				PB.WareHouseCode	=			'APT'
	OR			PB.WareHouseCode	=			'APT-VTAS'
				)
	AND			(
				PB.BinNum	=			'99-99-99'
	OR			PB.BinNum	=			'99-99-99'
				)
	AND			P.PartNum			in ('T610P2-FBLCAR11')

	select * from Erp.PartPlant			
	where PartNum			in ('L75C645-F')

	select * from Erp.PartPlant			
	where PartNum			in ('T610P2-FBLCAR11')

	select *  FROM			Erp.PartBin			PB		
	where Company='CO01'
	AND		PartNum			in ('T610P2-FBLCAR11')