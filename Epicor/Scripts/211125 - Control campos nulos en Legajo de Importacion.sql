

---------------------------------------------------------------------

DECLARE				@LegajoControl	INT = 20263, 
					@LegajoError	INT = 20268    

/************************************
ENCABEZADO DE LEGAJO DE IMPORTACION
************************************/
SELECT				Company, ContainerID, Shipped, ContainerClass, ContainerReference
FROM				[CORPEPIDB].EpicorErp.Erp.ContainerHeader							WITH (NoLock)
WHERE				ContainerID				IN				(@LegajoControl, @LegajoError)


/************************************
Datos UD que habilitan las solapas adicionales
************************************/

SELECT				Company, Key1, Key2, Key3, Key4, Key5
FROM				[CORPEPIDB].EpicorErp.Ice.UD40										WITH (NoLock)
WHERE				Key1					IN				(
															'ComercioExterior401', 'ComercioExterior4038', 'ComercioExterior4039'
															)
AND					LTRIM(RTRIM(Key2))		IN				(
															CAST(@LegajoControl AS VARCHAR(15)), 
															CAST(@LegajoError AS VARCHAR(15))
															)
ORDER BY			Company, Key2, Key1

---------------------------------------------------------------------  


/*****************************************************************************************

INSERT INTO		[CORPEPIDB].EpicorErp.Ice.UD40	(Company, Key1, Key2)
VALUES											('CO02', 'ComercioExterior4039', '20239')

*****************************************************************************************/

/*****************************************************************************************

SELECT				Company, ContainerID, Shipped, ContainerClass, ContainerReference
FROM				[CORPEPIDB].EpicorErp.Erp.ContainerHeader				CH				WITH (NoLock)
WHERE				NOT EXISTS					(
												SELECT				*
												FROM				[CORPEPIDB].EpicorErp.Ice.UD40				UD				WITH (NoLock)
												WHERE				UD.Key1				=				'ComercioExterior401'
													AND				UD.Company			=				CH.Company
													AND				UD.Key2				=				CH.ContainerID
												)
ORDER BY			Company, ContainerID 

SELECT				Company, ContainerID, Shipped, ContainerClass, ContainerReference
FROM				[CORPEPIDB].EpicorErp.Erp.ContainerHeader				CH				WITH (NoLock)
WHERE				NOT EXISTS					(
												SELECT				*
												FROM				[CORPEPIDB].EpicorErp.Ice.UD40				UD				WITH (NoLock)
												WHERE				UD.Key1				=				'ComercioExterior4038'
													AND				UD.Company			=				CH.Company
													AND				UD.Key2				=				CH.ContainerID
												)
ORDER BY			Company, ContainerID

SELECT				Company, ContainerID, Shipped, ContainerClass, ContainerReference
FROM				[CORPEPIDB].EpicorErp.Erp.ContainerHeader				CH				WITH (NoLock)
WHERE				NOT EXISTS					(
												SELECT				*
												FROM				[CORPEPIDB].EpicorErp.Ice.UD40				UD				WITH (NoLock)
												WHERE				UD.Key1				=				'ComercioExterior4039'
													AND				UD.Company			=				CH.Company
													AND				UD.Key2				=				CH.ContainerID
												)
ORDER BY			Company, ContainerID

*****************************************************************************************/
