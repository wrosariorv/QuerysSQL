SELECT                Company, BuyerID, [Name], InActive, ApprovalPerson, POLimit,ApprovalPerson
FROM                CORPEPIDB.EpicorErp.Erp.PurAgent
WHERE				InActive <>0
AND					Company		='CO01'
--AND					POLimit		=0

SELECT                Company, BuyerID, [Name], InActive, ApprovalPerson, POLimit,ApprovalPerson
FROM                CORPEPIDB.EpicorErp.Erp.PurAgent
WHERE				InActive =0
--AND					POLimit=0
AND					Company		='CO03'
AND					ApprovalPerson <>''
Order by			3