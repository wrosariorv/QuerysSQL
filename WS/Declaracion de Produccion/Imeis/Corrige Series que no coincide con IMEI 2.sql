DECLARE @Pendientes TABLE (
      ForeignSysRowID UNIQUEIDENTIFIER PRIMARY KEY,
      NuevoImei NVARCHAR(50)
  );

  DECLARE @Labels TABLE (
      ModeloRV NVARCHAR(50),
      SerialRV NVARCHAR(50),
      ImeI_1 NVARCHAR(50)
  );

  INSERT INTO @Labels (ModeloRV, SerialRV, ImeI_1)
  SELECT 
        L.ModeloRV,
        L.SerialRV,
        H.ImeI_1
  FROM        [PLANSQLMULT2019].SIP.dbo.Labels L
  INNER JOIN    [PLANSQLMULT2019].SIP.dbo.HDT H
      ON        L.MSN         =        H.Msn
  WHERE     L.SerialRV		in ('RT3403510004994')   
			--L.SerialRV		in ('RT3403510004994', 'RT3403510000404')
			--CAST(L.TimeMaster AS date) >= DATEADD(WEEK, -1, GETDATE())--> '2024-12-09';
--INSERT INTO @Pendientes (ForeignSysRowID, NuevoImei)

select * from @Labels

INSERT INTO @Pendientes (ForeignSysRowID, NuevoImei)
SELECT 
					UD.ForeignSysRowID,
					--SN.SerialNumber,
					LBL.ImeI_1
  FROM            [WS].DBO.RV_TBL_SIP_ITEM_TP I
  INNER JOIN        [CORPE11-EPIDB].EpicorERP.ERP.SerialNo SN
      ON            I.Company        =            SN.Company
      AND            I.PartNum        =            SN.PartNum
      AND            I.Serie            =            SN.SerialNumber
  INNER JOIN        [CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD UD WITH (NOLOCK)
      ON            SN.SysRowID        =             UD.ForeignSysRowID
  INNER JOIN        @Labels LBL
      ON            LBL.ModeloRV    =            I.PartNum
      AND            LBL.SerialRV    =            I.Serie
  WHERE				
					SN.SerialNumber in ('RT3403510004994')
					--SN.SerialNumber in ('RT3403510004994', 'RT3403510000404')
					
UPDATE UD
SET imei_c = '353934780070408'
FROM [CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD UD
INNER JOIN @Pendientes P
    ON UD.ForeignSysRowID = P.ForeignSysRowID;

	select			SN.SerialNumber,
					UD.imei_c
	from			[CORPE11-EPIDB].EpicorERP.ERP.SerialNo SN
     
  INNER JOIN        [CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD UD WITH (NOLOCK)
      ON            SN.SysRowID        =             UD.ForeignSysRowID
	where	
			imei_c in ('353934780070408')
			--imei_c in ('353934780068683')