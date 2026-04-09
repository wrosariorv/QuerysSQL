USE [RVF_Local]
GO


/*

ALTER VIEW		[dbo].[RVF_VW_IMP_QUOTE_HEADER]
AS
-- */



SELECT				
					
					MQH.[compania]											AS Company,
					MQH.[nroCotizacion]										AS QuoteNum,
					convert (date,MQH.[fecha])								AS EntryDate,
					MQH.[codInternoCliente]									AS CustNum,
					ISNULL(MQH.[codDomicilioEntrega],'')					AS ShipToNum,
					ISNULL(MQH.[ordenDeCompra],'')							AS PONum,
					MQH.[codCampana]										AS MktgCampaignID,
					--,'001'												AS MktgCampaignID	
					ISNULL(MQH.[codCondicionDePago],'')						AS TermsCode,
					ISNULL(convert (date,MQH.[fechaEntrega]),'')			AS RequestDate,
					MQH.[codCliente]										AS CustID
					
FROM				[CORPSQLMULT2019].[moviventas].[dbo].[vw_cotizaciones] MQH		WITH(NoLock)
INNER JOIN			(
						SELECT		compania,nroCotizacion FROM [CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]		WITH(NoLock)
						WHERE		nroCotizacion		IS NOT NULL
						--AND			nroCotizacion		Not in	(Select Cotizacion from RVF_TBL_IMP_QUOTE_LOG)
						--AND			codProducto			NOT LIKE			'%-SK'
						GROUP BY	compania,nroCotizacion
					) MQD
ON					MQH.compania				=		MQD.compania
AND					MQH.nroCotizacion			=		MQD.nroCotizacion

WHERE			
					MQH.nroCotizacion	IS NOT NULL
AND					MQH.nroCotizacion	> '2013'
--AND					MQH.nroCotizacion	Not in	(Select Cotizacion from RVF_TBL_IMP_QUOTE_LOG)
AND					MQH.nroCotizacion	in (57258,57278)

select * from RVF_VW_IMP_QUOTE_DETAIL
where QuoteNum in (57258,57278)

select * from [CORPSQLMULT2019].[moviventas].[dbo].[vw_cotizaciones] MQH		WITH(NoLock)
where 
		nroCotizacion in (57258,57278)

select * from [CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion] MQD		WITH(NoLock)
where 
		nroCotizacion in (57258,57278)



GO


