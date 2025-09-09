select InvoiceComment,* from erp.InvcHead
where InvoiceNum='12642'

begin tran

update erp.InvcHead
set InvoiceComment='Prueba XML'
where InvoiceNum='12642'

commit tran
rollback tran

select InvoiceComment,* from erp.InvcHead
where LegalNumber like 'FEE-%'
order by InvoiceNum

