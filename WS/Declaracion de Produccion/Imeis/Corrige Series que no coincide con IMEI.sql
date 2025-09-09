-- 1. Cargar primero solo los Labels recientes
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
    FROM		[PLANSQLMULT2019].SIP.dbo.Labels L
    INNER JOIN	[PLANSQLMULT2019].SIP.dbo.HDT H
        ON		L.MSN		 =		H.Msn
    WHERE		CAST(L.TimeMaster AS date) > '2024-12-09';
 
    
    SELECT			TOP 100
					UD.ForeignSysRowID,
					LBL.ImeI_1
    FROM			[WS].DBO.RV_TBL_SIP_ITEM_TP I
    INNER JOIN		[CORPE11-EPIDB].EpicorERP.ERP.SerialNo SN
        ON			I.Company		=			SN.Company
        AND			I.PartNum		=			SN.PartNum
        AND			I.Serie			=			SN.SerialNumber
    INNER JOIN		[CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD UD WITH (NOLOCK)
        ON			SN.SysRowID		=			 UD.ForeignSysRowID
    INNER JOIN		@Labels LBL
        ON			LBL.ModeloRV	=			I.PartNum
        AND			LBL.SerialRV	=			I.Serie
    WHERE 
					 UD.imei_c						= '869695071192162'


					 
					SELECT 
				L.ModeloRV,
				L.SerialRV,
				H.ImeI_1
    FROM		[PLANSQLMULT2019].SIP.dbo.Labels L
    INNER JOIN	[PLANSQLMULT2019].SIP.dbo.HDT H
        ON		L.MSN		 =		H.Msn
    WHERE		
	L.SerialRV in ('RF1408074759371','RF1408074759403')
	CAST(L.TimeMaster AS date) > '2024-12-09'
	and H.ImeI_1='869695071192162'

	 SELECT			TOP 100
					SN.SerialNumber,
					UD.ForeignSysRowID,
					UD.imei_c
    FROM			[CORPE11-EPIDB].EpicorERP.ERP.SerialNo SN

    INNER JOIN		[CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD UD WITH (NOLOCK)
        ON			SN.SysRowID		=			 UD.ForeignSysRowID

    WHERE				SN.SerialNumber in ('RF1408074759371','RF1408074759403')
					 --UD.imei_c						= '869695071192162'
	

						SELECT 
				L.ModeloRV,
				L.SerialRV,
				H.ImeI_1
    FROM		[PLANSQLMULT2019].SIP.dbo.Labels L
    INNER JOIN	[PLANSQLMULT2019].SIP.dbo.HDT H
        ON		L.MSN		 =		H.Msn
    WHERE		
	L.SerialRV in ('RF1408074759371','RF1408074759403')


	UPDATE UD
    SET imei_c = '869695071195975'
    FROM [CORPE11-EPIDB].[EpicorERP].ICE.SerialNo_UD UD
    where 
			ForeignSysRowID ='FF39625B-A0BE-4852-9169-A48A0C8F6C61'

		UPDATE UD
    SET imei_c = '869695071195975'
    FROM ERP.SerialNo_UD UD
    where 
			ForeignSysRowID ='FF39625B-A0BE-4852-9169-A48A0C8F6C61'