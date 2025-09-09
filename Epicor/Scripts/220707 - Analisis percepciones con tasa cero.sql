

/*************************************************

Se listan las transacciones de ventas que tienen registrados montos de impuestos, pero donde la alicuota indicada es cero.

*************************************************/

SET DATEFORMAT DMY


DECLARE				@FechaDesde		DATE		=		'01/01/2022', 
					@FechaHasta		DATE		=		'30/06/2022'


SELECT				IT.Company, IT.InvoiceNum, IT.InvoiceLine, IT.TaxCode, IT.TaxAmt, IT.ExemptPercent, IT.ChangedBy, IT.ChangeDate, 
					IT.[Percent]										AS	TaxPercent, 
					IT.[Manual]											AS	ChangedManual, 
					IH.LegalNumber, IH.InvoiceDate, 
					C.CustID, 
					C.[Name]											AS	CustName, 
					ST.[Description]									AS	TaxDescription

FROM				[CORPEPIDB].EpicorErp.Erp.InvcHead				IH				WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcTax				IT				WITH(NoLock)
	ON				IH.Company					=				IT.Company
	AND				IH.InvoiceNum				=				IT.InvoiceNum
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer				C				WITH(NoLock)
	ON				IH.Company					=				C.Company
	AND				IH.CustNum					=				C.CustNum
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.SalesTax				ST				WITH(NoLock)
	ON				IT.Company					=				ST.Company
	AND				IT.TaxCode					=				ST.TaxCode

WHERE				IH.InvoiceDate				BETWEEN			@FechaDesde		AND		@FechaHasta
	AND				IT.TaxAmt					<>				0
	AND				IT.ExemptPercent			=				0
	AND				IT.[Percent]				=				0

