use [moviventas]

select * from [CORPSQLMULT2019].[moviventas].dbo.users
where blocked=0
and [disabled]=0
AND id not in ('wrosario','wrosario-vta','fmastronardi','fmastronarditest','ccastillo','gsalinas','admin')

--Habilitar:
begin tran
update users
set blocked=0
where blocked=1
and [disabled]=0
AND id not in ('wrosario','wrosario-vta','fmastronardi','fmastronarditest','ccastillo','gsalinas','admin')

--commit tran
rollback tran

--Deshabiitar:
begin tran
update users
set blocked=1
where  blocked=0
and [disabled]=0
AND id not in ('wrosario','wrosario-vta','fmastronardi','fmastronarditest','ccastillo','gsalinas','admin')
--commit tran
rollback tran