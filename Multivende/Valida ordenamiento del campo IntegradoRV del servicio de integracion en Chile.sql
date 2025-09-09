SELECT				PO.Company, PO.Key1, 
					MAX(UD_2.Key2)					AS		Key2,  
					PO.Key3, PO.Key4  
FROM				(
					SELECT				CAN.Company, CAN.Key1, CAN.Key3, CAN.Number05, 
										MAX(UD_1.Key4)					AS		Key4 
					FROM				(
										SELECT				Company, Key1, Key3, Number05  
										FROM				[EpicorLive11100].Ice.UD10										UD			WITH (NoLock)
										WHERE				UD.Company					=				'CL01'
											AND				Number05				in				(6207,6216,6390)
											AND				ShortChar17				<>				'ERR'
										GROUP BY			Company, Key1, Key3, Number05
										)		CAN
					INNER JOIN			[EpicorLive11100].Ice.UD10										UD_1			WITH (NoLock)
						ON				CAN.Company				=			UD_1.Company
						AND				CAN.Key1				=			UD_1.Key1
						AND				CAN.Key3				=			UD_1.Key3
						AND				CAN.Number05			=			UD_1.Number05
					GROUP BY			CAN.Company, CAN.Key1, CAN.Key3, CAN.Number05
					)		PO
INNER JOIN			[EpicorLive11100].Ice.UD10										UD_2			WITH (NoLock)
	ON				PO.Company				=			UD_2.Company
	AND				PO.Key1					=			UD_2.Key1
	AND				PO.Key3					=			UD_2.Key3
	AND				PO.Key4					=			UD_2.Key4
	AND				PO.Number05				=			UD_2.Number05
GROUP BY			PO.Company, PO.Key1, PO.Key3, PO.Key4, PO.Number05

SELECT				Company, Key1, Key3, Number05  
FROM				[EpicorLive11100].Ice.UD10										UD			WITH (NoLock)
WHERE				UD.Company					=				'CL01'
	AND				Number05				in				(6207,6216,6390)
	AND				ShortChar17				<>				'ERR'
GROUP BY			Company, Key1, Key3, Number05


SELECT				Company, Key1, Key3, Number05,Key4,ShortChar17,CheckBox03  
FROM				[EpicorLive11100].Ice.UD10										UD			WITH (NoLock)
WHERE				UD.Company					=				'CL01'
	AND				Number05				in				(6207,6216,6390)
	AND				ShortChar17				<>				'ERR'
Order by			Company, Key1, Number05
