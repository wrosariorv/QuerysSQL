SET DATEFORMAT DMY
 
--verifica estado de stock
SELECT			PB.Company, W.Plant	, PB.PartNum, PB.WareHouseCode, PB.BinNum, PB.OnHandQty, 								
				W.Plant, 							
				PU.Character02 							
FROM			[CORPL11-EPIDB].[EpicorERPTest].Erp.PartBin			PB					
INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Warehse			W						
	ON			PB.Company			=			W.Company	
	AND			PB.WareHouseCode	=			W.WareHouseCode			
INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Part				P					
	ON			PB.Company			=			P.Company	
	AND			PB.PartNum			=			P.PartNum	
INNER JOIN		[CORPL11-EPIDB].[EpicorERPTest].Erp.Part_UD			PU						
	ON			P.SysRowID			=			PU.ForeignSysRowID	
WHERE			PB.Company			in			('CO01','CO02','CO03')		
	--AND			W.Plant				in			(/*SERVICE*/'FRA640',/*OUTLET*/ 'PER2823')
	AND			(
				PB.WareHouseCode	in			('STG')
	--OR			PB.WareHouseCode	=			'GR-OUT'
	--OR			PB.WareHouseCode	like		'OUT-%'
				)
	AND			(
				PB.BinNum	=			'STGDESP'
	
				)
	--AND			P.PartNum			in ('6102A-FALCAR11','5102B-BALCAR11')
	AND			P.PartNum			in ('T613P1-FAAVAR11')
