SELECT				I.*,SN.SNStatus, UD.[imei_c], UD.ForeignSysRowID, LH.ImeI_1, LH.MSN
FROM				[WS].DBO.RV_TBL_SIP_ITEM_TP I
INNER JOIN			[CORPE11-EPIDB].EpicorERP.ERP.SerialNo		SN
ON						I.Company			=			SN.Company
AND						I.PartNum			=			SN.PartNum
AND						I.Serie				=			SN.SerialNumber
INNER JOIN			[CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD								UD		WITH (NoLock)
ON					SN.SysRowID			=			UD.ForeignSysRowID
	
LEFT JOIN			(
						SELECT				--TOP 1000
											L.MSN, L.SerialRV,L.ModeloRV
											, H.[ImeI_1]
						FROM				[PLANSQLMULT2019].SIP.dbo.Labels		L
	
						Inner JOIN			[PLANSQLMULT2019].SIP.dbo.HDT			H
						ON					L.MSN				=			H.Msn
						WHERE				
											CAST(L.TimeMaster AS date)>'2024-12-09'
					) AS LH
ON					LH.ModeloRV				=				I.PartNum	
and					LH.SerialRV				=				I.Serie		

WHERE				CAST(I.HoraFabricacion AS DATE)>'2024-12-09'
AND					I.Estado				=	'Integrado'
AND					UD.[imei_c]				=	''
						


update [CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD	
set --[imei_c]='358626843257965'
	[imei_c]='358626843296344'
where
	--ForeignSysRowID='ABC5ECF8-1578-4C38-8382-3824608D6C99'
	ForeignSysRowID='E3B194BA-5616-4047-B916-81AA74CA431A'