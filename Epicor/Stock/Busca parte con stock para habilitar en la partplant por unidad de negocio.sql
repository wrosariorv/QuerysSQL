select * from erp.Warehse
where Company='Co01'
and Plant='cdee'

SELECT			PB.Company, PB.PartNum, PB.WareHouseCode, PB.BinNum, PB.OnHandQty, 								
				W.Plant, 							
				PU.Character02 							
FROM			[CORPEPIDB].EpicorErp.Erp.PartBin			PB					
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Warehse			W						
	ON			PB.Company			=			W.Company	
	AND			PB.WareHouseCode	=			W.WareHouseCode			
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Part				P					
	ON			PB.Company			=			P.Company	
	AND			PB.PartNum			=			P.PartNum	
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Part_UD			PU						
	ON			P.SysRowID			=			PU.ForeignSysRowID	
WHERE			PB.Company			=			'CO01'		
	AND			W.Plant				=			'CDEE'
											
	AND			PU.Character02		=			'TCL'		
