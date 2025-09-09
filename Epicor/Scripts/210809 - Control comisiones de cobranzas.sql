

SELECT				UD.Company, UD.Key1, UD.Key2, UD.Key3, UD.Key4, UD.Key5, 
					UD.Number01									AS	ImporteComision, 
					UD.Number02									AS			DiasDif, 
					UD.Number04									AS			MontoAplicado, 
					UD.Number05									AS			ImporteValor, 
					UD.Number07									AS			PorcentajeComision, 
					UD.Number10									AS			MultiplicadorCliente, 
					LTRIM(RTRIM(UD.ShortChar01))				AS			NroLegalFactura, 
					CASE
						WHEN LTRIM(RTRIM(UD.ShortChar02)) =	'' THEN LTRIM(RTRIM(UD.ShortChar08))
						ELSE										LTRIM(RTRIM(UD.ShortChar02)) 
					END											AS			NroLegalRecibo, 
		--			LTRIM(RTRIM(UD.ShortChar08))				AS			NroLegalReciboOriginal,   
					UD.Date02									AS			FechaVtoValor, 
					UD.Date03									AS			FechaRecibo,  
					IH.InvoiceNum, IH.InvoiceDate, IH.DueDate, 
					ISC.PaySeq, ISC.PayDays, ISC.PayDueDate, 
					ISCU.RV_DiasVtoOrig_c, ISCU.RV_FechaVtoOrig_c

FROM				[CORPEPIDB].EpicorERP.Ice.UD100A				UD			WITH (NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead				IH		WITH (NoLock)
	ON				UD.Company		=				IH.Company
	AND				LTRIM(RTRIM(UD.ShortChar01))	=			IH.LegalNumber 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.InvcSched				ISC		WITH (NoLock)
	ON				IH.Company		=				ISC.Company
	AND				IH.InvoiceNum	=				ISC.InvoiceNum 
INNER JOIN	 		[CORPEPIDB].EpicorErp.Erp.InvcSched_UD			ISCU	WITH (NoLock)
	ON				ISC.SysRowID	=				ISCU.ForeignSysRowID 



WHERE				UD.Company			=				'CO01'
	AND				UD.Key1				=				'Comisiones'
	AND				UD.Key2				=				'202107'
	AND				UD.Key3				=				'TCL19'
	AND				ISC.PaySeq			=				1
