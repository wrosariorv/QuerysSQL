

SELECT					UD.Company, UD.Key1, UD.Key2, UD.Key3, UD.Key4, UD.Key5, UD.ChildKey1, UD.ChildKey2, 
						CAST(UD.Number01 AS INT)					AS				NumeroOrden,
						CAST(UD.Number02 AS INT)					AS				NumeroLinea,
						CAST(UD.Number03 AS INT)					AS				NumeroRelease, 
						UD.ShortChar06								AS				PartNum, 
						CAST(UD.Number04 AS INT)					AS				Cantidad, 
						CAST(UD.Number06 AS INT)					AS				NumeroInternoRemito, 
						UD.ShortChar07								AS				NumeroLegalRemito, 
						CAST(UD.Number08 AS INT)					AS				NumeroInternoFactura, 
						UD.ShortChar09								AS				NumeroLegalFactura, 
						P.TrackSerialNum, 
						P.SNPrefix, 
						P.ProdCode

FROM					[CORPEPIDB].EpicorErp.Ice.UD110A					UD
INNER JOIN				[CORPEPIDB].EpicorErp.Erp.Part						P
	ON					UD.Company			=					P.Company
	AND					UD.ShortChar06		=					P.PartNum 
WHERE		
						(
						UD.Key3				LIKE				'%34015'			-- Ok
		OR				UD.Key3				LIKE				'%34016'			-- Ok
		OR				UD.Key3				LIKE				'%34017'			-- Ok
		OR				UD.Key3				LIKE				'%34018'			-- Ok
		OR				UD.Key3				LIKE				'%34018'			-- Ok
		OR				UD.Key3				LIKE				'%34043'			-- Ok
		OR				UD.Key3				LIKE				'%33909'			-- Ok
		OR				UD.Key3				LIKE				'%34023'			-- Ok
		OR				UD.Key3				LIKE				'%34024'			-- Ok
		OR				UD.Key3				LIKE				'%34025'			-- Ok
		OR				UD.Key3				LIKE				'%34026'			-- Ok 
		OR				UD.Key3				LIKE				'%34027'			-- Ok
		OR				UD.Key3				LIKE				'%34028'			-- Ok
		OR				UD.Key3				LIKE				'%34029'			-- Ok
		OR				UD.Key3				LIKE				'%34030'			-- Ok
		OR				UD.Key3				LIKE				'%34031'			-- Ok
		OR				UD.Key3				LIKE				'%34032'			-- Ok
		OR				UD.Key3				LIKE				'%34033'			-- Ok
		OR				UD.Key3				LIKE				'%34034'			-- Ok
		OR				UD.Key3				LIKE				'%34035'			-- Ok
		OR				UD.Key3				LIKE				'%34036'			-- Ok
		OR				UD.Key3				LIKE				'%34020'			-- Ok
		OR				UD.Key3				LIKE				'%34041'			-- Ok 
		OR				UD.Key3				LIKE				'%34042'			-- Ok

						)
		AND				UD.Number06			=					0
		AND				P.ProdCode			NOT IN				('TAB', 'CEL')

ORDER BY				1, 2, 3, 4, 5, 6, 7, 8


