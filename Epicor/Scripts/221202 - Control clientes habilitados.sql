
SELECT				C.Company, C.CustID, C.[Name], C.GroupCode, C.ValidShipTo, C.ValidSoldTo, C.ReminderCode, C.Comment, C.CreditLimit, 
					C.CreditReviewDate, 
					CG.GroupDesc, 
					Inv.InvoiceDate, Inv.InvoiceNum, Inv.LegalNumber, 
					CASE	
						WHEN	C.ValidShipTo = 0		OR		C.ValidSoldTo = 0
						THEN													'No'
						ELSE													'Si'
					END															AS ClienteHabilitado 
FROM				CORPEPIDB.EpicorErp.Erp.Customer				C
LEFT OUTER JOIN		(
					SELECT				C.Company, C.CustNum, C.InvoiceDate, C.InvoiceNum, C.LegalNumber
					FROM				CORPEPIDB.EpicorErp.Erp.InvcHead			C
					INNER JOIN			(
										SELECT				A.Company, A.CustNum, A.InvoiceDate, MAX(A.InvoiceNum)	AS InvoiceNum 
										FROM				CORPEPIDB.EpicorErp.Erp.InvcHead			A
										INNER JOIN			(
															SELECT				Company, CustNum, MAX(InvoiceDate)	AS InvoiceDate
															FROM 				CORPEPIDB.EpicorErp.Erp.InvcHead		
															WHERE				InvoiceType			=			'SHP'
															GROUP BY			Company, CustNum
															)		B
											ON				A.Company			=			B.Company
											AND				A.CustNum			=			B.CustNum
											AND				A.InvoiceDate		=			B.InvoiceDate
										WHERE				InvoiceType			=			'SHP'
										GROUP BY			A.Company, A.CustNum, A.InvoiceDate
										)		D
						ON				C.Company			=			D.Company
						AND				C.CustNum			=			D.CustNum
						AND				C.InvoiceDate		=			D.InvoiceDate
						AND				C.InvoiceNum		=			D.InvoiceNum
					)	Inv
	
	ON			C.Company		=		Inv.Company
	AND			C.CustNum		=		Inv.CustNum

LEFT OUTER JOIN 	CORPEPIDB.EpicorErp.Erp.CustGrup			CG
	ON			C.Company		=		CG.Company
	AND			C.GroupCode		=		CG.GroupCode

WHERE			C.Company		=		'CO01'
ORDER BY		C.CustID
