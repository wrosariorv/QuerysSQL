select d.CodVendedor from erp.OrderHed a
inner join erp.Customer C
On		a.Company		=		c.Company
and		a.CustNum		=		c.CustNum
Right join [CORPEPISSRS01].[RVF_Local].dbo.RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES d
ON			d.Compania	=	a.Company
and			d.CodigoCliente	=	c.CustID
and			d.CodigoDomicilio	=	a.ShipToNum

where 
OrderNum in (
'164850',
'164850',
'164850'
)

group by d.CodVendedor
Order by 1

select DcdUserID,* from erp.SaleAuth
where DcdUserID like '%hsanchez%'
order by 1

select DcdUserID,* from erp.SaleAuth
where DcdUserID like '%jzaleh%'
order by 1


select e.SalesRepCode from erp.OrderHed a
inner join erp.Customer C
On		a.Company		=		c.Company
and		a.CustNum		=		c.CustNum
Right join [CORPEPISSRS01].[RVF_Local].dbo.RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES d
ON			d.Compania	=	a.Company
and			d.CodigoCliente	=	c.CustID
and			d.CodigoDomicilio	=	a.ShipToNum
Right Join	erp.SaleAuth	e
on		e.Company		=		d.Compania
and		e.SalesRepCode	=		d.CodVendedor	
where 
OrderNum in (
'164850',
'164850',
'164850'

)
and e.DcdUserID  not in ('hsanchez')
group by e.SalesRepCode
Order by 1



SELECT SR.Company, SR.SalesRepCode, SR.[Name],
SA.DcdUserID
FROM [CORPEPIDB].EpicorErp.Erp.SalesRep SR WITH (NoLock)
LEFT OUTER JOIN (
SELECT *
FROM [CORPEPIDB].EpicorErp.Erp.SaleAuth WITH (NoLock)
WHERE DcdUserID IN ('jzaleh')
) SA
ON SA.Company = SR.Company
AND SA.SalesRepCode = SR.SalesRepCode

WHERE SR.Company = 'CO01'
AND (
SR.SalesRepCode LIKE 'A%'
OR SR.SalesRepCode LIKE 'KEL%'
OR SR.SalesRepCode LIKE 'HIT%'
OR SR.SalesRepCode LIKE 'RCA%'
OR SR.SalesRepCode LIKE 'TCL%'
OR SR.SalesRepCode LIKE 'MPL%'
)
AND SR.SalesRepCode NOT LIKE 'AGR%'
AND SA.DcdUserID is not null
AND SR.SalesRepCode not IN (
'A_28',
'A_71',
'A_72',
'A_91',
'A_92',
'A_93',
'A_94',
'A_95',
'A_96',
'A_97',
'A_98',
'A_99',
'ALC28',
'ALC71',
'ALC72',
'ALC91',
'ALC92',
'ALC93',
'ALC94',
'ALC95',
'ALC96',
'ALC97',
'ALC98',
'ALC99',
'HIT28',
'HIT71',
'HIT72',
'HIT90',
'HIT91',
'HIT92',
'HIT93',
'HIT94',
'HIT95',
'HIT96',
'HIT97',
'HIT98',
'HIT99',
'KEL28',
'KEL71',
'KEL72',
'KEL90',
'KEL91',
'KEL92',
'KEL93',
'KEL94',
'KEL95',
'KEL96',
'KEL97',
'KEL98',
'KEL99',
'RCA28',
'RCA71',
'RCA72',
'RCA90',
'RCA91',
'RCA92',
'RCA93',
'RCA94',
'RCA95',
'RCA96',
'RCA97',
'RCA98',
'RCA99',
'TCL28',
'TCL71',
'TCL72',
'TCL90',
'TCL91',
'TCL92',
'TCL93',
'TCL94',
'TCL95',
'TCL96',
'TCL97',
'TCL98',
'TCL99'
)