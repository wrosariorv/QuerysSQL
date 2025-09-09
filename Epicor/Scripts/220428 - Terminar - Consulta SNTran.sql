

------------------------------------------------------------------------------------------
-- /*

DECLARE				@Company				VARCHAR(15)		=		'CO01', 
					@PartNum				VARCHAR(50)		=		'T766J-FAAVAR11' 

-- */				
------------------------------------------------------------------------------------------

DECLARE				@TranType				VARCHAR(15)		=		'STK-PLT', 
					@SNStatus				VARCHAR(15)		=		'INVENTORY', 
					@Plant					VARCHAR(15)		=		'MfgSys'

------------------------------------------------------------------------------------------

SELECT				SNT.Company, SNT.PartNum, SNT.SerialNumber, SNT.TranType, SNT.WareHouseCode, SNT.TFPackNum, SNT.TFPackLine, 
					SNT.BinNum										AS		ECA, 
					SN.SNStatus, SN.SNReference  
FROM				[CORPEPIDB].EpicorErp.Erp.SNTran						SNT			WITH(NoLock)

INNER JOIN			(
					SELECT				Company, PartNum, SerialNumber, SNStatus, SNReference 
					FROM				[CORPEPIDB].EpicorErp.Erp.SerialNo				WITH(NoLock)
					WHERE				PartNum				=			@PartNum
						AND				SNStatus			=			@SNStatus
					)		SN
	ON				SNT.Company				=			SN.Company
	AND				SNT.SerialNumber		=			SN.SerialNumber

WHERE				SNT.TranType			=			@TranType


