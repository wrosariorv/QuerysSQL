USE [RVF_Local]
GO





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
AND					MQH.nroCotizacion	in ('46653','47154','47155','47156')

--AND					MQH.nroCotizacion	Not in	(Select Cotizacion from RVF_TBL_IMP_QUOTE_LOG)


select * from [CORPSQLMULT2019].[moviventas].[dbo].[vw_detalle_cotizacion]		WITH(NoLock)
where 

		nroCotizacion	in ('46653','47154','47155','47156')
GO

select * from [CORPL11-EPIDB].EpicorERPDev.Erp.ShipTo
where
SalesRepCode='UN71'

select * from [CORPL11-EPIDB].EpicorERPDev.Erp.Customer
where
custNum in (10273,1212,123)

select * from RVF_VW_MOVI_TEST_CLIENTES_DOMICILIOS_VENDEDORES
where
CodigoDomicilio='OUTLET'
CodVendedor='UN71'
	CodigoCliente in ('46648',
'50452'
)