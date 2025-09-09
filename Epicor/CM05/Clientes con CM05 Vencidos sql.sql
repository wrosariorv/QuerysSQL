select * from (

						SELECT						C.Company, C.CustNum, C.CustID, C.[Name], x.AGAFIPResponsibilityCode,x.ReminderCode,Y.InvoiceDate,Y.InvoiceNum,
						--C.EMailAddress,
													--CC.EMailAddress, CC.ReportsTo,
													CASE
														WHEN CC.EMailAddress <> ''
														THEN CC.EMailAddress
													ELSE	CASE
																WHEN C.EMailAddress <> ''
																THEN C.EMailAddress
															ELSE CC.ReportsTo
															END
													END AS EMailAddress



						FROM						[CORPEPIDB].EpicorErp.Erp.Customer C WITH (NoLock)
						LEFT OUTER JOIN				(
													SELECT *
													FROM [CORPEPIDB].EpicorErp.Erp.CustCnt WITH (NoLock)
													WHERE ShipToNum = ''
													) CC
						ON				C.Company	=		CC.Company
						AND				C.CustNum	=		CC.CustNum
						AND				C.PrimBCon	=		CC.ConNum

						INNER JOIN (
										SELECT		a.Company, a.CustID, a.CustNum,

													a.EstadoCM AS EstadoCM
										FROM		RVF_VW_CLIE_CM05 a WITH(NoLock)
										WHERE		a.Company = 'CO01'
											AND		a.EstadoCM ='CM05 Vencido'
										GROUP BY	a.Company, a.CustID, a.CustNum, a.EstadoCM



									) AS D
						ON				c.Company		 =		d.Company
						AND				c.CustNum		=		d.CustNum
						Inner JOIN		(
											Select Company, Custnum ,AGAFIPResponsibilityCode,ReminderCode from	[CORPEPIDB].EpicorErp.Erp.Customer
										) AS X
						ON				X.Company			=			D.Company
						AND				X.CustNum			=			D.CustNum
						LEFT JOIN		(
											Select			CH.Company, CH.Custnum,MAX(CH.InvoiceDate) AS InvoiceDate ,MAX(CH.InvoiceNum  ) AS InvoiceNum
											from			[CORPEPIDB].EpicorErp.Erp.InvcHead		CH
											where			Convert( date, CH.InvoiceDate) between '2020-05-05' and '2022-05-05'
											Group by		CH.Company, CH.Custnum

										) AS Y
						ON				Y.Company			=			D.Company
						AND				Y.CustNum			=			D.CustNum
						Where
						x.ReminderCode not in ('Outlet','Interemp')
						AND		Y.InvoiceDate is not null
						--x.AGAFIPResponsibilityCode='CF'

						--ORDER BY		C.Company, C.CustID, y.InvoiceDate
			)w
where w.EMailAddress is null


Select			CH.Company, CH.Custnum,MAX(CH.InvoiceDate) AS InvoiceDate ,MAX(CH.InvoiceNum  ) AS InvoiceNum
from			[CORPEPIDB].EpicorErp.Erp.InvcHead		CH
where			Convert( date, CH.InvoiceDate) between '2020-05-05' and '2022-05-05'
Group by		CH.Company, CH.Custnum



Select			CH.Company, CH.Custnum,MAX(CH.TranDate) AS TranDate ,MAX(CH.InvoiceNum  ) AS InvoiceNum
from			[CORPEPIDB].EpicorErp.Erp.CashHead		CH
where			Convert( date, CH.TranDate) between '2020-05-05' and '2022-05-05'
Group by		CH.Company, CH.Custnum