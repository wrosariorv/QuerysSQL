
USE RVF_Local
GO

SELECT					*
FROM					[dbo].[RVF_TBL_PSI_REPOSITORIO_STOCK_DIARIO]
WHERE					Plant					IN					('MfgSys', 'CDEE', 'UNFLE', 'MPlace', 'PER2823')
	AND					ClassID					IN					('PTF', 'PTCO', 'REVI', 'SUBA', 'SUCO')
	AND					WareHouseCode			NOT IN				('TERCER')
	AND					PeriodoActual			=					2021
	AND					MesActual				=					8
ORDER BY				1, 2, 3, 4