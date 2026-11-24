SET DATEFORMAT DMY
 
SELECT				--TOP 100 
					C.Company, 
					C.CustID											AS	SoldToCustID, 
					IH.InvoiceNum										AS	PAC_InvoiceRef_c, 
					IH.LegalNumber										AS	PAC_InvRefLegNum_c, 
					IH.Plant, 
					IH.PONum, 
					IH.TermsCode, 
					IH.InvoiceComment,
					IH.InvoiceDate,
					--IHU.Character07, 
					ID.ShipToNum, 
					ID.SellingShipQty,
					ID.PartNum, 
--					PU.Character02										AS UNegocio,
					ID.InvoiceComment 
FROM				EpicorPilot11100.Erp.InvcHead			IH			WITH (NoLock)
INNER JOIN			EpicorPilot11100.Erp.Customer			C			WITH (NoLock)
	ON				IH.Company						=				C.Company
	AND				IH.CustNum						=				C.CustNum
INNER JOIN			EpicorPilot11100.Erp.InvcDtl			ID			WITH (NoLock)
	ON				IH.Company						=				ID.Company
	AND				IH.InvoiceNum 					=				ID.InvoiceNum 
--INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.InvcHead_UD		IHU			WITH (NoLock)
--	ON				IH.SysRowID						=				IHU.ForeignSysRowID 
--INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.Part									P			WITH(NoLock)
--	ON				ID.Company						=				P.Company
--	AND				ID.PartNum						=				P.PartNum
--INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.Part_UD								PU			WITH(NoLock)

	--ON				P.SysRowID				=			PU.ForeignSysRowID
WHERE				IH.InvoiceDate					>=				'01/01/2022'
	--AND				IH.LegalNumber					LIKE			'NCE-%'--'FE-%'
	AND				IH.InvoiceNum					in				(13838)
	AND				IH.Company						in				('CL01')
ORDER BY			IH.InvoiceDate DESC


SELECT				--TOP 100 
					C.Company, 
					C.CustID											AS	SoldToCustID, 
					IH.InvoiceNum										AS	PAC_InvoiceRef_c, 
					IH.LegalNumber										AS	PAC_InvRefLegNum_c, 
					IH.Plant, 
					IH.PONum, 
					IH.TermsCode, 
					IH.InvoiceComment,
					IH.InvoiceDate,
					--IHU.Character07, 
					ID.ShipToNum, 
					ID.SellingShipQty,
					ID.PartNum, 
--					PU.Character02										AS UNegocio,
					ID.InvoiceComment 
FROM				EpicorPilot11100.Erp.InvcHead			IH			WITH (NoLock)
INNER JOIN			EpicorPilot11100.Erp.Customer			C			WITH (NoLock)
	ON				IH.Company						=				C.Company
	AND				IH.CustNum						=				C.CustNum
INNER JOIN			EpicorPilot11100.Erp.InvcDtl			ID			WITH (NoLock)
	ON				IH.Company						=				ID.Company
	AND				IH.InvoiceNum 					=				ID.InvoiceNum 
where	IH.LegalNumber					LIKE			'NDE-%'--'FE-%'

select CL_InvoiceRef_c,	CL_InvRefLegNum_c,* from [CHILEPIDB].EpicorPilot11100.Erp.InvcHead_UD			IH			WITH (NoLock)
where	ForeignSysRowID ='01372DDA-4A1B-433C-86F9-B0B9A3343F23'--'FB2FF997-F38D-4A31-90D2-D8129F1629CF'


select * from EpicorPilot11100.Erp.Customer

select * from [CHILEPIDB].EpicorPilot11100.Erp.TranDocType
where
		
		TranDocTypeID like 'NC%'
AND		Company='UY01'
or		(
					TranDocTypeID like 'ND%'
			AND		Company='UY01'
)
	

select * from [CHILEPIDB].EpicorPilot11100.Erp.TranDocType
where
		TranDocTypeID like 'ND%'
		AND		Company='UY01'

		select IH.CreditMemo,IH.TranDocTypeID,IH.InvoiceNum, IHU.*FROM				[CHILEPIDB].EpicorPilot11100.Erp.InvcHead			IH			WITH (NoLock)
		inner join	[CHILEPIDB].EpicorPilot11100.Erp.InvcHead_UD			IHU			WITH (NoLock)
		ON				IH.SysRowID						=				IHU.ForeignSysRowID 
		where --IH.InvoiceNum =11678
				IH.TranDocTypeID like 'ND%'
		OR		IH.TranDocTypeID like 'NC%'
		AND		IH.Company='UY01'


SET DATEFORMAT DMY
 
SELECT				--TOP 100 
					C.Company, 
					C.CustID											AS	SoldToCustID, 
					IH.InvoiceNum										AS	PAC_InvoiceRef_c, 
					IH.LegalNumber										AS	PAC_InvRefLegNum_c, 
					IH.Plant, 
					IH.PONum, 
					IH.TermsCode, 
					IH.InvoiceComment,
					IH.InvoiceDate,
					--IHU.Character07, 
					ID.ShipToNum, 
					ID.SellingShipQty,
					ID.PartNum, 
--					PU.Character02										AS UNegocio,
					ID.InvoiceComment 
FROM				[CHILEPIDB].EpicorPilot11100.Erp.InvcHead			IH			WITH (NoLock)
INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.Customer			C			WITH (NoLock)
	ON				IH.Company						=				C.Company
	AND				IH.CustNum						=				C.CustNum
INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.InvcDtl			ID			WITH (NoLock)
	ON				IH.Company						=				ID.Company
	AND				IH.InvoiceNum 					=				ID.InvoiceNum 
--INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.InvcHead_UD		IHU			WITH (NoLock)
--	ON				IH.SysRowID						=				IHU.ForeignSysRowID 
--INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.Part									P			WITH(NoLock)
--	ON				ID.Company						=				P.Company
--	AND				ID.PartNum						=				P.PartNum
--INNER JOIN			[CHILEPIDB].EpicorPilot11100.Erp.Part_UD								PU			WITH(NoLock)

	--ON				P.SysRowID				=			PU.ForeignSysRowID
WHERE				IH.InvoiceDate					>=				'01/01/2022'
	--AND				IH.LegalNumber					LIKE			'NCE-%'--'FE-%'
	--AND				IH.InvoiceNum					in				(26696)
	AND				IH.Company						in				('UY01')
ORDER BY			IH.InvoiceDate DESC

select SysRowID,LegalNumber,* from [CHILEPIDB].EpicorPilot11100.Erp.InvcHead			IH			WITH (NoLock)
where	InvoiceNum=11678--27915

select CL_InvoiceRef_c,	CL_InvRefLegNum_c, CONCAT(UY_Serie_c,'-',UY_Number_c) AS UY_InvRefLegNum_c,UY_UniqueIdNumber_c, * from [CHILEPIDB].EpicorPilot11100.Erp.InvcHead_UD			IH			WITH (NoLock)
where	ForeignSysRowID ='7D21119F-19F5-4DE8-8DE9-EFED508365B4'--'FB2FF997-F38D-4A31-90D2-D8129F1629CF'

	




select			IH.SysRowID,IHU.PAC_InvoiceRef_c,	IHU.PAC_InvRefLegNum_c, IHU.* 
from			[CORPL11-EPIDB].[EpicorERPTest].Erp.InvcHead			IH			WITH (NoLock)
inner join		[CORPL11-EPIDB].[EpicorERPTest].Erp.InvcHead_UD			IHU			WITH (NoLock)
on				IH.SysRowID		=		IHU.ForeignSysRowID			
where	
				IH.InvoiceNum=373879--27915


select			IH.SysRowID,IHU.CL_InvoiceRef_c,	IHU.CL_InvRefLegNum_c, IHU.* 
from			[CHILEPIDB].EpicorPilot11100.Erp.InvcHead			IH			WITH (NoLock)
inner join		[CHILEPIDB].EpicorPilot11100.Erp.InvcHead_UD			IHU			WITH (NoLock)
on				IH.SysRowID		=		IHU.ForeignSysRowID			
where	
				IH.InvoiceNum=26755--27915

select			IH.SysRowID,IHU.CL_InvoiceRef_c,	IHU.CL_InvRefLegNum_c, CONCAT(IHU.UY_Serie_c,'-',IHU.UY_Number_c) AS UY_InvRefLegNum_c,IHU.UY_UniqueIdNumber_c,
				IHU.* 
from			[CHILEPIDB].EpicorPilot11100.Erp.InvcHead				IH			WITH (NoLock)
inner join		[CHILEPIDB].EpicorPilot11100.Erp.InvcHead_UD			IHU			WITH (NoLock)
on				IH.SysRowID		=		IHU.ForeignSysRowID			
where			IH.Company		=		'UY01'
and				IH.InvoiceNum=11678--27915


select			IH.TranDocTypeID, IH.InvoiceNum, IH.LegalNumber, IHU.UY_InvoiceRef_c, IHU.UY_LegalNumRef_c
			--	IH.SysRowID,IHU.CL_InvoiceRef_c,	IHU.CL_InvRefLegNum_c, CONCAT(IHU.UY_Serie_c,'-',IHU.UY_Number_c) AS UY_InvRefLegNum_c,IHU.UY_UniqueIdNumber_c,
			--	IHU.* 
from			[EpicorLive11100].Erp.InvcHead				IH			WITH (NoLock)
inner join		[EpicorLive11100].Erp.InvcHead_UD			IHU			WITH (NoLock)
on				IH.SysRowID		=		IHU.ForeignSysRowID			
where			IH.Company		=		'UY01'
and				IH.InvoiceNum in (12195,10773)

select * from	[EpicorLive11100].Erp.TranDocType
where			TranDocTypeID  in ('E-TICKET NC','E-FACT NC','E-TICKET ND','E-FACT ND')
--or				TranDocTypeID  like 'E-FACT%'
and				Company		=		'UY01'