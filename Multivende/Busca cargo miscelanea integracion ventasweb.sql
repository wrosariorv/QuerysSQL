Select  * from	[CORPEPIDB].EpicorErp.ERP.OrderDtl d
where exists (SELECT CustNum
FROM			[CORPEPIDB].EpicorErp.ERP.Customer c
where			c.CUSTID	like		'M0%'
AND				c.CustNum	=		d.CustNum)
AND	d.PartNum		like '%SK%'


select * from erp.OrderMsc
where ordernum in (
'161941',
'161950',
'166279',
'195759',
'195917'
)

select * from Erp.InvcHead
where OrderNum in (
'161941',
'161950',
'166279',
'195759',
'195917'
)

select * from erp.InvcMisc
where InvoiceNum in (
'294727',
'294728',
'297927'
)