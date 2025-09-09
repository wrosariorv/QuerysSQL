
USE	RVF_Local

SET DATEFORMAT DMY

SELECT			*
FROM			[dbo].[RVF_VW_IMP_RECIBO_HEADER]										WITH(NoLock)


SELECT			Company, Posted, GroupID, TranDate, HeadNum, CheckRef, TranAmt, Reference, LegalNumber, OtherDetails 
FROM			[CORPEPIDB].EpicorErp.Erp.CashHead										WITH(NoLock)
WHERE			TranDate				>=				'01/04/2021'
	AND			OtherDetails			<>				''
	AND			Posted					=				0
ORDER BY		HeadNum DESC


SELECT			*
FROM			RVF_Local.dbo.RVF_VW_MOVI_ESTADO_COBRANZAS								WITH(NoLock)
ORDER BY		OtherDetails DESC 

