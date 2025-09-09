--GestionaRepositorios

Select			W.GroupID,
				W.Tipo,
				SUM(W.CatidadLicencia) AS TotalLicencias
from			(
					select		GroupID,Tipo,Licencia,COUNT(*) OVER (PARTITION BY Licencia)	AS CatidadLicencia
					from		RV_VW_SIP_LICENCIAS_GENERADAS_PENDIENTE
					where
								Tipo ='Attestation\TCL_RT51M'
				) AS W
Group by  W.GroupID, W.Tipo