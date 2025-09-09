
CREATE PROCEDURE	RVF_PRC_INV_CONTROL_PRODUCTO_SERIE_ECA
					@Company				VARCHAR(15)		=		'CO01', 
					@PartNum				VARCHAR(50)	

AS


/*

------------------------------------------------------------------------------------------

DECLARE				@Company				VARCHAR(15)		=		'CO01', 
					@PartNum				VARCHAR(50)		=		'T671E1-FAAVAR11' 
				
------------------------------------------------------------------------------------------

*/

DECLARE				@TranType				VARCHAR(15)		=		'STK-PLT', 
					@SNStatus				VARCHAR(15)		=		'INVENTORY'

------------------------------------------------------------------------------------------

SELECT				SNT.Company, SNT.PartNum, SNT.SerialNumber, SNT.TranType, SNT.WareHouseCode, SNT.TFPackNum, SNT.TFPackLine, 
					SNT.BinNum										AS		ECA, 
					SN.SNStatus, SN.SNReference, 
					P.SearchWord, P.PartDescription 
FROM				[CORPEPIDB].EpicorErp.Erp.SNTran						SNT			WITH(NoLock)
INNER JOIN			(
					SELECT				Company, PartNum, SerialNumber, SNStatus, SNReference 
					FROM				[CORPEPIDB].EpicorErp.Erp.SerialNo
					WHERE				PartNum				=			@PartNum
						AND				SNStatus			=			@SNStatus
					)		SN
	ON				SNT.Company				=			SN.Company
	AND				SNT.SerialNumber		=			SN.SerialNumber
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part							P			WITH(NoLock)
	ON				SNT.Company				=			P.Company
	AND				SNT.PartNum				=			P.PartNum 

WHERE				SNT.TranType			=			@TranType



