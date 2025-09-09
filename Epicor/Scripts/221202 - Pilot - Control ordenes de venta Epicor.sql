
SELECT				*
FROM				EpicorErp.Erp.QuoteHed						
WHERE				QuoteNum				IN					(119998, 119999, 120000, 120001)

SELECT				*
FROM				EpicorErp.Erp.QuoteDtl						
WHERE				QuoteNum				IN					(119998, 119999, 120000, 120001)

------------------------------------------------------------------------------------------

SELECT				*
FROM				EpicorErp.Erp.OrderHed						
WHERE				OrderNum				IN					(143450, 143452)

SELECT				*
FROM				EpicorErp.Erp.OrderDtl						
WHERE				OrderNum				IN					(143450, 143452)

------------------------------------------------------------------------------------------

SELECT				*
FROM				EpicorErp.Erp.InvcHead						
WHERE				OrderNum				IN					(143450, 143452)

SELECT				*
FROM				EpicorErp.Erp.InvcDtl						
WHERE				OrderNum				IN					(143450, 143452)

------------------------------------------------------------------------------------------




