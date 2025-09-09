
SELECT					P.Company, P.PartNum, P.SearchWord, P.PartDescription, P.ProdCode, P.ClassID, P.TaxCatID, 
						PU.Character02, 
						PLP.ListCode, PLP.BasePrice, 
						PLP2.ListCode, PLP2.BasePrice, 
						PB.OnHandQty, PB.WarehouseCode, 
						PL.Plant, 
						(PLP.BasePrice * T.TotalImpuestos)						AS		PrecioFinalPersonal, 
						(PLP2.BasePrice * T.TotalImpuestos)						AS		PrecioFinalReferidos  
FROM					[CORPEPIDB].EpicorERP.Erp.Part					P				WITH (NoLock)
INNER JOIN				[CORPEPIDB].EpicorERP.Erp.Part_UD				PU				WITH (NoLock)
	ON					P.SysRowID				=			PU.ForeignSysRowID
LEFT OUTER JOIN			(
						SELECT					*
						FROM					[CORPEPIDB].EpicorERP.Erp.PriceLstParts						WITH (NoLock)
						WHERE					ListCode			LIKE		'P075%'	
						)		PLP 
	ON					P.Company				=			PLP.Company
	AND					P.PartNum				=			PLP.PartNum 
LEFT OUTER JOIN			(
						SELECT					*
						FROM					[CORPEPIDB].EpicorERP.Erp.PriceLstParts						WITH (NoLock)
						WHERE					ListCode			LIKE		'P073%'	
						)		PLP2 
	ON					P.Company				=			PLP2.Company
	AND					P.PartNum				=			PLP2.PartNum 
INNER JOIN				(
						SELECT					*
						FROM					[CORPEPIDB].EpicorERP.Erp.PartBin							WITH (NoLock)
						)		PB
	ON					P.Company				=			PB.Company
	AND					P.PartNum				=			PB.PartNum 
INNER JOIN				[CORPEPIDB].EpicorERP.Erp.WareHse					PL				WITH (NoLock)
	ON					PL.Company				=			PB.Company
	AND					PL.WarehouseCode		=			PB.WarehouseCode 
INNER JOIN				CORPEPISSRS01.RVF_Local.dbo.RVF_VW_IMP_TOTAL_IMPUESTOS_TAXCAT		T				WITH(NoLock)
	ON					P.Company				=			T.Company
	AND					P.TaxCatID				=			T.TaxCatID

----------------------------------------------------------------------------------------------------

WHERE					PL.Plant				IN			('CDEE')
	AND					PB.WarehouseCode		NOT IN		('VTA-SEG', 'INSPECC', 'CUARENT', 'TRA-CTRL', 'TRA-REV')
	AND					P.Company				=			'CO01'
	AND					P.ProdCode				=			'TV-LED'
	AND					PU.Character02			=			'TCL'
/*
	AND					(
						P.PartDescription		LIKE		'%55P735%'
						)
*/ 
----------------------------------------------------------------------------------------------------

ORDER BY				PU.Character02, P.ProdCode, P.SearchWord 



