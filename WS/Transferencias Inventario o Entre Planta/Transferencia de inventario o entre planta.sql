SET DATEFORMAT DMY
select --top 1000
		EntryPerson,TranReference,* from PartTran
where /*TranDate='28-10-2022'
AND		*/EntryPerson='Usr_TRANSFER'
AND			TranReference='CD-MP-00000554'
--AND			SysDate='2023-12-27'
order by TranNum, 2 ASC

SET DATEFORMAT DMY
select top 1000 EntryPerson,TranReference,* from PartTran
where TranDate='27-10-2022'

--STK-PLT Despacho
--PLT-STK Re


select top 3000* from PartTran
where PartNum ='TACA-3300FCSA/EL UI'
order by TranDate DESC



select			Company,  EntryPerson,TranReference, PartNum, TranType, SUM(TranQty) AS TotalTrasnferido , WareHouseCode,WareHouse2,BinNum,BinNum2
from			PartTran
where			EntryPerson='Usr_TRANSFER'
AND				TranReference='CD-MP-00000554'
--AND				SysDate='2023-12-28'
Group by		Company,  EntryPerson,TranReference, PartNum, TranType, WareHouseCode,WareHouse2,BinNum,BinNum2