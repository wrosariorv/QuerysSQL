
SET DATEFORMAT DMY 


SELECT				T.Company, T.Key1, T.TaskID, T.TaskDescription, T.SalesRepCode, T.StartDate, T.CompleteDate, T.ChangeDcdUserID, T.Conclusion, 
					TU.Character02, 
					TU.PAC_Overdue_c, 
					TU.PAC_OverdueAmt_c,
					TU.PAC_CreditExcedeed_c,
					TU.PAC_CreditExcedeedAmt_c,
					TU.PAC_ProcessUpdDate_c,
					TU.PAC_ProcessUpdTime_c,
					TU.PAC_CreditLimit_c, 
					TU.PAC_QuoteTotalAmt_c, 
					TU.PAC_OnActFutOp_C  
FROM				[CORPEPIDB].EpicorErp.Erp.Task			T				WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Task_UD		TU				WITH(NoLock)
	ON				T.SysRowID				=				TU.ForeignSysRowID 
WHERE				T.RelatedToFile			=				'QuoteHed'
	AND				T.TaskID				IN				('AUT06')
	AND				T.StartDate				>=				'01/08/2021'
	AND				T.CompleteDate			IS NULL
ORDER By			T.StartDate DESC, Key1 DESC



