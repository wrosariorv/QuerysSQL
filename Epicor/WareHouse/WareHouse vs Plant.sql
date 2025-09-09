





DECLARE		@Company	nvarchar(10)	=		'CO01',
			@PartNum	nvarchar(50)	=		'ZTE BLADE A5 PLUS',
			@Plant		nvarchar(10)	=		'FRA640'


SELECT				PW.Company, PW.PartNum, PW.WareHouseCode, W.Plant  
					
FROM				
					[CORPEPIDB].EpicorERP.Erp.PartWhse				PW		WITH (NoLock)
					
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.WareHse				W		WITH (NoLock)
	ON				PW.Company			=		W.Company
	AND				PW.WareHouseCode	=		W.WareHouseCode

WHERE				
					PW.Company			=		@Company
AND					PW.Partnum			=		@PartNum
AND					W.Plant				=		@Plant
AND					(
					PW.DemandQty			<>		0		OR
					PW.ReservedQty			<>		0		OR
					PW.AllocatedQty			<>		0		OR
					PW.PickingQty			<>		0		OR
					PW.PickedQty			<>		0		OR
					PW.OnHandQty			<>		0		OR
					PW.NonNettableQty		<>		0		OR
					PW.SalesDemandQty		<>		0		OR 
					PW.SalesReservedQty		<>		0		OR 
					PW.SalesAllocatedQty	<>		0		OR 
					PW.SalesPickingQty		<>		0		OR 
					PW.SalesPickedQty		<>		0 
					)



