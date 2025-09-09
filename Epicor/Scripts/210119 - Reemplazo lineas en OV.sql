
DECLARE				@PartNumQuitar		VARCHAR(50)			=			'AND50P6UHD-F', 
					@PartNumCorrecto	VARCHAR(50)			=			'AND50P6UHD-B' 


/************************************************
Detalle de ordenes de venta
************************************************/


SET DATEFORMAT DMY

SELECT				C.Company, 
					C.CustID																			AS	CustomerCustID, 
	--				OH2.MaxOrderNum, 
					OH.OrderNum, OH.OrderDate,  OH.ShipToNum, OH.PONum, OH.ShipViaCode, OH.TermsCode, OH.CurrencyCode, OH.OrderComment,  
					OH.RequestDate, 
					LTRIM(RTRIM(STR(OD.OrderNum))) + ' / ' + LTRIM(RTRIM(STR(OD.OrderLine)))			AS	OrderComment2, 
					OD.QuoteNum, OD.QuoteLine, OD.PartNum, OD.UnitPrice, OD.LineDesc, 
					OD.DiscountPercent, OD.Discount, OD.ChangedBy, OD.OpenLine, OD.VoidLine, OD.LineStatus, 
					ORe.Plant, ORe.SellingStockQty, ORe.SellingStockShippedQty, 
					C.CustID, C.[Name], 
					@PartNumCorrecto																	AS	PartNumCorrecto
FROM				[CORPEPIDB].EpicorErp.Erp.OrderDtl			OD		WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.OrderRel			ORe		WITH (NoLock)
	ON				OD.Company			=			ORe.Company
	AND				OD.OrderNum			=			ORe.OrderNum
	AND				OD.OrderLine		=			Ore.OrderLine
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.OrderHed			OH		WITH (NoLock)
	ON				OD.Company			=			OH.Company
	AND				OD.OrderNum			=			OH.OrderNum
INNER JOIN			(
					SELECT				Company, MAX(OrderNum) AS MaxOrderNum
					FROM				[CORPEPIDB].EpicorErp.Erp.OrderHed					WITH (NoLock)
					GROUP BY			Company 
					)											OH2
	ON				OD.Company			=			OH2.Company
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer			C		WITH (NoLock)
	ON				OH.Company			=			C.Company
	AND				OH.CustNum			=			C.CustNum
WHERE				(
					OD.PartNum			=			@PartNumCorrecto					-- Debe permanecer
					OR
					OD.PartNum			=			@PartNumQuitar						-- Hay que quitar
					)
	AND				Ore.Plant			IN			('CDEE', 'MPlace')
	AND				OD.OpenLine			=			1
	AND				ORe.SellingStockQty	<>			ORe.SellingStockShippedQty
--	AND				OD.ChangedBy		=			'esalva'
-- /*
	AND				OD.OrderNum			NOT IN	
													(
'215165', '215542', '215479', '215595', '215543', '215519', '215544', '215348', '215545', '215382', '215546', '215305', '215547', '215470', '215548', '215364', 
'215549', '214708', '215550', '214846', '215551', '214428', '215552', '215141', '215553', '214815', '215554', '215311', '215555', '215172', '215556', '215499', 
'215557', '214825', '215558', '214753', '215559', '214830', '215560', '215296', '215561', '214694', '215562', '215225', '215563', '214831', '215564', '215513', 
'215565', '214911', '215566', '215006', '215602', '214826', '215568', '214827', '215569', '214755', '215570', '215044', '215571', '215101', '215572', '215267', 
'215573', '214883', '215574', '215473', '215575', '215241', '215576', '215485', '215577', '214805', '215578', '215337', '215579', '214761', '215580', '215180', 
'215581', '215308', '215582', '215353', '215355', '215583', '215584', '215366', '215585', '215362', '215586', '214757', '215587', '214914', '215588', '213747', 
'215589', '215162', '215590', '214837', '215591', '214838', '215592', '214836', '214919', '215593', '215594', '214834'
													)
-- */

ORDER BY			1, 2, 3, 4




