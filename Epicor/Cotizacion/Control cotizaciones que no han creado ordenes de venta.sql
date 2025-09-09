SET DATEFORMAT DMY 


SELECT Q.Company, Q.QuoteNum, Q.Ordered, Q.QuoteClosed, Q.EntryDate, Q.Reference, Q.TerritoryID, Q.ReasonType, Q.ChangedBy, Q.Plant_c, 
T.CompleteDate, T.ChangeDate, T.CreateOrder, 
CONVERT(CHAR(8), DATEADD(SECOND, T.ChangeTime, '0:00:00'), 108) AS ChangeTime, 
Q.CustID, Q.[Name], Q.ValidSoldTo 
FROM (
SELECT QH.Company, QH.QuoteNum, QH.EntryDate, QH.Reference, QH.TerritoryID, QH.ReasonType, QH.ChangedBy, QH.Ordered, 
QH.QuoteClosed, 
QHU.Plant_c, 
C.CustID, C.[Name], C.ValidSoldTo
FROM [CORPEPIDB].EpicorErp.Erp.QuoteHed QH WITH (NoLock) 
INNER JOIN [CORPEPIDB].EpicorErp.Erp.QuoteHed_UD QHU WITH (NoLock)
ON QH.SysRowID = QHU.ForeignSysRowID
INNER JOIN [CORPEPIDB].EpicorErp.Erp.Customer C WITH (NoLock)
ON QH.Company = C.Company
AND QH.CustNum = C.CustNum
WHERE QH.ReasonType = 'W'
AND NOT EXISTS (
SELECT *
FROM [CORPEPIDB].EpicorErp.Erp.OrderDtl OD WITH (NoLock)
WHERE OD.Company = QH.Company
AND OD.QuoteNum = QH.QuoteNum 
)
AND QH.ChangeDate >= '01/10/2021'
) Q
LEFT OUTER JOIN (
SELECT Company, RelatedToFile, Key1, StartDate, DueDate, ChangeDate, ChangeTime, CompleteDate, CreateOrder
FROM [CORPEPIDB].EpicorErp.Erp.Task T WITH (NoLock)
WHERE Conclusion = 'WIN'
) T 
ON Q.Company = T.Company
AND Q.QuoteNum = T.Key1 

WHERE T.CompleteDate >= '01/10/2021'

ORDER BY T.ChangeDate, T.ChangeTime, Q.QuoteNum 
