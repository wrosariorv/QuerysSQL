----------------------------------------------------
--Busca  cliente por CustID
----------------------------------------------------
SELECT Company,	CustID,	CustNum,ChangeDate,* 
FROM			[CORPEPIDB].EpicorErp.ERP.Customer
where			CUSTID	like		'M0%'



SELECT AGProvincecode,* 
FROM			[CORPEPIDB].EpicorErp.ERP.Customer
where			CUSTID	like		'M0%'
/*
select * 
FROM			[CORPEPIDB].EpicorErp.ICE.UD01
WHERE			company		=			'CO01'
and				key1		=			('CM05')
and				key2		=			'8490'
*/
----------------------------------------------------
--Busca OV por cliente
----------------------------------------------------
Select  ChangeDate,ShipToNum,SysRowID,* from	[CORPEPIDB].EpicorErp.ERP.OrderHed
where Custnum  in (	'8640','8642','8649','8682','8737','8881')
order by OrderNum

Select * from	[CORPEPIDB].EpicorErp.ERP.OrderHed
where Custnum  in ('8891', '8892', '8893', '8894', '8895', '8896', '8897', '8898', '8902', '8903')
order by Ordernum, PONUM

Select  * from	[CORPEPIDB].EpicorErp.ERP.OrderDtl
where Custnum  in ('8891', '8892', '8893', '8894', '8895', '8896', '8897', '8898', '8902', '8903')

select * from [CORPEPIDB].EpicorErp.ERP.ShipTo
where ShipToNum in ('MPL-99','HIT-99')
AND custnum in ('6558','8881')

Select  ChangeDate,ShipToNum,* from	[CORPEPIDB].EpicorErp.ERP.OrderDtl
where Custnum  in (	'8640','8642','8649','8682','8737','8881')


select top 100 Character02,* from [CORPEPIDB].EpicorErp.ERP.OrderHed_UD
where
ForeignSysRowID = 'DE7DE290-065F-4A09-BC81-5470F810C6E4'

select ShipToNum, * from [CORPEPIDB].EpicorErp.ERP.Customer
where Custnum  in (	'8881')

select top 100 SysRowID,* from [CORPEPIDB].EpicorErp.erp.ShipTo
where ShiptoNum='MPL-99'

select top 100 Character02,* from [CORPEPIDB].EpicorErp.erp.ShipTo_UD
where
ForeignSysRowID='D94BE25C-D792-49F5-B558-CEB7711456AD'
select OrderNum
from	[CORPEPIDB].EpicorErp.ERP.OrderDtl
where Custnum in (	'8640','8641','8642','8643','8644','8645','8646','8649','8650','8651','8652')

group by OrderNum


----------------------------------------------------
--Busca Encabezado de gastos Miscelaneos
----------------------------------------------------

select RlsClassCode,* from [CORPEPIDB].EpicorErp.ERP.RlsHead



----------------------------------------------------
--Busca Error por en integracion por Feha
----------------------------------------------------
select [Company], [Key1], [Key2], [Key3], [Key4], [Key5], [ShortChar01], [Number01], [Number02],  [ShortChar05],[Date01] 
from [CORPEPIDB].EpicorErp.[Ice].[UD35]
where [Key1]='SC VENTAS WEB'
order by date01
----------------------------------------------------
--Busca Remito por N° de empaque
----------------------------------------------------
select top 10 * from [CORPEPIDB].EpicorErp.ERP.Shiphead
where packnum in ('190221','190084','190616')

select top 10 * from [CORPEPIDB].EpicorErp.ERP.ShipDtl
where packnum in ('190221','190084','190616')

----------------------------------------------------
--Busca Shipto por cliente
----------------------------------------------------
select * from [CORPEPIDB].EpicorErp.ERP.ShipTo
where ShipToNum in ('MPL-99')
AND custnum in (
'8891',
'8892',
'8893',
'8894',
'8895',
'8896',
'8897',
'8898',
'8902',
'8903'
)
