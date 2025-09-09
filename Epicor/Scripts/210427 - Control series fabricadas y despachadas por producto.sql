
SET DATEFORMAT DMY

DECLARE			@PartNum1		VARCHAR(50) =	'L75P8M', 
				@PartNum2		VARCHAR(50) =	'L75P8M', 
				@FechaDesde		DATETIME	=	'01/12/2020'

-----------------------------------------

SELECT			Company, PartNum, SerialNumber, TranNum, TranType, JobNum , TranDate
FROM			[CORPEPIDB].EpicorErp.Erp.SNTran												WITH (NoLock)
WHERE			TranType			IN				('MFG-STK')					-- Produccion
	AND			TranDate			>=				@FechaDesde
	AND			PartNum				IN				(@PartNum1, @PartNum2)

-----------------------------------------

SELECT			Company, PartNum, SerialNumber, TranNum, TranType, PackNum , TranDate 
FROM			[CORPEPIDB].EpicorErp.Erp.SNTran												WITH (NoLock)
WHERE			TranType			IN				('STK-CUS')					-- Produccion
	AND			TranDate			>=				@FechaDesde
	AND			PartNum				IN				(@PartNum1, @PartNum2)
	
-----------------------------------------
