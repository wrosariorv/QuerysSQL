select * from			erp.OrderDtl
where
						OrderNum		in
											(
											'155469'
											)
AND						OrderLine		=	'1'

OR
OrderNum		in
											(
											'155159'
											)
AND						OrderLine		=	'1'

OR
OrderNum		in
											(
											'155556'
											)
AND						OrderLine		=	'1'

OR
OrderNum		in
											(
											'155556'
											)
AND						OrderLine		=	'1'

OR
OrderNum		in
											(
											'155405'
											)
AND						OrderLine		=	'1'

OR
OrderNum		in
											(
											'155325'
											)
AND						OrderLine		=	'2'


set dateformat dmy
select		 ShipPerson,	CreatedOn,ShipStatus,ChangeDate,CreatedOn,	*
FROM				ERP.ShipHead
where 
ShipPerson		='Usr_CDEE'
--and ShipToNum	in ('MPL-99')
AND ShipStatus ='CLOSED'
--AND ChangedBy='manager'
AND CAST(CreatedOn AS DATE) = '15-09-2021'

order by		2 desc


Select * from erp.InvcHead
where LegalNumber ='FC-A-0030-00000151'