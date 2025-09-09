
Select 
					
					
					Key4			AS NumeroOC
					
					
From [EpicorLive11100].[ICE].[UD10]	
where 
Key3 = 'TC'

GROUP BY Key4


select * from RVF_TBL_API_VENTAS_WEB

Select 
					
					Key3			AS CanalEntrada,
					Key4			AS NumeroOC,
					Key5			AS NumeroDocumento,
					Character01		AS [Log],
					Date02			AS FechaAltaOV,
					ShortChar17		AS Estado,
					ShortChar18		AS NumeroOV,
					CheckBox02		AS Integrado
					
From [EpicorLive11100].[ICE].[UD10]	
where 
Key3 = 'TC'
AND Key4 in (

'3725',	'3738'

)
--AND ShortChar17 like 'ERR'


GROUP BY Key3,	 Key4, Key5, Character01, Date02, ShortChar17, ShortChar18,	 CheckBox02	


select *
from [EpicorLive11100].erp.[InvcDtl]
where
Ordernum in 
(
'2379',
'3524',
'2490',
'2633',
'2719',
'2934',
'2940',
'2985',
'3146',
'3165',
'3394',
'3408',
'3409',
'3470',
'3475',
'3480',
'3493',
'3494',
'3496',
'3500',
'3572',
'3708',
'3729',
'3730',
'3733',
'3742',
'3743',
'3750',
'4005',
'4103',
'4163',
'4168',
'4183',
'4189',
'4200',
'4215',
'4216',
'4218',
'4224',
'4232',
'4237',
'4275',
'4291',
'4304',
'4366',
'4376',
'4920',
'4926',
'4969',
'5078',
'5114',
'5159',
'5927',
'5936',
'5989',
'6061',
'6132',
'6161',
'6165',
'6219'
)

select *
from [EpicorLive11100].erp.[InvcHead]
where
InvoiceNum in 
(
'12422',
'13621',
'12464',
'12638',
'12721',
'12907',
'12908',
'12924',
'13131',
'13158',
'13451',
'13478',
'13481',
'13557',
'13559',
'13562',
'13582',
'13583',
'13585',
'13589',
'13676',
'13770',
'13798',
'13799',
'13800',
'13806',
'13807',
'13824',
'14113',
'14223',
'14268',
'14270',
'14310',
'14311',
'14315',
'14338',
'14339',
'14340',
'14342',
'14361',
'14363',
'14439',
'14455',
'14474',
'14504',
'14507',
'14864',
'14865',
'14753',
'14817',
'14846',
'14893',
'15521',
'15535',
'15586',
'15691',
'15794',
'15815',
'15817',
'15941'
)


FROM				[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
						LEFT OUTER JOIN			[EpicorLive11100].[Erp].[OrderHed]		OH		WITH(NoLock)
							ON 					UD.Company			=				OH.Company	
							AND					UD.Key4		=				CAST(OH.PONum AS VARCHAR (50))
						LEFT OUTER JOIN	[EpicorLive11100].[Erp].[InvcDtl]				ID		WITH(NoLock)
							ON 					OH.Company			=				ID.Company	
							AND					OH.OrderNum		=				CAST(ID.OrderNum AS VARCHAR (50))
						LEFT OUTER JOIN	[EpicorLive11100].[Erp].[InvcHead]				IH		WITH(NoLock)
							ON 					ID.Company			=				IH.Company	
							AND					ID.InvoiceNum 		=				IH.InvoiceNum
							
							WHERE				UD.Company					=			'CL01'
							AND					UD.Key3						=			'TC'


SELECT 
								UD.Key3,
								UD.Key4,
								OH.OrderNum,
								--IH.OrderNum,
								COUNT(*)
FROM
								[EpicorLive11100].[ICE].[UD10]			UD		WITH(NoLock)
LEFT OUTER JOIN					[EpicorLive11100].[Erp].[OrderHed]		OH		WITH(NoLock)
	ON 							UD.Company			=				OH.Company	
	AND							UD.Key4		=				CAST(OH.PONum AS VARCHAR (50))
--LEFT OUTER JOIN					[EpicorLive11100].[Erp].[InvcDtl]				ID		WITH(NoLock)
--	ON 							OH.Company			=				ID.Company	
--	AND							OH.OrderNum			=				CAST(ID.OrderNum AS VARCHAR (50))
--LEFT OUTER JOIN					[EpicorLive11100].[Erp].[InvcHead]				IH		WITH(NoLock)
--	ON 							ID.Company			=				IH.Company	
--	AND							ID.InvoiceNum 		=				IH.InvoiceNum
WHERE							UD.Company					=			'CL01'
	AND							UD.Key3						=			'TC'
group by UD.Key3,	UD.Key4,	OH.OrderNum--,	IH.OrderNum
HAVING COUNT(*) > 1