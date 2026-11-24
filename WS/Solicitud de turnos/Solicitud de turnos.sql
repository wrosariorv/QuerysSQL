select * from [CORPP11-EPIDB].[EpicorERP].Erp.OrderRel_ud
where Number04=287037

select B.* from [CORPP11-EPIDB].[EpicorERP].Erp.OrderRel A
inner join [CORPP11-EPIDB].[EpicorERP].Erp.OrderRel_ud B
ON		A.SysRowID = B.ForeignSysRowID
where A.OrderNum=287037