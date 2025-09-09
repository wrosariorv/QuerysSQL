
DECLARE				@Cia		VARCHAR(15)	= 'CO01', 
					@Status		VARCHAR(15)	= 'SHIPPED'


select 

	[ContainerHeader].[Company] as [ContainerHeader_Company],
	[ContainerHeader].[ContainerID] as [ContainerHeader_ContainerID],
	[ContainerHeader].[ContainerClass] as [ContainerHeader_ContainerClass],
	[ContainerHeader].[ShipDate] as [ContainerHeader_ShipDate],
	[ContainerHeader].[ContainerDescription] as [ContainerHeader_ContainerDescription],
	[ContainerHeader].[ShipViaCode] as [ContainerHeader_ShipViaCode],
	[ShipVia].[Description] as [ShipVia_Description],
	[ContainerHeader].[FOB] as [ContainerHeader_FOB],
	[Fob].[Description] as [Fob_Description],
	[ContainerHeader].[BOLading] as [ContainerHeader_BOLading],
	[ContainerHeader].[ShipStatus] as [ContainerHeader_ShipStatus],
	[ContainerHeader].[LoadPortID] as [ContainerHeader_LoadPortID],
	[ContainerHeader].[DechargePortID] as [ContainerHeader_DechargePortID],
	[ContainerHeader].[ImportNum] as [ContainerHeader_ImportNum],
	[ContainerHeader].[ArrivedDate] as [ContainerHeader_ArrivedDate],
	[ContainerHeader].[ReceivedDate] as [ContainerHeader_ReceivedDate],
	[ContainerHeader].[DueDate] as [ContainerHeader_DueDate],
	[PORel].[PONum] as [PORel_PONum],
	[Vendor].[VendorID] as [Vendor_VendorID],
	[Vendor].[Name] as [Vendor_Name],
	[PORel].[ShortChar04] as [PORel_ShortChar04],
	(datediff(day, ContainerHeader.DueDate, JobHead.StartDate)) as [Calculated_PrevioProd],
	[JobHead].[StartDate] as [JobHead_StartDate],
	[JobHead].[DueDate] as [JobHead_DueDate],
	[JobHead].[PartNum] as [JobHead_PartNum],
	[JobHead].[PartDescription] as [JobHead_PartDescription],
	[UD40].[ShortChar09] as [UD40_ShortChar09],
	[UD40].[ShortChar10] as [UD40_ShortChar10],
	[Part].[ClassID] as [Part_ClassID],
	[Part].[ProdCode] as [Part_ProdCode],
	[UD40].[ShortChar01] as [UD40_ShortChar01],
	[ContainerHeader].[PAC_Despachante_c] as [ContainerHeader_PAC_Despachante_c],
	[ContainerHeader].[PAC_SubStatus_c] as [ContainerHeader_PAC_SubStatus_c],
	[ContainerHeader].[Checkbox20] as [ContainerHeader_Checkbox20],
	[Despachante].[Name] as [Despachante_Name],
	[ContainerHeader].[UpliftPercent] as [ContainerHeader_UpliftPercent],
	[UD40].[Number10] as [UD40_Number10],
	[Naviera].[Name] as [Naviera_Name],
	[UD32].[Number01] as [UD32_Number01],
	[UD32].[Number02] as [UD32_Number02],
	[UD32].[Number03] as [UD32_Number03],
	[UD32].[ShortChar01] as [UD32_ShortChar01],
	[UD32].[ShortChar02] as [UD32_ShortChar02],
	[UD32].[Date01] as [UD32_Date01],
	[UD40].[Number07] as [UD40_Number07],
	[UD40].[Date04] as [UD40_Date04],
	[ContainerHeader].[PAC_EnvioAnexo_c] as [ContainerHeader_PAC_EnvioAnexo_c],
	[UD40].[Date05] as [UD40_Date05],
	[UD40].[Date07] as [UD40_Date07],
	[UD40].[Date08] as [UD40_Date08],
	[ContainerHeader].[PAC_Trans_BsAs_c] as [ContainerHeader_PAC_Trans_BsAs_c],
	[UD40].[Date15] as [UD40_Date15],
	[UD40].[ShortChar13] as [UD40_ShortChar13],
	[UD40].[ShortChar12] as [UD40_ShortChar12],
	[ContainerHeader].[PAC_ETA_BsAs_c] as [ContainerHeader_PAC_ETA_BsAs_c],
	[UD40].[Date09] as [UD40_Date09],
	[UD40].[Date10] as [UD40_Date10],
	[UD40].[Date11] as [UD40_Date11],
	[UD40].[Date17] as [UD40_Date17],
	[UD40].[ShortChar06] as [UD40_ShortChar06],
	[UD40].[Date12] as [UD40_Date12],
	[UD40].[ShortChar05] as [UD40_ShortChar05],
	[UD40].[ShortChar07] as [UD40_ShortChar07],
	[UD40].[Date18] as [UD40_Date18],
	[POHeader].[PAC_InsDate_c] as [POHeader_PAC_InsDate_c],
	[POHeader].[PAC_InsVendorNum_c] as [POHeader_PAC_InsVendorNum_c],
	[POHeader].[PAC_InsFAprob_c] as [POHeader_PAC_InsFAprob_c],
	(case    when (POHeader.Date01) is null then 'Sin Fecha Salida' ELSE  case   when CAST(GETDATE() AS DATE) >  POHeader.Date01 + 160 and        CAST(GETDATE() AS DATE) <= POHeader.Date01 - 180 then 'Vencido' ELSE '-'      end   end) as [Calculated_AlarmaVtoSIMI],
	CASE	WHEN ContainerHeader.PAC_Trans_BsAs_c = 'TRUE'  then '-'  	else	CASE	WHEN (ContainerHeader.ShipDate) IS NULL THEN 'Sin Fecha Embarque' 			else	CASE WHEN DATEADD(dd, -15, CAST(GETDATE() AS DATE)) > ContainerHeader.ShipDate Then 'Vencido' 					else	'-'  					end				end 	end as [Calculated_AlarmaRDO],  --> Se reemplaza UD40.Checkbox01 por ContainerHeader.PAC_Trans_BsAs_c) as [Calculated_AlarmaRDO],
	[UD40].[Date13] as [UD40_Date13],
	[ContainerHeader].[PAC_BankAcctID_c] as [ContainerHeader_PAC_BankAcctID_c],
	[BankAcct].[Description] as [BankAcct_Description],
	[ContainerClass].[ShortChar01] as [ContainerClass_ShortChar01],
	ContainerMiscUSD.DocEstimateAmt as [MontoFleteUSD],
	[APInvHed].[InvoiceNum] as [APInvHed_InvoiceNum],
	[APInvHed].[InvoiceDate] as [APInvHed_InvoiceDate],
	[APInvHed].[Posted] as [APInvHed_Posted],
	[APInvHed].[FiscalYear] as [APInvHed_FiscalYear],
	[APInvHed].[FiscalPeriod] as [APInvHed_FiscalPeriod]

from (
	SELECT		*
	FROM		[CORPEPIDB].EpicorERP.Erp.ContainerHeader 
	INNER JOIN	[CORPEPIDB].EpicorERP.Erp.ContainerHeader_UD
		ON		ContainerHeader.SysRowID = ContainerHeader_UD.ForeignSysRowID
	)as ContainerHeader

left outer join [CORPEPIDB].EpicorERP.Ice.UD40 as UD40 on 
	ContainerHeader.Company = UD40.Company
	and ContainerHeader.ContainerID = UD40.Key2
	and ( UD40.Key1 = 'ComercioExterior4038'  )

left outer join [CORPEPIDB].EpicorERP.Erp.Vendor as Naviera on 
	ContainerHeader.Company = Naviera.Company
	and ContainerHeader.VendorNum = Naviera.VendorNum

left outer join [CORPEPIDB].EpicorERP.Erp.Vendor as Despachante on 
	ContainerHeader.PAC_Despachante_c = Despachante.VendorNum and
	 ContainerHeader.Company = Despachante.Company

left outer join [CORPEPIDB].EpicorERP.Erp.BankAcct as BankAcct on 
	ContainerHeader.PAC_BankAcctID_c = BankAcct.BankAcctID and 
	 ContainerHeader.Company = BankAcct.Company

left outer join [CORPEPIDB].EpicorERP.Erp.ShipVia as ShipVia on 
	ContainerHeader.Company = ShipVia.Company
	and ContainerHeader.ShipViaCode = ShipVia.ShipViaCode

left outer join [CORPEPIDB].EpicorERP.Erp.FOB as Fob on 
	ContainerHeader.Company = Fob.Company
	and ContainerHeader.FOB = Fob.FOB

left outer join 
(
SELECT		*
FROM		[CORPEPIDB].EpicorERP.Erp.ContainerClass 
INNER JOIN	[CORPEPIDB].EpicorERP.Erp.ContainerClass_UD
	ON		ContainerClass.SysRowID = ContainerClass_UD.ForeignSysRowID
) as ContainerClass on 
	ContainerHeader.Company = ContainerClass.Company
	and ContainerHeader.ContainerClass = ContainerClass.ClassCode

left outer join 
(
SELECT		Company, ContainerID, SUM(DocEstimateAmt) AS DocEstimateAmt
FROM		[CORPEPIDB].EpicorERP.Erp.ContainerMisc
WHERE		(ContainerMisc.CurrencyCode = 'usd'  and ContainerMisc.MiscCode like '1%'  )
GROUP BY	Company, ContainerID 
) as ContainerMiscUSD on 
	ContainerHeader.Company = ContainerMiscUSD.Company
	and ContainerHeader.ContainerID = ContainerMiscUSD.ContainerID

left outer join 
	(
	SELECT		*
	FROM		[CORPEPIDB].EpicorERP.Erp.PORel 
	INNER JOIN	[CORPEPIDB].EpicorERP.Erp.PORel_UD
		ON		PORel.SysRowID = PORel_UD.ForeignSysRowID
	) as PORel on 
	ContainerHeader.Company = PORel.Company
	and ContainerHeader.ContainerID = PORel.ContainerID
	and ( PORel.POLine = 1  and PORel.PORelNum = 1  and PORel.ContainerID > 0  )

left outer join 
(
SELECT		*
FROM		[CORPEPIDB].EpicorERP.Erp.POHeader
INNER JOIN	[CORPEPIDB].EpicorERP.Erp.POHeader_UD
	ON		POHeader.SysRowID = POHeader_UD.ForeignSysRowID
) as POHeader on 
	PORel.Company = POHeader.Company
	and PORel.PONum = POHeader.PONum

left outer join [CORPEPIDB].EpicorERP.Erp.Vendor as Vendor on 
	POHeader.Company = Vendor.Company
	and POHeader.VendorNum = Vendor.VendorNum

left outer join [CORPEPIDB].EpicorERP.Erp.JobHead as JobHead on 
	PORel.Company = JobHead.Company
	and PORel.ShortChar04 = JobHead.JobNum

left outer join [CORPEPIDB].EpicorERP.Erp.Part as Part on 
	JobHead.Company = Part.Company
	and JobHead.PartNum = Part.PartNum

left outer join [CORPEPIDB].EpicorERP.Erp.APInvDtl as APInvDtl on 
	APInvDtl.Company = PORel.Company
	and APInvDtl.PONum = PORel.PONum
	and APInvDtl.POLine = PORel.POLine
	and APInvDtl.PORelNum = PORel.PORelNum

left outer join [CORPEPIDB].EpicorERP.Erp.APInvHed as APInvHed on 
	APInvDtl.Company = APInvHed.Company
	and APInvDtl.VendorNum = APInvHed.VendorNum
	and APInvDtl.InvoiceNum = APInvHed.InvoiceNum

left outer join [CORPEPIDB].EpicorERP.Ice.UD32 as UD32 on 
	ContainerHeader.Company = UD32.Company
	and ContainerHeader.ContainerID = UD32.Key2
	and ( UD32.Key1 = 'ComExOC'  )

where ContainerHeader.Company = @Cia  
-- and ContainerHeader.ShipStatus = @Status 

AND 	[ContainerHeader].[ContainerID]  = 6570

