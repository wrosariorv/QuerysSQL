SELECT				a.[Group_ID], a.[Company], a.[Plant], a.[PartNum], a.[SerialNumber], a.[WareHouseCode], a.[BinNum], a.[SNReference]
from				RVF_TBL_UPDATE_SERIAL_NUMBER a
LEFT JOIN
					( Select * from RVF_TBL_UPDATE_SERIAL_LOG ) b
ON					a.Group_ID		=			b.Group_ID
AND					a.Company		=			b.Company
AND					a.Plant			=			b.Plant
AND					a.PartNum		=			b.PartNum
AND					a.SerialNumber	=			b.SerialNumber

where				B.Group_ID is null 
and					A.Plant = 'CDEE'

AND					a.Group_ID IN (
										Select TOP 1		c.Group_ID
										from				RVF_TBL_UPDATE_SERIAL_NUMBER c
										LEFT JOIN
													(
																Select		Group_ID,
																			Company,
																			Plant,
																			PartNum,
																			SerialNumber
																from		RVF_TBL_UPDATE_SERIAL_LOG
													) d
										ON
															c.Group_ID		=		d.Group_ID
										AND					c.Company		=		d.Company
										AND					c.Plant			=		d.Plant
										AND					c.PartNum		=		d.PartNum
										AND					C.SerialNumber	=		d.SerialNumber
										where				d.Group_Id is null
)

select * from [CORPEPISSRS01].[RVF_Local].dbo.[RVF_TBL_UPDATE_SERIAL_NUMBER]

select * from [CORPEPISSRS01].[RVF_Local].dbo.[RVF_TBL_UPDATE_SERIAL_LOG]

--Captura de errrores

Select 
			[Company], [Key1], [Key2], [Key3], [Key4], [ShortChar01], [ShortChar02], [ShortChar03], [ShortChar04],[Date01]


FROM		[CORPEPIDB].[EpicorERP].[Ice].[UD35]

where		
			[Key1]		=		'SC UPDATE SERIES'

order by Key2 desc
