
SET DATEFORMAT DMY


SELECT				Company, PONum, ChangedBy, ChangeDate, *
FROM				[CORPEPIDB].EpicorERP.Erp.POHeader 				PO			WITH (NoLock)
WHERE NOT EXISTS	(
					SELECT				*	
					FROM				[CORPEPIDB].EpicorERP.Erp.APInvDtl			API
					WHERE				PO.Company			=			API.Company
						AND				PO.PONum			=			API.PONum
					)
--	AND				ChangedBy			=			'gpuente'
	AND				OpenOrder			=			0

	AND				ChangeDate			>=			'01/01/2021'
	AND				VoidOrder			=			0

ORDER BY			2 DESC
