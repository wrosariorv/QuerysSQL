/*
CREATE PROCEDURE ActualizarImeiEnSerialNo_UD
AS
*/
BEGIN
    SET NOCOUNT ON;

    DECLARE @Pendientes TABLE (
        ForeignSysRowID UNIQUEIDENTIFIER PRIMARY KEY,
        NuevoImei NVARCHAR(50)
    );

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

    -- 2. Insertar los pendientes aplicando filtros desde el principio
    --INSERT INTO @Pendientes (ForeignSysRowID, NuevoImei)
    SELECT 
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
					CAST(I.HoraFabricacion AS DATE) > '2024-12-09'
        AND			I.Estado						= 'Integrado'
        AND			UD.imei_c						= '';

     --3. Actualizar
    --UPDATE UD
    --SET imei_c = P.NuevoImei
    --FROM [CORPE11-EPIDB].[EpicorERP].ERP.SerialNo_UD UD
    --INNER JOIN @Pendientes P
    --    ON UD.ForeignSysRowID = P.ForeignSysRowID;
END
GO
