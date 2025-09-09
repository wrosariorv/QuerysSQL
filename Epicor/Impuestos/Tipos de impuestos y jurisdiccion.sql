select					
						SUD.Character01,
						ST.RptCatCode,
						TC.[Description],
						SUD.Character02 AS Ruta 

from					[CORPEPIDB].[EpicorERP].erp.SalesTax		ST

inner join				[CORPEPIDB].[EpicorERP].erp.SalesTax_UD		SUD

On						ST.SysRowID				=			SUD.ForeignSysRowID

and						ST.taxjuriscode			=			SUD.Character01

inner join				[CORPEPIDB].[EpicorERP].erp.TaxRptCat		TC

on						st.company				=			TC.company

and						ST.RptCatCode			=			TC.RptCatCode

where
						SUD.Character01			<>			''

group by				SUD.Character01, ST.RptCatCode,TC.[Description], SUD.Character02 

Order by 1,2

select TaxJurisCode, Description from [CORPEPIDB].[EpicorERP].ERP.TaxJuris  where Company = 'CO01' order by TaxJurisCode



