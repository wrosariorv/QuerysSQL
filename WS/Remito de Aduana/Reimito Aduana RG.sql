SELECT	
		TOP 10000
		Company, 
		Key1, 
		Key2, 
		Key3, 
		Key4, 
		Key5, 
		ShortChar02, 
		ShortChar03

--* 
FROM	[CORPE11-EPIDB].[EpicorERP].Ice.UD40 
WHERE 
		ShortChar02 LIKE 'RA-RG-%'
ORDER BY TRY_CAST (ShortChar03 AS datetime) DESC