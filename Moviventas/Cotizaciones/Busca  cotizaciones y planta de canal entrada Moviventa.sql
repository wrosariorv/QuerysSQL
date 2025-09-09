Select * from RVF_TBL_IMP_QUOTE_LOG
where CotizacionEpicor ='134634'

set DATEFORMAT DMY
Select				c.Plant_c, b.*, a.*				
from				[CORPEPIDB].[EpicorERP].[erp].QuoteHed a
Inner join			RVF_TBL_IMP_QUOTE_LOG		b
ON					a.quotenum			=			CotizacionEpicor
Inner join			[CORPEPIDB].[EpicorERP].[erp].QuoteHed_UD c
ON					a.sysrowID			=			c.ForeignSysRowID
where 
					a.company ='CO01'
 and				CONVERT(date,FechaProceso ) BETWEEN  '19-11-2021' and  GETDATE()
order by 6


