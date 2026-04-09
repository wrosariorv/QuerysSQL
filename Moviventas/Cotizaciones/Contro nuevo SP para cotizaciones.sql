
/*

ALTER PROCEDURE		[dbo].[RVF_PRC_IMP_QUOTE]
AS
-- */

--SET NOCOUNT ON;

/* ================================================================
1) Tabla variable de staging (sin #temp)
================================================================ */
DECLARE @TeporalHEADER TABLE
(
	[Company] [varchar](10) NOT NULL,
	[QuoteNum] [varchar](50) NOT NULL,
	[EntryDate] [date] NOT NULL,
	[CustNum] [int] NOT NULL,
	[ShipToNum] [varchar](50) NOT NULL,
	[PONum] [varchar](50) NULL,
	[MktgCampaignID] [varchar](50) NOT NULL,
	[TermsCode] [varchar](50) NOT NULL,
	[RequestDate] [date] NOT NULL,
	[CustID] [varchar](50) NOT NULL,
	[Territory] [varchar](50) NOT NULL,
	[SalesRepCode] [varchar](50) NOT NULL,
	[DateTime] [datetime] NOT NULL,

	PRIMARY KEY (Company, QuoteNum)  
	
);

/*******************************************************
	Inserto cotizaciones pendiente en tabla temporal
********************************************************/

INSERT INTO @TeporalHEADER ([Company],[QuoteNum] ,[EntryDate],[CustNum],[ShipToNum] ,[PONum],[MktgCampaignID],[TermsCode],[RequestDate] ,[CustID],
							[Territory],[SalesRepCode],[DateTime])

--INSERT INTO  RVF_TBL_IMP_QUOTE_LOG	([Company],[Cotizacion],[Estado],[FechaProceso],[Observaciones],[CotizacionEpicor])

SELECT				
					MQH.[compania]											AS Company,
					MQH.[nroCotizacion]										AS QuoteNum,					
					convert (date,MQH.[fecha])								AS EntryDate,
					MQH.[codInternoCliente]									AS CustNum,
					ISNULL(MQH.[codDomicilioEntrega],'')					AS ShipToNum,
					--'TCL-99'												AS ShipToNum,
					ISNULL(MQH.[ordenDeCompra],'')							AS PONum,
					MQH.[codCampana]										AS MktgCampaignID,
					--,'001'												AS MktgCampaignID	
					ISNULL(MQH.[codCondicionDePago],'')						AS TermsCode,
					ISNULL(convert (date,MQH.[fechaEntrega]),'')			AS RequestDate,
					MQH.[codCliente]										AS CustID,					
					'TCL18'													AS Territory,
					'TCL18'													AS SalesRepCode,
					GETDATE()												AS [DateTime]
					--,DATEADD(DAY, -30, GETDATE())							AS date
					
					
FROM				[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cotizaciones] MQH		WITH(NoLock)
INNER JOIN			(
						SELECT		compania,nroCotizacion FROM [CORPSQLMULT2019].[moviventas_test].[dbo].[vw_detalle_cotizacion]		WITH(NoLock)
						WHERE		nroCotizacion		IS NOT NULL
						--AND			codProducto			NOT LIKE			'%-SK'
						GROUP BY	compania,nroCotizacion
					) MQD
ON					MQH.compania				=		MQD.compania
AND					MQH.nroCotizacion			=		MQD.nroCotizacion

WHERE			
					MQH.nroCotizacion					IS NOT NULL
AND					MQH.nroCotizacion					> '2013'
AND					MQH.nroCotizacion	Not in	(Select Cotizacion from RVF_TBL_IMP_QUOTE_LOG)
AND					MQH.nroCotizacion	Not in	(Select QuoteNum from RVF_TBL_IMP_QUOTE_HEADER)
--AND					MQH.nroCotizacion					in ('26108')
AND					CAST (MQH.Fecha AS date)			>=		DATEADD(DAY, -30, GETDATE())



/*******************************************************
	Inserto cotizaciones pendiente en tabla temporal
********************************************************/
IF( (SELECT COUNT(*) FROM @TeporalHEADER) >0)
BEGIN

		--INSERT INTO [dbo].RVF_TBL_IMP_QUOTE_HEADER ([Company],[QuoteNum] ,[EntryDate],[CustNum],[ShipToNum] ,[PONum],[MktgCampaignID],[TermsCode],[RequestDate] ,[CustID],
		--							[Territory],[SalesRepCode],[DateTime])
		SELECT				*
		FROM				@TeporalHEADER


		--INSERT INTO [dbo].RVF_TBL_IMP_QUOTE_DETAIL ([Company],[QuoteNum],[QuoteLine],[PartNum],[SellingExpectedQty],[ListPrice],[DiscountPercent])

		SELECT				MQD.[compania]																				AS Company,
							MQD.[nroCotizacion]																			AS QuoteNum,
		--					MQD.[nroLinea]																				AS QuoteLine,
							[dbo].[RVF_FNC_Calcula_NroLinea] (MQD.[compania], MQD.[nroCotizacion], MQD.[nroLinea])		AS QuoteLine, 
							MQD.[codProducto]																			AS PartNum,
							MQD.[cantidad]																				AS SellingExpectedQty,
							MQD.[precio]																				AS ListPrice,
							ISNULL(MQD.[descuento],0)																	AS DiscountPercent  

		FROM				[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_detalle_cotizacion]		MQD		WITH(NoLock)
		INNER JOIN			(
							SELECT		compania,nroCotizacion 
							FROM		[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cotizaciones]		WITH(NoLock)
							WHERE		nroCotizacion		IS NOT NULL
							AND			CAST (Fecha AS date)			>=		DATEADD(DAY, -30, GETDATE())
							)	MQH

		ON					MQH.compania			=			MQD.compania
		AND					MQH.nroCotizacion		=			MQD.nroCotizacion
		INNER JOIN			(
								SELECT			
													Company,
													QuoteNum
								FROM				@TeporalHEADER
							) TEMP
		ON					TEMP.Company			=			MQD.compania
		AND					TEMP.QuoteNum			=			MQD.nroCotizacion

		WHERE				
							MQD.nroCotizacion		IS NOT NULL
		AND					MQD.nroCotizacion		='26108'			
		AND					MQD.[descuento]			<>0


END

GO

SELECT		H.*
FROM		dbo.RVF_TBL_IMP_QUOTE_HEADER AS H
WHERE NOT EXISTS 
				(
					SELECT	1
					FROM	dbo.RVF_TBL_IMP_QUOTE_LOG AS l
					WHERE 
							l.Company   = h.Company
					  AND	l.cotizacion = h.QuoteNum
				);


		SELECT * FROM RVF_TBL_IMP_QUOTE_LOG
		WHERE Company='CO01'
		and		Cotizacion LIKE '26108%'

		BEGIN TRAN
		UPDATE RVF_TBL_IMP_QUOTE_LOG
		SET Cotizacion='26108Prueba9'
		WHERE Company='CO01'
		and		Cotizacion = '26108'
		
		ROLLBACK TRAN
		--COMMIT TRAN


SELECT * FROM RVF_TBL_IMP_QUOTE_LOG
where CotizacionEpicor <>0
order by CAST (FechaProceso as date) desc