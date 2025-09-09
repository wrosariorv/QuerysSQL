

SELECT				Company, OrderNum, OrderLine, DisplaySeq, KitParentLine, PartNum, LineDesc, *
FROM				[CORPEPIDB].EpicorErp.Erp.OrderDtl
WHERE				OrderNum				IN					(154951) 
ORDER BY			1, 2, 3 



/*

UPDATE				[CORPEPIDB].EpicorErp.Erp.OrderDtl
SET					DisplaySeq				=			2.002, 
					KitParentLine			=			2
WHERE				DisplaySeq				=			2.005
	AND				Company					=			'CO01'
	AND				OrderNum				=			154951
	AND				OrderLine				=			4

*/

