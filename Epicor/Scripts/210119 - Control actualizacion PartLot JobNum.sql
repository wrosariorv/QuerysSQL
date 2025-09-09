
SET DATEFORMAT DMY


SELECT				CD.Company, CD.ContainerID, CD.PONum, CD.POLine, 
					UD40.ShortChar14								AS LotNum, 
					PH.OrderDate, 
					PD.PartNum 
FROM				[CORPEPIDB].EpicorErp.Erp.ContainerDetail					CD							WITH(NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.PODetail							PD							WITH(NoLock)
	ON				CD.Company				=				PD.Company
	AND				CD.PONum				=				PD.PONum
	AND				CD.POLine				=				PD.POLine
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.POHeader							PH							WITH(NoLock)
	ON				PD.Company				=				PH.Company
	AND				PD.PONum				=				PH.PONum
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Part					P			WITH(NoLock)
	ON				PD.Company					=				P.Company
	AND				PD.PartNum					=				P.PartNum 
LEFT OUTER JOIN		(
					SELECT				Company, Key1, Key2, Key3, Key4, Key5, ShortChar08, ShortChar14 
					FROM				[CORPEPIDB].EpicorErp.Ice.UD40										WITH(NoLock)
					WHERE				Key1					=				'ComercioExterior4038'
					)				UD40
	ON				CD.Company													=				UD40.Company
	AND				LTRIM(RTRIM(CAST(CD.ContainerID AS VARCHAR(15))))			=				UD40.Key2

WHERE				P.TrackLots					=				1
	AND				PH.OrderDate				>=				'01/01/2019'

	AND NOT EXISTS	(
					SELECT				*
					FROM				[CORPEPIDB].EpicorErp.Erp.PartLot							WITH(NoLock)
					WHERE				PartLot.Company				=			PD.Company
						AND				PartLot.PartNum 			=			PD.PartNum
						AND				PartLot.LotNum  			=			UD40.ShortChar14
					)

ORDER BY			CD.Company, CD.ContainerID, CD.PONum, CD.POLine 

------------------------------------------------------------------------------------------------

