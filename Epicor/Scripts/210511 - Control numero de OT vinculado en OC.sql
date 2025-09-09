
SELECT			POU.ForeignSysRowID, POU.ShortChar04, 
				PO.*, 
				POU.*
FROM			[CORPEPIDB].EpicorErp.Erp.POHeader						PO
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.POHeader_UD					POU
	ON			PO.SysRowID		=			POU.ForeignSysRowID	
WHERE			PONum			IN			(1012665, 1012681, 1012656)


SELECT			po.Company, PO.PONum, PO.CommentText, 
				PO.*, 
				POU.*
FROM			[CORPEPIDB].EpicorErp.Erp.PODetail						PO
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.PODetail_UD					POU
	ON			PO.SysRowID		=			POU.ForeignSysRowID	
WHERE			PONum			IN			(1012665, 1012681, 1012656)


SELECT			POU.ForeignSysRowID, POU.ShortChar04, 
				PO.*, 
				POU.*
FROM			[CORPEPIDB].EpicorErp.Erp.PORel						PO
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.PORel_UD					POU
	ON			PO.SysRowID		=			POU.ForeignSysRowID	
WHERE			PONum			IN			(1012665, 1012681, 1012656)

/*

UPDATE		[CORPEPIDB].EpicorErp.Erp.PODetail
SET			CommentText			=		'RV624005'
WHERE		Company				=		'CO01'
	AND		PONum				IN		(1012656, 1012665, 1012681)
	AND		CommentText			=		'RV624001'

*/