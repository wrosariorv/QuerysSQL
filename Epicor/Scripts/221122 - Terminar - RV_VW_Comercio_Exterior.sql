USE [RVF_Local]
GO

-- /*

ALTER VIEW			[dbo].[RVF_VW_COMERCIO_EXTERIOR]
AS

-- */

SELECT				ContainerHeader.Company																AS ContainerHeader_Company,
					LTRIM(RTRIM(CAST(CAST(ContainerHeader.ContainerID AS INTEGER) AS VARCHAR(15))))		AS ContainerHeader_ContainerID,
					ContainerHeader.ContainerClass														AS ContainerHeader_ContainerClass,
--					UD40.Date01																			AS UD40_Date01,
					ContainerHeader.ShipDate															AS ContainerHeader_ShipDate,
					ContainerHeader.ContainerDescription												AS ContainerHeader_ContainerDescription,
					ContainerHeader.ShipViaCode															AS ContainerHeader_ShipViaCode,
					ShipVia.[Description]																AS ShipVia_Description,
					ContainerHeader.FOB																	AS ContainerHeader_FOB,
					Fob.[Description]																	AS Fob_Description,
					ContainerHeader.BOLading															AS ContainerHeader_BOLading,
					ContainerHeader.ShipStatus															AS ContainerHeader_ShipStatus,
					ContainerHeader.LoadPortID															AS ContainerHeader_LoadPortID,
					ContainerHeader.DechargePortID														AS ContainerHeader_DechargePortID,
					ContainerHeader.ImportNum															AS ContainerHeader_ImportNum,
					ContainerHeader.ArrivedDate															AS ContainerHeader_ArrivedDate,
					ContainerHeader.ReceivedDate														AS ContainerHeader_ReceivedDate,
					ContainerHeader.DueDate																AS ContainerHeader_DueDate,
--					UD40.Number03																		AS UD40_Number03,	
					[PORel].[PONum]																		AS [PORel_PONum],
					ISNULL(Vendor.VendorID,'')															AS Vendor_VendorID,
					Vendor.[Name]																		AS Vendor_Name,
--					UD40.ShortChar14																	AS UD40_ShortChar14,
					[PORel].[ShortChar04]																AS [PORel_ShortChar04],
					(datediff(day, ContainerHeader.DueDate, JobHead.StartDate))							AS Calculated_PrevioProd,
--					JobHead.ReqDueDate																	AS JobHead_ReqDueDate,
					JobHead.StartDate																	AS JobHead_StartDate,
					JobHead.DueDate																		AS JobHead_DueDate,
					JobHead.PartNum																		AS JobHead_PartNum,
					JobHead.PartDescription																AS JobHead_PartDescription,
					UD40.ShortChar09																	AS UD40_ShortChar09,
					UD40.ShortChar10																	AS UD40_ShortChar10,
					Part.ClassID																		AS Part_ClassID,
					Part.ProdCode																		AS Part_ProdCode,
					[UD40].[ShortChar01]																AS [UD40_ShortChar01],
					[ContainerHeader].[PAC_Despachante_c]												AS [ContainerHeader_PAC_Despachante_c],
					[ContainerHeader].[PAC_SubStatus_c]													AS [ContainerHeader_PAC_SubStatus_c],
--					UD40.ShortChar01																	AS UD40_ShortChar01,
--					UD40.Number11																		AS UD40_Number11,
--					isnull (UD40.ShortChar15, '')														AS UD40_ShortChar15,
					ContainerHeader.Checkbox20															AS ContainerHeader_Checkbox20,
					Despachante.[Name]																	AS Despachante_Name,
					ContainerHeader.UpliftPercent														AS ContainerHeader_UpliftPercent,
					UD40.Number10																		AS UD40_Number10,
					Naviera.[Name]																		AS Naviera_Name,
					[UD32].[Number01]																	AS [UD32_Number01],
					[UD32].[Number02]																	AS [UD32_Number02],
					[UD32].[Number03]																	AS [UD32_Number03],
					[UD32].[ShortChar01]																AS [UD32_ShortChar01],
					[UD32].[ShortChar02]																AS [UD32_ShortChar02],
					[UD32].[Date01]																		AS [UD32_Date01],
--					UD40.Number09																		AS UD40_Number09,
--					UD40.Number05																		AS UD40_Number05,
--					UD40.Number06																		AS UD40_Number06,
--					UD40.ShortChar03																	AS UD40_ShortChar03,
--					UD40.ShortChar04																	AS UD40_ShortChar04,
--					UD40.Date14																			AS UD40_Date14,
					UD40.Number07																		AS UD40_Number07,
					UD40.Date04																			AS UD40_Date04,
					[ContainerHeader].[PAC_EnvioAnexo_c]												AS [ContainerHeader_PAC_EnvioAnexo_c],
--					UD40.Date06																			AS UD40_Date06,
					UD40.Date05																			AS UD40_Date05,
					UD40.Date07																			AS UD40_Date07,
					UD40.Date08																			AS UD40_Date08,
					[ContainerHeader].[PAC_Trans_BsAs_c]												AS [ContainerHeader_PAC_Trans_BsAs_c],
--					UD40.CheckBox01																		AS UD40_CheckBox01,
					UD40.Date15																			AS UD40_Date15,
					UD40.ShortChar13																	AS UD40_ShortChar13,
					UD40.ShortChar12																	AS UD40_ShortChar12,
					[ContainerHeader].[PAC_ETA_BsAs_c]													AS [ContainerHeader_PAC_ETA_BsAs_c],
--					UD40.Date16																			AS UD40_Date16,
					UD40.Date09																			AS UD40_Date09,
					UD40.Date10																			AS UD40_Date10,
					UD40.Date11																			AS UD40_Date11,
					UD40.Date17																			AS UD40_Date17,
					UD40.ShortChar06																	AS UD40_ShortChar06,
					UD40.Date12																			AS UD40_Date12,
					UD40.ShortChar05																	AS UD40_ShortChar05,
					UD40.ShortChar07																	AS UD40_ShortChar07,
					UD40.Date18																			AS UD40_Date18,
					POHeaderUD.PAC_InsDate_c															AS POHeader_PAC_InsDate_c,
					POHeaderUD.PAC_InsVendorNum_c														AS POHeader_PAC_InsVendorNum_c,
					POHeaderUD.PAC_InsFAprob_c															AS POHeader_PAC_InsFAprob_c, 
--					UD40.Date19																			AS UD40_Date19,
--					UD40.Number12																		AS UD40_Number12,
--					UD40.Date20																			AS UD40_Date20,
					(
					case 
						when (POHeaderUD.Date01) is null then 'Sin Fecha Salida' 
						else	
							case 
								when	GETDATE()  >  POHeaderUD.Date01 + 160 and	
										GETDATE()  <= POHeaderUD.Date01 - 180 then 'Vencido' 
							else '-'
						end
					end
					)																					AS Calculated_AlarmaVtoSIMI,
					(
					case 
						when UD40.Checkbox01 = 'TRUE'  then '-'  
						else	
							case 
								when (CONTAINERHEADER.SHIPDATE) IS NULL then 'Sin Fecha Embarque' 
								else	
									case 
										when GETDATE() - 15 > ContainerHeader.ShipDate then 'Vencido' 
										else '-'	
									end 
							end 
					end
					)																				AS Calculated_AlarmaRDO,
					UD40.Date13																		AS UD40_Date13,
--					UD401b.ShortChar02																AS UD401b_ShortChar02,
--					BankAcct.[Description]															AS BankAcct_Description,
					[ContainerHeader].[PAC_BankAcctID_c]											AS [ContainerHeader_PAC_BankAcctID_c],
					[BankAcct].[Description]														AS [BankAcct_Description],
					ContainerClassUD.ShortChar01													AS ContainerClass_ShortChar01,
					ContainerMiscUSD.DocEstimateAmt													AS Calculated_MontoFleteUSD,
					APInvHed.InvoiceNum																AS APInvHed_InvoiceNum,
					APInvHed.InvoiceDate															AS APInvHed_InvoiceDate,
					APInvHed.Posted																	AS APInvHed_Posted,
					APInvHed.FiscalYear																AS APInvHed_FiscalYear,
					APInvHed.FiscalPeriod															AS APInvHed_FiscalPeriod  
					--------------------------------------------------------------------------------------
--					APInvDtl.InvoiceNum																AS APInvDtl_InvoiceNum,  
--					APInvHed.DocInvoiceBal															AS APInvHed_DocInvoiceBal, 
--					APInvHed.CurrencyCode															AS APInvHed_CurrencyCode, 
--					UD401b.ShortChar01																AS UD401b_ShortChar01, 
--					UD401b.ShortChar03																AS UD401b_ShortChar03,
--					UD401b.Date13																	AS UD401b_Date13, 
					--------------------------------------------------------------------------------------


FROM				(
					SELECT				*
					FROM				[CORPEPIDB].EpicorERP.Erp.ContainerHeader					AS ContainerHeader			WITH(NoLock)
					LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ContainerHeader_UD				AS ContainerHeaderUD		WITH(NoLock)
						ON				ContainerHeader.SysRowID		=		ContainerHeaderUD.ForeignSysRowID
					)	AS ContainerHeader

LEFT OUTER JOIN		(
					SELECT				Company, Key2, 
										Number03, Number05, Number06, Number07, Number09, Number10, Number11, Number12, 
										ShortChar01, ShortChar03, ShortChar04, ShortChar05, ShortChar06, ShortChar07, ShortChar09, ShortChar10, 
										ShortChar12, ShortChar13, ShortChar14, ShortChar15,
										CheckBox01, 
										Date01, Date04, Date05, Date06, Date07, Date08, Date09, Date10, Date11, Date12, Date13, Date14, Date15, 
										Date16, Date17, Date18, Date19, Date20  
					FROM				[CORPEPIDB].EpicorERP.Ice.UD40															WITH(NoLock)
					WHERE				UD40.Key1						=			'ComercioExterior4038'
					)	AS UD40
	ON				ContainerHeader.Company			=		UD40.Company
	AND				ContainerHeader.ContainerID		=		UD40.Key2

LEFT OUTER JOIN		(
					SELECT				Company, Key2, Date13, ShortChar01, ShortChar02, ShortChar03  
					FROM				[CORPEPIDB].EpicorERP.Ice.UD40															WITH(NoLock)
					WHERE				Key1							=			'ComercioExterior4039'
					)		AS UD401b
	ON				UD40.Company					=		UD401b.Company
	AND				UD40.Key2						=		UD401b.Key2

LEFT OUTER JOIN		(
					SELECT				PORel.Company, PORel.PONum, PORel.POLine, PORel.PORelNum, PORel.ContainerID, 
										PORelUD.ShortChar04
					FROM				[CORPEPIDB].EpicorERP.Erp.PORel								AS PORel						WITH(NoLock)			
					LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.PORel_UD							AS PORelUD					WITH(NoLock)
						ON				PORel.SysRowID					=		PORelUD.ForeignSysRowID
					WHERE				PORel.POLine					=			1  
						AND				PORel.PORelNum					=			1
					)	AS PORel
	ON				ContainerHeader.Company 		=		PORel.Company
	AND				ContainerHeader.ContainerID		=		PORel.ContainerID

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.POHeader							AS POHeader					WITH(NoLock)
	ON				PORel.Company					=		POHeader.Company
	AND				PORel.PONum						=		POHeader.PONum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.POHeader_UD						AS POHeaderUD				WITH(NoLock)
	ON				POHeader.SysRowID = POHeaderUD.ForeignSysRowID

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.Vendor							AS Vendor					WITH(NoLock)
	ON				POHeader.Company				=		Vendor.Company
	AND				POHeader.VendorNum				=		Vendor.VendorNum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.APInvDtl							AS APInvDtl					WITH(NoLock)
	ON				APInvDtl.Company				=		PORel.Company
	AND				APInvDtl.PONum					=		PORel.PONum
	AND				APInvDtl.POLine					=		PORel.POLine
	AND				APInvDtl.PORelNum				=		PORel.PORelNum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.APInvHed							AS APInvHed					WITH(NoLock)
	ON				APInvDtl.Company				=		APInvHed.Company
	AND				APInvDtl.VendorNum				=		APInvHed.VendorNum
	AND				APInvDtl.InvoiceNum				=		APInvHed.InvoiceNum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.JobHead							AS JobHead					WITH(NoLock)
	ON				PORel.Company					=		JobHead.Company
	AND				PORel.ShortChar04				=		JobHead.JobNum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.Part								AS Part						WITH(NoLock)
	ON				JobHead.Company					=		Part.Company
	AND				JobHead.PartNum					=		Part.PartNum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.Vendor							AS Naviera					WITH(NoLock)
	ON				ContainerHeader.Company			=		Naviera.Company
	AND				ContainerHeader.VendorNum		=		Naviera.VendorNum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.Vendor							AS Despachante				WITH(NoLock)
	ON				ContainerHeader.Company				=		Despachante.Company
	AND				ContainerHeader.PAC_Despachante_c	=		Despachante.VendorNum

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.BankAcct							AS BankAcct					WITH(NoLock)
	ON				ContainerHeader.Company				=	BankAcct.Company
	AND				ContainerHeader.PAC_BankAcctID_c	=	BankAcct.BankAcctID

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ShipVia							AS ShipVia					WITH(NoLock)
	ON				ContainerHeader.Company			=		ShipVia.Company
	AND				ContainerHeader.ShipViaCode		=		ShipVia.ShipViaCode

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.FOB								AS Fob						WITH(NoLock)
	ON				ContainerHeader.Company			=		Fob.Company
	AND				ContainerHeader.FOB				=		Fob.FOB

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ContainerClass					AS ContainerClass			WITH(NoLock)
	ON				ContainerHeader.Company			=		ContainerClass.Company
	AND				ContainerHeader.ContainerClass	=		ContainerClass.ClassCode

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ContainerClass_UD					AS ContainerClassUD			WITH(NoLock)
	ON				ContainerClass.SysRowID			=		ContainerClassUD.ForeignSysRowID

LEFT OUTER JOIN		(
					SELECT			Company, ContainerID, 
									SUM(DocEstimateAmt)		AS		DocEstimateAmt
					FROM			[CORPEPIDB].EpicorERP.Erp.ContainerMisc				WITH(NoLock)
					WHERE			CurrencyCode	=		'usd'  
						AND			MiscCode		LIKE	'1%'
					GROUP BY		Company, ContainerID
					)	AS ContainerMiscUSD 
	ON				ContainerHeader.Company			=		ContainerMiscUSD.Company
	AND				ContainerHeader.ContainerID		=		ContainerMiscUSD.ContainerID

LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Ice.UD32								AS UD32						WITH(NoLock)
	ON				ContainerHeader.Company			=		UD32.Company
	AND				ContainerHeader.ContainerID		=		UD32.Key2
	AND				(UD32.Key1						=		'ComExOC')

--------------------------------------------------------------------

