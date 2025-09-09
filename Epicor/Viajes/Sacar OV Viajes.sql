
select		Company,
			ChildKey1,
			key3,			-- viaje
			ChildKey2,		--  Nro de orden Viaje
			number01,		-- ov
			number02,		-- linea
			number03,		-- liberacion
			number06,		-- remito o empake
			number08,		-- factura interno
			shortchar09,	-- factura
			shortchar07,	-- remito
			*
from EpicorERP.Ice.UD110A
where /*key3 = '00030951'
and */key1='ViajeCab'
and number01=218222
and number02=3
and number03=1

begin tran
Delete  [CORPEPIDB].EpicorERP.Ice.UD110A
where  key3 = '00030951'
and key1='ViajeCab'
and number01=156204
and number02=3
and number03=1

--commit tran
rollback tran

select		Company,
			ChildKey1,
			key3,			-- viaje
			ChildKey2,		--  Nro de orden Viaje
			number01,		-- ov
			number02,		-- linea
			number03,		-- liberacion
			number06,		-- remito o empake
			number08,		-- factura interno
			shortchar09,	-- factura
			shortchar07,	-- remito
			*
from [E10-BD].EpicorERP.Ice.UD110A
where key3 = '00022593'
and key1='ViajeCab'
and number01=106668
--order by key3 desc

/*
key3 - viaje
number01 - ov
number02 - linea
number03 - liberacion
number06 - remito o empake
number08 - factura interno
shortchar09 - factura
shortchar07 - remito
ChildKey2  -  Nro de orden Viaje
*/


--Encabezado del Viaje
select *
from [E10-BD].EpicorERP.Ice.UD110
where key3 = '00022593'
and key1='ViajeCab'
order by key3 desc
