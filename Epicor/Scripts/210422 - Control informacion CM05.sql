
SET DATEFORMAT DMY

SELECT			UD.Company, 
				UD.Key1,										-- Valor Fijo
				UD.Key2,										-- CustNum 
				UD.Key3,										-- Jurisdiccion
				UD.Key4, 
				UD.Key5, 
				UD.Number01,									-- Coeficiente
				UD.Date01,										-- Fecha Desde
				UD.Date02,										-- Fecha Hasta
				UD.ShortChar01, 								-- Tipo
				C.CustID, 
				C.[Name]
FROM			[CORPEPIDB].EpicorErp.Ice.UD01					UD
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Customer				C
	ON			UD.Company		=			C.Company
	AND			UD.Key2			=			C.CustNum 
WHERE			UD.Key1			=			'CM05' 
--	AND			UD.Date01		=			'01/07/2021'
	AND			UD.Date02		=			'31/05/2021'
--	AND			YEAR(UD.Date01)	=			2021
--	AND			ShortChar01		<>			'M'
ORDER BY		1, 2, 3, 4 

