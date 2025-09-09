select				
					
					UDA.Company,
					UDA.Key1, UDA.Key2,
					UDA.Key3,																--AS		NroViaje,
					UDA.Key4, UDA.Key5,
					UDA.ChildKey1,
					UDA.ChildKey2,
					UDA.ChildKey3,
					UDA.ChildKey4,
					UDA.ChildKey5,
					UDA.CheckBox02															--AS		Conforme

from				[CORPEPIDB].EpicorERP.Ice.UD110A			UDA	WITH (NoLock)


INNER JOIN		
(
		select		CASE 
		WHEN LEN (SYE.NumeroRemito)				=			15	THEN SYE.NumeroRemito 
		ELSE
		CONCAT('R-',SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),1,4),'-', SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),5,8)
)		END AS NroRemito,* 

from 				[CORPSQLMULT01].RV_Remitos.dbo.SyncEpicor		SYE		WITH (NoLock)) AS A

ON					UDA.ShortChar07 			=			A.NroRemito  COLLATE Modern_Spanish_CI_AS 

Where				
					UDA.CheckBox02				=			0					
ORDER BY 1,3,4

-------------------------------
-------------------------------




select CASE 
WHEN LEN (SYE.NumeroRemito) =15 THEN SYE.NumeroRemito 
ELSE
CONCAT('R-',SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),1,4),'-', SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),5,8))  END AS NroRemito,
* 
from 			[CORPSQLMULT01].RV_Remitos.dbo.SyncEpicor		SYE		WITH (NoLock)
where
--SYE.FechaDigitalizacion			<>		SYE.FechaActualizacion
--SYE.FechaConforme is null and
SYE.DocId=43
ORDER BY 2 DESC 

Select * from  			[CORPSQLMULT01].RV_Remitos.dbo.SyncEpicor		SYE		WITH (NoLock)
