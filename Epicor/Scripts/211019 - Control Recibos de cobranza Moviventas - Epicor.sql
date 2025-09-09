

SET DATEFORMAT DMY

SELECT				Company, GroupID, HeadNum, Posted, TranAmt, TranDate, Reference, LegalNumber, OtherDetails, TranAmt, ChangedBy, 
					CASE	
						WHEN			OtherDetails			=				''
						THEN													'Epicor'
						ELSE													'Moviventas'
					END													AS		Origen									

FROM				[CORPEPIDB].EpicorErp.Erp.CashHead							CH		WITH(NoLock)
WHERE				CH.TranDate						BETWEEN			'01/11/2021'		AND			'30/11/2021'
	AND				CH.TranType						=				'PayInv'

ORDER BY			6 DESC 
