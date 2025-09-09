



select * from erp.OrderHed
where OrderNum='193894'

select * from erp.OrderDtl
where OrderNum='193894'

--Busca las ov de generadas con productos para cubir con mercaderia para fabricar
Select 
				a.Company, a.OrderNum, a.CustNum, w.Plant, b.OpenLine,b.OrderLine, b.PartNum,
				w.OrderRelNum, w.Make
from				erp.OrderHed A
Inner join			erp.orderdtl b
ON		a.Company		=			b.Company
AND		a.OrderNum		=			b.OrderNum
Inner join	
(
--select c.Company ,c.ordernum,c.OrderLine,c.OrderRelNum, c.Make from erp.OrderRel C
--where OrderNum>='193905'
--and Make=1
select c.Company ,c.ordernum,c.OrderLine,c.Plant,c.OrderRelNum, c.Make from erp.OrderRel C
where  Make=1

) AS W
ON		b.Company		=		w.Company
AND		b.OrderNum		=		w.OrderNum
and		b.OrderLine		=		w.OrderLine
where b.OpenLine <>'0'


order by 2

select c.Company ,c.ordernum,c.OrderLine,c.Plant,c.OrderRelNum, c.Make from erp.OrderRel C
where OrderNum in (
'193905',
'193911',
'193912',
'193936',
'193937',
'193938',
'193974',
'193977',
'193989',
'194005',
'194017',
'194049',
'194108',
'194132'
)
and Make=1

---Busca las partes que tenga mal la marca de no existencia
select				a.NonStock,b.ProdCode,b.ClassID,*
From				erp.PartPlant a
inner join			erp.Part b
on		a.Company		= b.Company
and		a.PartNum		=		b.PartNum
where a.NonStock=1
and b.ClassID in ('PTF','PTCO','SUBA','SUCO','SK','SKCO','REVI','REVN','MUI','MUN')
 and b.ProdCode not in ('DIFPRECO','ACUSUP','INFINCNP','ACUTCL','ACURCA',
'ADHBSAS',
'ADHBSAS',
'ADHBSAS',
'ADHBSAS',
'GCEXT',
'DCPR',
'ALQINM',
'ALQINNP',
'ANCLPRRF',
'ANCLPRRK',
'ANCLRO',
'ANCLRT'
)


