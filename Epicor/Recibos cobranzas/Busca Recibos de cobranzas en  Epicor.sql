
select			
				*
FROM			[CORPE11-EPIDB].EpicorErp.Erp.CashHead							CH
where			
----				GroupID='CE000383'
----OR				
				HeadNum=350934
OR				
				LegalNumber='RC-E3-000000000383'

OR				CheckRef ='RC-E3-000000000383'


select			top 10
				*
FROM			[CORPE11-EPIDB].EpicorErp.Erp.Cashdtl							CH
where			
				GroupID='CE000383'
OR				
				HeadNum=350934



				select * from [CORPE11-EPIDB].EpicorErp.Erp.Customer
				where name like '%Ecommerce%'