USE [RVF_Local]
GO

select * from RVF_TBL_IMP_QUOTE_DETAIL

CREATE TABLE [dbo].[RVF_TBL_IMP_QUOTE_DETAIL](
	[Company] [varchar](10) NOT NULL,
	[QuoteNum] [varchar](50) NOT NULL,
	[QuoteLine] [int] NOT NULL,
	[PartNum] [varchar](50) NOT NULL,
	[SellingExpectedQty] [FLOAT] NOT NULL,
	[ListPrice] [DECIMAL](17,5) NOT NULL,
	[DiscountPercent] [FLOAT]  NULL


 CONSTRAINT [PK_RVF_TBL_IMP_QUOTE_DETAIL] PRIMARY KEY CLUSTERED 
(
	[Company] ASC,
	[QuoteNum] ASC,
	[QuoteLine] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



SELECT				MQD.[compania]																				AS Company,
					MQD.[nroCotizacion]																			AS QuoteNum,
--					MQD.[nroLinea]																				AS QuoteLine,
					[dbo].[RVF_FNC_Calcula_NroLinea] (MQD.[compania], MQD.[nroCotizacion], MQD.[nroLinea])		AS QuoteLine, 
					MQD.[codProducto]																			AS PartNum,
					MQD.[cantidad]																				AS SellingExpectedQty,
					MQD.[precio]																				AS ListPrice,
					ISNULL(MQD.[descuento],0)																	AS DiscountPercent  

FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		MQD		WITH(NoLock)
INNER JOIN			(
					SELECT		compania,nroCotizacion 
					FROM		[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		WITH(NoLock)
					WHERE		nroCotizacion		IS NOT NULL
					)	MQH

ON					MQH.compania			=			MQD.compania
AND					MQH.nroCotizacion		=			MQD.nroCotizacion
WHERE				MQD.nroCotizacion		IS NOT NULL


select * from RVF_TBL_IMP_QUOTE_HEADER


CREATE TABLE [dbo].[RVF_TBL_IMP_QUOTE_HEADER](
	[Company] [varchar](10) NOT NULL,
	[QuoteNum] [varchar](50) NOT NULL,
	[EntryDate] [date] NOT NULL,
	[CustNum][INT] NOT NULL,
	[ShipToNum][varchar](50) NOT NULL,
	[PONum][varchar](50) NULL,
	[MktgCampaignID][varchar](50) NOT NULL,
	[TermsCode][varchar](50) NOT NULL,
	[RequestDate][date] NOT NULL,
	[CustID][varchar](50) NOT NULL


 CONSTRAINT [PK_RVF_TBL_IMP_QUOTE_HEADER] PRIMARY KEY CLUSTERED 
(
	[Company] ASC,
	[QuoteNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
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
					
FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones] MQH		WITH(NoLock)
INNER JOIN			(
						SELECT		compania,nroCotizacion FROM [CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		WITH(NoLock)
						WHERE		nroCotizacion		IS NOT NULL
						--AND			codProducto			NOT LIKE			'%-SK'
						GROUP BY	compania,nroCotizacion
					) MQD
ON					MQH.compania		=		MQD.compania
AND					MQH.nroCotizacion	=		MQD.nroCotizacion

WHERE			
					MQH.nroCotizacion	IS NOT NULL
AND					MQH.nroCotizacion	Not in	(Select Cotizacion from RVF_TBL_IMP_QUOTE_LOG)