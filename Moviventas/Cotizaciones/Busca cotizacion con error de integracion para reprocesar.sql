SELECT		
                TOP 10
                H.Company,	H.QuoteNum,	H.EntryDate,	H.CustNum,	            H.ShipToNum, H.PONum,	H.MktgCampaignID,	H.TermsCode,	H.RequestDate,
      H.CustID,	H.Territory,	H.SalesRepCode,	H.[DateTime]
FROM		dbo.RVF_TBL_IMP_QUOTE_HEADER AS H
WHERE NOT EXISTS 
				(
					SELECT	1
					FROM	dbo.RVF_TBL_IMP_QUOTE_LOG AS l
					WHERE 
							l.Company   = h.Company
					  AND	l.cotizacion = h.QuoteNum
				)
ORDER by H.QuoteNum desc;

Select			* 
from			RVF_TBL_IMP_QUOTE_LOG
order by FechaProceso desc

Select			* 
from			RVF_TBL_IMP_QUOTE_LOG
where			
Cotizacion in(
'62275',
'62276',
'62374',
'62849',
'62850'

)


				Cotizacion in 
				(
					63064,
					63065,
					63066
				)



Select			* 
from			RVF_TBL_IMP_QUOTE_LOG
where			Estado=0 
AND				(
					Observaciones like '%An error occurred while reading from the store provider%'
				OR
					Observaciones like '%The timeout period elapsed prior to completion of the operation or the server%'
				)
AND				FechaProceso >=		DATEADD(MONTH, -1, GETDATE())

order by FechaProceso desc

SELECT	*
FROM	dbo.RVF_TBL_IMP_QUOTE_HEADER_PROBLEMA AS BQ
WHERE	BQ.Company	= MQH.compania 
AND		BQ.QuoteNum = MQH.nroCotizacion


begin tran
DELETE 
from			RVF_TBL_IMP_QUOTE_LOG

where			Estado=0 
AND				(
					Observaciones like '%An error occurred while reading from the store provider%'
				OR
					Observaciones like '%The timeout period elapsed prior to completion of the operation or the server%'
				)
AND				FechaProceso >=		DATEADD(MONTH, -1, GETDATE())

commit tran