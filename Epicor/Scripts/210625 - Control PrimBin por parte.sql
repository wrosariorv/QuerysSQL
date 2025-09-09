

SELECT			P.Company, P.PartNum, P.SearchWord, P.PartDescription, P.ClassID, P.ProdCode,
				PU.Character02										AS	UnNeg, 
				PP.Plant, PP.PrimWhse, 
				PW.PrimBin 
FROM			[CORPEPIDB].EpicorErp.Erp.Part						P				WITH(NoLock)
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Part_UD					PU				WITH(NoLock)
	ON			P.SysRowID				=				PU.ForeignSysRowID
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.PartPlant					PP				WITH(NoLock)
	ON			P.Company				=				PP.Company
	AND			P.PartNum				=				PP.PartNum
LEFT OUTER JOIN	[CORPEPIDB].EpicorErp.Erp.PlantWhse					PW				WITH(NoLock)
	ON			PW.Company				=				PP.Company
	AND			PW.PartNum				=				PP.PartNum
	AND			PW.WarehouseCode		=				PP.PrimWhse

WHERE			P.ClassID				IN				('SUCO', 'SKCO', 'PTCO')
	AND			PP.Plant				=				'CDEE'
	AND			P.ProdCode				=				'CEL'
	AND			PU.Character02			=				'TCL'

--	AND			P.PartNum				=				'6125A-BALCAR11'

ORDER BY		P.Company, P.PartNum 

