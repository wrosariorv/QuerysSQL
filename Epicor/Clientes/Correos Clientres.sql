select * from (

						SELECT						C.Company, C.CustNum, C.CustID, C.[Name], C.AGAFIPResponsibilityCode,c.ReminderCode,--Y.InvoiceDate,Y.InvoiceNum,
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
						INNER JOIN				(
													SELECT *
													FROM [CORPEPIDB].EpicorErp.Erp.CustCnt WITH (NoLock)
													WHERE ShipToNum = ''
													) CC
						ON				C.Company	=		CC.Company
						AND				C.CustNum	=		CC.CustNum
						AND				C.PrimBCon	=		CC.ConNum


						Where
						C.ReminderCode not in ('Outlet','Interemp')


						--ORDER BY		C.Company, C.CustID, y.InvoiceDate
			)w
where w.EMailAddress <>''


