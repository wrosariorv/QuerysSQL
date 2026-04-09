select * from [CORPSQLMULT2019].[moviventas_test].dbo.vw_cobranzas

Select * from /*[CORPL11-SSRS].[RVF_Local].dbo.*/RVF_TBL_IMP_QUOTE_LOG
where Cotizacion in ('55063')



SELECT * FROM RVF_TBL_IMP_QUOTE_LOG
WHERE TRY_CAST(Cotizacion AS INT) IS NULL 
  AND Cotizacion IS NOT NULL 

Select * from /*[CORPL11-SSRS].[RVF_Local].dbo.*/RVF_TBL_IMP_QUOTE_LOG
order by CAST(Cotizacion as int )desc


SELECT					*	
FROM					RVF_TBL_IMP_RECIBO_LOG		WITH(NoLock)
order by CAST(Recibo as int )desc

Select *  from /*[CORPL11-SSRS].[RVF_Local].dbo.*/RVF_TBL_IMP_QUOTE_LOG
where Cotizacion =59069
order by CAST(Cotizacion as int )desc

Select * from RVF_VW_IMP_QUOTE_HEADER

select top 100 EntryPerson,* from [CORPP11-EPIDB].[EpicorERP].erp.Quotehed
where 
	QuoteNum =215073
order By QuoteNum desc


select * from RVF_VW_IMP_QUOTE_DETAIL
where Company = 'CO01' and QuoteNum = '59068'
order by Company, QuoteNum , QuoteLine

select *   from [dbo].RVF_TBL_IMP_QUOTE_HEADER
where QuoteNum in (59070)
--Order by QuoteNum desc

Select *   from /*[CORPL11-SSRS].[RVF_Local].dbo.*/RVF_TBL_IMP_QUOTE_LOG
where Cotizacion in (59070)
--order by CAST(Cotizacion as int )desc

SELECT	*

FROM	dbo.RVF_TBL_IMP_QUOTE_HEADER_PROBLEMA

SELECT		H.Company,	H.QuoteNum,	H.EntryDate,	H.CustNum,	            H.ShipToNum, H.PONum,	H.MktgCampaignID,	H.TermsCode,	H.RequestDate,
      H.CustID,	H.Territory,	H.SalesRepCode,	H.[DateTime]
FROM		dbo.RVF_TBL_IMP_QUOTE_HEADER AS H
WHERE NOT EXISTS 
				(
					SELECT	1
					FROM	dbo.RVF_TBL_IMP_QUOTE_LOG AS l
					WHERE 
							l.Company   = h.Company
					  AND	l.cotizacion = h.QuoteNum
				);

SELECT
				MQD.compania,
				MQD.nroCotizacion,
				dbo.RVF_FNC_Calcula_NroLinea(MQD.compania, MQD.nroCotizacion, MQD.nroLinea),
				MQD.codProducto,
				MQD.cantidad,
				MQD.precio,
				ISNULL(MQD.descuento, 0)
	FROM		[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_detalle_cotizacion] AS MQD WITH(NOLOCK)
	INNER JOIN	(
					SELECT		compania, nroCotizacion
					FROM		[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_cotizaciones] WITH(NOLOCK)
					WHERE		nroCotizacion IS NOT NULL
					AND			CAST([fecha] as date)			>= '20250116'
					  --AND		CAST(Fecha AS DATE) >= DATEADD(DAY, -30, GETDATE())
				) AS MQH
		ON		MQH.compania		=		MQD.compania
	   AND		MQH.nroCotizacion	=		MQD.nroCotizacion
	
	WHERE
				MQD.nroCotizacion IS NOT NULL
	AND			MQD.nroCotizacion = '59068'