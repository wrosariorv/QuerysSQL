
SET DATEFORMAT DMY 

DECLARE				@FechaDesde DATE			=			'01/10/2021'


SELECT				Q.Company, Q.QuoteNum, Q.EntryDate, Q.Reference, Q.ChangedBy, Q.Plant_c, Q.Ordered, Q.QuoteClosed, Q.CurrencyCode, Q.QuoteTotal, 
		--			Q.TerritoryID, Q.ReasonType, T.CreateOrder, 
					T.CompleteDate, T.ChangeDate, 
					CONVERT(CHAR(8), DATEADD(SECOND, T.ChangeTime, '00:00:00'), 108)								AS ChangeTime, 
					Q.CustID, Q.[Name], Q.ValidSoldTo, Q.ValidShipTo, Q.ForeignSysRowID 
FROM				(
					SELECT				QH.Company, QH.QuoteNum, QH.EntryDate, QH.Reference, QH.TerritoryID, QH.ReasonType, QH.ChangedBy, QH.Ordered, 
										QH.QuoteClosed, QH.CurrencyCode, 
										FORMAT((QH.QuoteAmt + TotalTax), 'N2')							AS	QuoteTotal, 
										QHU.ForeignSysRowID, QHU.Plant_c, 
										C.CustID, C.[Name], C.ValidSoldTo, C.ValidShipTo
					FROM				[CORPEPIDB].EpicorErp.Erp.QuoteHed				QH				WITH (NoLock) 
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.QuoteHed_UD			QHU				WITH (NoLock)
						ON				QH.SysRowID						=				QHU.ForeignSysRowID
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer				C				WITH (NoLock)
						ON				QH.Company						=				C.Company
						AND				QH.CustNum						=				C.CustNum
					WHERE				QH.ReasonType					=				'W'
						AND NOT EXISTS	(
										SELECT				*
										FROM				[CORPEPIDB].EpicorErp.Erp.OrderDtl				OD				WITH (NoLock)
										WHERE				OD.Company				=				QH.Company
											AND				OD.QuoteNum				=				QH.QuoteNum 
										)
						AND				QH.ChangeDate			>=				@FechaDesde
					)		Q
LEFT OUTER JOIN		(
					SELECT				Company, RelatedToFile, Key1, StartDate, DueDate, ChangeDate, ChangeTime, CompleteDate, CreateOrder
					FROM				[CORPEPIDB].EpicorErp.Erp.Task				T				WITH (NoLock)
					WHERE				Conclusion				=				'WIN'
					)		T 
	ON				Q.Company				=				T.Company
	AND				Q.QuoteNum				=				T.Key1 

WHERE				T.CompleteDate			>=				@FechaDesde

ORDER BY			T.ChangeDate, T.ChangeTime, Q.QuoteNum 


/*


SET DATEFORMAT DMY 

DECLARE				@FechaDesde DATE			=			'01/10/2021'


SELECT				Q.Company, Q.QuoteNum, Q.EntryDate, Q.Reference, Q.ChangedBy, Q.Plant_c, 
		--			Q.Ordered, Q.QuoteClosed, Q.TerritoryID, Q.ReasonType, T.CreateOrder, 
					T.CompleteDate, T.ChangeDate, 
					CONVERT(CHAR(8), DATEADD(SECOND, T.ChangeTime, '00:00:00'), 108)								AS ChangeTime, 
					Q.CustID, Q.[Name], Q.ValidSoldTo, Q.ValidShipTo, 
					P.PartNum, P.PartDescription, P.ProdCode, P.ClassID, P.TaxCatID, 
					PU.Character03							AS		Fabricante 
FROM				(
					SELECT				QH.Company, QH.QuoteNum, QH.EntryDate, QH.Reference, QH.TerritoryID, QH.ReasonType, QH.ChangedBy, QH.Ordered, 
										QH.QuoteClosed, 
										QHU.Plant_c, 
										C.CustID, C.[Name], C.ValidSoldTo, C.ValidShipTo 
					FROM				[CORPEPIDB].EpicorErp.Erp.QuoteHed				QH				WITH (NoLock) 
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.QuoteHed_UD			QHU				WITH (NoLock)
						ON				QH.SysRowID						=				QHU.ForeignSysRowID
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer				C				WITH (NoLock)
						ON				QH.Company						=				C.Company
						AND				QH.CustNum						=				C.CustNum
					WHERE				QH.ReasonType					=				'W'
						AND NOT EXISTS	(
										SELECT				*
										FROM				[CORPEPIDB].EpicorErp.Erp.OrderDtl				OD				WITH (NoLock)
										WHERE				OD.Company				=				QH.Company
											AND				OD.QuoteNum				=				QH.QuoteNum 
										)
						AND				QH.ChangeDate			>=				@FechaDesde
					)		Q
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.QuoteDtl				QD				WITH (NoLock) 
	ON				Q.Company				=				QD.Company
	AND				Q.QuoteNum				=				QD.QuoteNum
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Part					P				WITH (NoLock) 
	ON				QD.Company				=				P.Company
	AND				QD.PartNum				=				P.PartNum
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Part_UD				PU				WITH (NoLock) 
	ON				P.SysRowID				=				PU.ForeignSysRowID
LEFT OUTER JOIN		(
					SELECT				Company, RelatedToFile, Key1, StartDate, DueDate, ChangeDate, ChangeTime, CompleteDate, CreateOrder
					FROM				[CORPEPIDB].EpicorErp.Erp.Task				T				WITH (NoLock)
					WHERE				Conclusion				=				'WIN'
					)		T 
	ON				Q.Company				=				T.Company
	AND				Q.QuoteNum				=				T.Key1 

WHERE				T.CompleteDate			>=				@FechaDesde
--	AND				P.ProdCode				<>				'AA-SPLIT'

ORDER BY			T.ChangeDate, T.ChangeTime, Q.QuoteNum, QD.QuoteLine


*/


/*

UPDATE 				[CORPEPIDB].EpicorErp.Erp.QuoteHed_UD
SET					Plant_c					=				'CDEE'
WHERE				Plant_c					=				'MfgSys'
	AND				ForeignSysRowID			IN				('1F2F5B1B-60FC-4660-9E1C-60A082622791')

*/
