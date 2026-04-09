SELECT TOP (1000) [Company]
      ,[QuoteNum]
      ,[EntryDate]
      ,[CustNum]
      ,[ShipToNum]
      ,[PONum]
      ,[MktgCampaignID]
      ,[TermsCode]
      ,[RequestDate]
      ,[CustID]
      ,[Territory]
      ,[SalesRepCode]
      ,[DateTime]
  FROM [RVF_Local].[dbo].[RVF_TBL_IMP_QUOTE_HEADER]
  where ShipToNum =''
  AND CAST([DateTime] as date) > '2025-11-20'
  order by [DateTime] desc

  select * from [CORPSQLMULT2019].[moviventas].[dbo].[vw_cotizaciones] MQH
  where
		nroCotizacion in (
'58403',
'58351'
)

select * from  RVF_TBL_IMP_QUOTE_LOG
where
		CAST([FechaProceso] as date) > '2025-11-20'
