
SET DATEFORMAT DMY

-------------------------------------------------------------------------

DECLARE			@FechaInicio	DATETIME		=		'15/05/2021', 
				@Error			BIT				=		1			-- 1: Documentos con error / 0: Todos los documentos

-------------------------------------------------------------------------

SELECT			B.*
FROM			(
				SELECT				A.*, 
									IH.LegalNumber											AS		LegalNumber_2, 
				--					SUBSTRING(IH.LegalNumber, 4, 1)							AS		Letra_2, 
									AGDocumentLetter										AS		Letra_2, 
									C.ResaleID												AS		ResaleID_2, 	
									CASE
										WHEN		ISNULL(A.Letra_1, '')		<>			ISNULL(SUBSTRING(IH.LegalNumber, 4, 1), '')
											OR		ISNULL(A.ResaleID_1, '')	<>			ISNULL(C.ResaleID, '')
											OR		A.InvoiceNum				=			A.CompVinculado
										THEN								1
										ELSE								0
									END														AS		Error

				FROM				(
									SELECT			IH.Company, IH.LegalNumber, IH.Posted, IH.InvoiceNum, IH.InvoiceDate, IH.CustNum, IH.EntryPerson, 
													IH.InvoiceRef, IH.RMANum, IH.InvoiceComment, 
													IHU.Character07											AS		UnNeg, 
													IHU.PAC_InvoiceRef_c									AS		CompVinculado, 
									--				SUBSTRING(IH.LegalNumber, 4, 1)							AS		Letra_1, 
													AGDocumentLetter										AS		Letra_1, 
													C.ResaleID												AS		ResaleID_1, 
													IHU.ForeignSysRowID 

									FROM			[CORPEPIDB].EpicorErp.Erp.InvcHead						IH				WITH(NoLock)
									INNER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead_UD					IHU				WITH(NoLock)
										ON			IH.SysRowID				=			IHU.ForeignSysRowID 
									INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Customer						C				WITH(NoLock)
										ON			IH.Company				=			C.Company
										AND			IH.CustNum				=			C.CustNum 
									WHERE			(
													IH.LegalNumber			LIKE		'ND%'
													OR	
													IH.LegalNumber			LIKE		'NC%'
													)
										AND			IH.LegalNumber			NOT LIKE	'NDNF%'
										AND			IH.LegalNumber			NOT LIKE	'NCNF%'
										AND			IH.InvoiceDate			>=			@FechaInicio
										AND			IH.Posted				=			1
									) A
				LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead						IH				WITH(NoLock)
					ON				A.Company				=				IH.Company
					AND				A.CompVinculado			=				IH.InvoiceNum 
				LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Customer						C				WITH(NoLock)
					ON				IH.Company				=			C.Company
					AND				IH.CustNum				=			C.CustNum 

				--------------------------------------------------------------------------
				/*

				WHERE			ISNULL(A.Letra_1, '')		<>			ISNULL(SUBSTRING(IH.LegalNumber, 4, 1), '')
					OR			ISNULL(A.ResaleID_1, '')	<>			ISNULL(C.ResaleID, '')
					OR			A.InvoiceNum				=			A.CompVinculado

				*/
				)		B
WHERE			Error					=			@Error

--	OR			LegalNumber				IN			('NC-A-0233-00001089', 'NC-A-0237-00000063', 'NC-A-0233-00001101')

ORDER BY		InvoiceDate, LegalNumber 

