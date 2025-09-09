-------------------------------
Select legalnumber,* from [CORPEPIDB].EpicorERP.ERP.Invchead
where legalnumber IN ('NC-A-0239-00000916')

Select TOP 10 * from [CORPEPIDB].EpicorERP.ERP.InvcDtl
where InvoiceNum
 IN ('273211')

 Select TOP 10 legalnumber,* from [CORPEPIDB].EpicorERP.ERP.Invchead
where Posted=1
and InvoiceAmt='0.01'
and InvoiceDate BETWEEN '2021-05-01' AND '2021-07-01'
ORDER BY InvoiceDate ASC

 Select TOP 10 legalnumber,* from [CORPEPIDB].EpicorERP.ERP.Invchead
where InvoiceNum IN ('273211','271502')

Select TOP 10 * from [CORPEPIDB].EpicorERP.ERP.InvcDtl
where InvoiceNum IN ('273211','271502','203086')


select top 10 * from [CORPEPIDB].EpicorERP.ERP.InvcDtl
where PartNum like 'RHS5100FC-SK'

select top 10 * from [CORPEPIDB].EpicorERP.ERP.InvcDtl_UD
where InvoiceNum IN ('273211','271502','203086')