Select * from [CORPE11-EPIDB].[EpicorERP].Erp.ShipHead
where packnum=315573

Select top 10 * from [CORPE11-EPIDB].[EpicorERP].Erp.ShipDtl
where packnum=315573
AND		PackLine>1

begin tran
update  [CORPE11-EPIDB].[EpicorERP].Erp.ShipHead
set ReadyToInvoice=0,
LegalNumber=''--'R-9999-00000734'
where packnum=308397



commit tran
rollback tran


select * from [CORPE11-SSRS].[RVF_Local].dbo.RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
where 
			ShipPerson like 'Usr_%'


		/* =========================================================================================
           1) Tabla variable con los registro que tenaga mas de un dia con problema de integracion
           ========================================================================================= */
        DECLARE @TablaTemporal TABLE
        (
            Company			varchar(5)		NOT NULL,
			CustID			varchar(20)		NOT NULL,
			PackNum			Int				NOT NULL,			
            LegalNumber		varchar(30)		NULL,
			ShipStatus		varchar(30)		NULL,
			ReadyToInvoice	BIT				NULL,
			Plant			varchar(15)		NULL,
			ShipPerson		varchar(50)		NULL,
			ChangeTime		DATETIME		NULL,
			Lineas			INT				NULL,
			OrderNum		INT				NULL,
			ShipCompl		INT				NULL,
			ShipToNum		varchar(15)		NULL,
			DaysCompl		INT				NULL

        );

		 /*Despachos con problemas generados por la Integracion */
        INSERT INTO @TablaTemporal (Company,CustID,PackNum,LegalNumber,ShipStatus,ReadyToInvoice,Plant,ShipPerson,ChangeTime,Lineas,OrderNum,ShipCompl,ShipToNum,DaysCompl)

		SELECT		Company,CustID,PackNum,LegalNumber,ShipStatus,ReadyToInvoice,Plant,ShipPerson,ChangeTime,Lineas,OrderNum,ShipCompl,ShipToNum,DaysCompl
		FROM		[CORPE11-SSRS].[RVF_Local].dbo.RVF_VW_DIST_EMBARQUES_NO_FACTURADOS
		WHERE		
					ShipPerson like 'Usr_%'
		AND			DaysCompl	>1

		/* ================================================================================
           2) Saco (LegalNumber y ReadyToInvoice) a los Registros con numero legal asignado
           ================================================================================ */
		--SELECT COUNT(*) FROM @TablaTemporal WHERE ReadyToInvoice=0
		--SELECT 1 @TablaTemporal WHERE LegalNumber<>''
		IF((SELECT COUNT(*) FROM @TablaTemporal WHERE LegalNumber<>'' AND ReadyToInvoice=1) > 0)
		BEGIN
				UPDATE		SH
				SET			SH.LegalNumber		=	'',
							SH.ReadyToInvoice	=	0
							
				FROM		[CORPE11-EPIDB].[EpicorERP].Erp.ShipHead	SH
				
				INNER JOIN	@TablaTemporal								S
				ON			SH.Company		=		S.Company
				AND			SH.PackNum		=		S.PackNum
				WHERE		
							LegalNumber		<>		''
							
				AND			ReadyToInvoice	=		1



		END

		/* ================================================================================
           2) Elimino las lineas de los Despachos que no tenga Numero Legal asignado
           ================================================================================ */
		ELSE IF((SELECT COUNT(*) FROM @TablaTemporal WHERE LegalNumber='' AND ReadyToInvoice=0 AND Lineas>0) > 0)
		BEGIN
				SELECT --DELETE		
							SD.*
				FROM		[CORPE11-EPIDB].[EpicorERP].Erp.ShipHead	SH

				INNER JOIN	[CORPE11-EPIDB].[EpicorERP].Erp.ShipDtl		SD
				ON			SH.Company				=			SD.Company
				AND			SH.PackNum				=			SD.PackNum
				
				INNER JOIN	@TablaTemporal								S
				ON			S.Company				=			S.Company
				AND			S.PackNum				=			S.PackNum

		END

		/* ================================================================================
           3) Elimino las lineas de los Despachos que no tenga Numero Legal asignado en ordera Descendentemente
           ================================================================================ */
		ELSE IF((SELECT COUNT(*) FROM @TablaTemporal WHERE LegalNumber='' AND ReadyToInvoice=0 AND Lineas>0) > 0)
		BEGIN
				SELECT --DELETE		
							SD.*
				FROM		[CORPE11-EPIDB].[EpicorERP].Erp.ShipHead	SH

				INNER JOIN	[CORPE11-EPIDB].[EpicorERP].Erp.ShipDtl		SD
				ON			SH.Company				=			SD.Company
				AND			SH.PackNum				=			SD.PackNum
				
				INNER JOIN	@TablaTemporal								S
				ON			S.Company				=			S.Company
				AND			S.PackNum				=			S.PackNum

		END

		/* ================================================================================
           4) Elimino los Encabezado de Despachos que no tiene liena ni Numero Legal asignado 
           ================================================================================ */
		ELSE IF((SELECT COUNT(*) FROM @TablaTemporal WHERE LegalNumber='' AND ReadyToInvoice=0 AND Lineas=0) > 0)
		BEGIN
				SELECT --DELETE		
							SH.*
				FROM		[CORPE11-EPIDB].[EpicorERP].Erp.ShipHead	SH

				INNER JOIN	[CORPE11-EPIDB].[EpicorERP].Erp.ShipDtl		SD
				ON			SH.Company				=			SD.Company
				AND			SH.PackNum				=			SD.PackNum
				
				INNER JOIN	@TablaTemporal								S
				ON			S.Company				=			S.Company
				AND			S.PackNum				=			S.PackNum

		END