
DECLARE				@PartNum	VARCHAR(50)			=		'1202342-N'


SELECT				Company, OpenLine, ReqNum, ReqLine, PartNum, LineDesc, Class, PONUm, ReqDate, OrderQty 
FROM				[CORPEPIDB].EpicorErp.Erp.ReqDetail
WHERE				PartNum					=				@PartNum
ORDER BY			ReqNum, ReqLine 

SELECT				Company, SugNum, BuyerID, RelQty, PartNum, LineDesc, CommentText, ClassID, ReqNum, ReqLine, Plant 
FROM				[CORPEPIDB].EpicorErp.Erp.SugPoDtl 
WHERE				PartNum					=				@PartNum
ORDER BY			ReqNum, ReqLine 

