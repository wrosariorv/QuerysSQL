-----------------------
--SP Integracion
-----------------------
--exec RVF_PRC_INSERTA_REMITOS_NO_CONFORMADOS

----------------------------------------------
--Tabla de pendientes para integrar
----------------------------------------------
Select * from RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS

----------------------------------------------------------------------------------------------------------------
--Borra remitos de la tabla de pendientes para integrar remitos sin confimra, sin fecha de confrome
----------------------------------------------------------------------------------------------------------------
select * from RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS
Where
FechaConforme is NULL
 Key3 in ('00029456')
 AND ChildKey2 in ('011','012')
 AND NumeroRemito in  ('R-0225-00012953','R-0225-00012943')

/*
Begin tran 
delete RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS
Where
FechaConforme is NULL

commit tran 
*/
--------------------------------------------------------
--Busca remitos  sin confimra en el origen del proveedor
--------------------------------------------------------
Select * from 
					(
						SELECT				NumeroRemito, JobID, FechaConforme, FechaActualizacion,
											CASE
												WHEN	LEN (NumeroRemito) = 15 THEN NumeroRemito
												ELSE	CONCAT('R-',SUBSTRING (CAST (NumeroRemito AS VARCHAR),1,4),'-', SUBSTRING (CAST (NumeroRemito AS VARCHAR),5,8)) 
											END		AS NroRemito
						FROM				[CORPSQLMULT01].RV_Remitos.dbo.SyncEpicor							WITH (NoLock)
					) W
WHERE				
					--FechaActualizacion			BETWEEN			@FechaDesde		AND		@FechaHasta 
					--W.FechaConforme is null
					W.NroRemito in  ('R-0225-00012953','R-0225-00012943')

--------------------------------------------------------
--Busca en tabla de pendientes para integrar remitos sin confimra
--------------------------------------------------------
Select * from 
					(
					SELECT			CASE
															WHEN	LEN (SYE.NumeroRemito) = 15 THEN SYE.NumeroRemito
															ELSE	CONCAT('R-',SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),1,4),'-', SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),5,8)) 
															END		AS NroRemito,	
															SYE.JobID, SYE.FechaConforme, SYE.FechaActualizacion

					FROM			RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS			SYE					WITH(NoLock)
					INNER JOIN		(
									SELECT			NumeroRemito, MAX(FechaActualizacion) AS FechaActualizacion 
									FROM			RVF_TBL_CONTROL_REMITOS_NO_CONFORMADOS				WITH(NoLock)
									GROUP BY		NumeroRemito
									)			M
						ON			SYE.NumeroRemito			=				M.NumeroRemito
						AND			SYE.FechaActualizacion		=				M.FechaActualizacion
					)W

WHERE
W.NroRemito in  ('R-0225-00012953','R-0225-00012943')


----------------------------
--Busca remitos sin confimra
----------------------------
 select				
					
					UDA.Company,
					UDA.Key1, UDA.Key2,
					UDA.Key3,																--AS		NroViaje,
					UDA.Key4, UDA.Key5,
					UDA.ChildKey1,
					UDA.ChildKey2,
					UDA.ChildKey3,
					UDA.ChildKey4,
					UDA.ChildKey5,
					UDA.CheckBox02															--AS		Conforme
					--,A.FechaConforme

from				[CORPEPIDB].EpicorERP.Ice.UD110A			UDA	WITH (NoLock)


INNER JOIN		
(
		select		CASE 
		WHEN LEN (SYE.NumeroRemito)				=			15	THEN SYE.NumeroRemito 
		ELSE
		CONCAT('R-',SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),1,4),'-', SUBSTRING (CAST (SYE.NumeroRemito AS VARCHAR),5,8))
		END AS NroRemito,SYE.FechaConforme 

from 				[CORPSQLMULT01].RV_Remitos.dbo.SyncEpicor		SYE		WITH (NoLock)) AS A

ON					UDA.ShortChar07 			=			A.NroRemito  COLLATE Modern_Spanish_CI_AS 

Where				
					UDA.CheckBox02				=			0					

 --UDA.Key3 in ('00029456')
 --AND UDA.ChildKey2 in ('011','012')

 ORDER BY 1,3,4
