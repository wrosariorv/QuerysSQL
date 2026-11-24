SELECT *  FROM [PCDB].RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where Estado='Pendiente'

Select 
		Distinct 
		W.TranNum 
From (
			SELECT
					D.*,
					CASE
						WHEN COUNT(*) OVER
							 (
								PARTITION BY D.Company, D.TranNum
							 ) > 1
						THEN 1
						ELSE 0
					END AS TieneMasDeUnaLinea
			FROM	[PCDB].RV.RV_TBL_SIP_DETALLE_COMPROBANTE D
	) AS W

where W.TieneMasDeUnaLinea<>0
ORDER BY
		W. Fecha desc,
		W.Company,
		W.TranNum,
		W.Linea
		
Select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where TranNum in (

					Select 
							Distinct 
							W.TranNum 
					From (
								SELECT
										D.*,
										CASE
											WHEN COUNT(*) OVER
												 (
													PARTITION BY D.Company, D.TranNum
												 ) > 1
											THEN 1
											ELSE 0
										END AS TieneMasDeUnaLinea
								FROM	[PCDB].RV.RV_TBL_SIP_DETALLE_COMPROBANTE D
				) AS W

where W.TieneMasDeUnaLinea<>0
)

order by Fecha desc

select * from [PCDB].RV.RV_TBL_SIP_DETALLE_COMPROBANTE

Where TranNum =4861

select * from RV.RV_TBL_SIP_LOG_PC
where TranNum in (4861)
order by Fecha desc

select * from [PCDB].RV.RV_TBL_SIP_DETALLE_COMPROBANTE

Where TranNum =5571

select * from RV.RV_TBL_SIP_LOG_PC
where TranNum in (5571)
order by Fecha desc

