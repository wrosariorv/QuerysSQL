SELECT		
			*
FROM		[PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas]
WHERE		OT='RV672001'


select * from RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P
where OT='RV672001'
AND		TranNum in (49692,49694)

select * from RV_TBL_SIP_ITEM_TP
where
	TranNum in (49692,49694)

select * from RV_TBL_SIP_ITEM_TP A
where
	TranNum in (49692)
	AND	NOT EXISTS (SELECT 1 from RV_TBL_SIP_ITEM_TP b where 	TranNum in (49694) and A.Company= b.Company AND a.PartNum = B.PartNum AND A.Serie= B.Serie)

select * from RV_TBL_SIP_ITEM_TP
WHERE OT='RV672001'
AND TranNum in (49650,
49651
)
order by Fecha desc

select * from RV_TBL_SIP_ITEM_TP
WHERE OT='RV672001'
AND Serie in (
SELECT 
    
    Serie
FROM 
    RV_TBL_SIP_ITEM_TP
WHERE 
    OT = 'RV672001'
GROUP BY 
     Company,OT,PartNum,Serie
HAVING 
    COUNT(*) > 1
)

select * from RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P
where OT='RV672001'
order BY Fecha DESC


select SUM(Transferir) from RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P
where OT='RV672001'
AND		TranNum in (49692,49694)

SELECT 
    Company,
    OT,
    PartNum,
    Serie,
    COUNT(*) AS NumeroDeRepeticiones
FROM 
    RV_TBL_SIP_ITEM_TP
WHERE 
    OT = 'RV672001'
GROUP BY 
     Company,OT,PartNum,Serie
HAVING 
    COUNT(*) > 1
ORDER BY Serie;
