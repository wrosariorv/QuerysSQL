
SET DATEFORMAT DMY

----------------------------------------------------------------------------------

DECLARE				@Company		VARCHAR(15)		=		'CO01', 
					@FechaDesde		DATE			=		'01/10/2021', 
					@FechaHasta		DATE			=		'31/03/2022'

----------------------------------------------------------------------------------

SELECT				CH.Company, 
					CH.Posted, 
					CH.GroupID, 
					CH.CheckDate, 
					CH.FiscalYear, 
					CH.FiscalPeriod, 
					CH.Voided, 
					CH.CheckNum											AS NumeroOrdenPago, 
					CH.CheckAmt											AS MontoPago_Neto,  
					V.VendorID, 
					V.[Name], 
					V.TaxPayerID, 
					B.InvoiceAmt										AS TotalFacturas, 
					B.TaxAmt											AS TotalImpuestosFacturas

FROM				[CORPEPIDB].EpicorErp.Erp.CheckHed					CH		WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Vendor					V		WITH(NoLock)
	ON				CH.Company					=				V.Company
	AND				CH.VendorNum				=				V.VendorNum

INNER JOIN			(
					SELECT				A.Company, A.HeadNum, 
										SUM(A.InvoiceAmt)				AS		InvoiceAmt, 
										SUM(A.TaxAmt)					AS		TaxAmt
					FROM				(
										SELECT				APT.Company, APT.TranType, APT.HeadNum, APT.InvoiceNum, APT.LegalNumber, APT.VendorNum, 
															ISNULL(API.InvoiceAmt, 0)				AS		InvoiceAmt, 
															ISNULL(API.TaxAmt, 0)					AS		TaxAmt 
										FROM				[CORPEPIDB].EpicorERP.Erp.ApTran					APT		WITH (NoLock)
										LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ApInvHed					API		WITH (NoLock)
											ON				APT.Company					=				API.Company
											AND				APT.InvoiceNum				=				API.InvoiceNum
											AND				APT.VendorNum				=				API.VendorNum
									--		AND				APT.LegalNumber				=				API.LegalNumber 
										WHERE				APT.Company					=				@Company
										)			A
					GROUP BY			A.Company, A.HeadNum 
					)					B		
	ON				CH.Company			=			B.Company
	AND				CH.HeadNum			=			B.HeadNum

-----------------------------------------

WHERE				CH.Company					=				@Company
	AND				CH.CheckDate				BETWEEN			@FechaDesde		AND		@FechaHasta
	AND				CH.Posted					=				1
	AND				CH.PayTranDocTypeID			=				'OP'

ORDER BY			CH.Company, CH.CheckDate, CH.CheckNum  

-----------------------------------------

