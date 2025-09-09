

SELECT				*
FROM				[CORPEPIDB].EpicorErp.Erp.Plant									WITH(NoLock)
WHERE				Plant				IN				('CDEE', 'MPlace', 'FRA640')
ORDER BY			Company, Plant 


SELECT				*
FROM				[CORPEPIDB].EpicorErp.Erp.Warehse								WITH(NoLock)
WHERE				Plant				IN				('CDEE', 'MPlace', 'FRA640')
ORDER BY			Company, Plant, WarehouseCode


SELECT				*
FROM				[CORPEPIDB].EpicorErp.Erp.WhseBin								WITH(NoLock)
WHERE				WarehouseCode		=				'STG'
ORDER BY			Company, WarehouseCode, BinNum 


SELECT				DISTINCT 
					PB.Company, PB.PartNum, 
					W.Plant, 
					CASE 
						WHEN		W.Plant		=		'CDEE'		THEN		'STG-CDSJ'
						WHEN		W.Plant		=		'FRA640'	THEN		'STG-FRSJ'
						WHEN		W.Plant		=		'MPlace'	THEN		'STG-MPSJ'
						ELSE													''
					END													AS		'WarehouseCode', 
					'99-99-99'											AS		'BinNum', 

					----------------------------------------------------------------------
					P.SearchWord, P.PartDescription, P.ClassID, P.ProdCode, P.TypeCode  
FROM				[CORPEPIDB].EpicorErp.Erp.PartBin						PB		WITH(NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Part							P		WITH(NoLock)
	ON				P.Company			=				PB.Company
	AND				P.PartNum			=				PB.PartNum 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Warehse						W		WITH(NoLock)
	ON				PB.Company			=				W.Company
	AND				PB.WarehouseCode	=				W.WarehouseCode 
WHERE				W.Plant				IN				('CDEE', 'MPlace', 'FRA640')
ORDER BY			P.ClassID, W.Plant, PB.Company, PB.PartNum 



