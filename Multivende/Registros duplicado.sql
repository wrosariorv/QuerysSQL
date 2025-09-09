--Busca todos los registros duplicados
select			
				A.ID,
				A.CanalEntrada,
				A.NumeroOC,
				A.NumeroDocumento,
				A.Linea 
from			[CORPSQLMULT01].[Multivende].[dbo].RVF_TBL_API_VENTAS_WEB A WITH (NoLock)
RIGHT JOIN		(

					SELECT					
											B.CanalEntrada,
											B.NumeroOC,
											B.NumeroDocumento,
											B.Linea

					FROM					[CORPSQLMULT01].[Multivende].[dbo].RVF_TBL_API_VENTAS_WEB B WITH (NoLock)
					GROUP BY				CanalEntrada,NumeroOC,NumeroDocumento,	Linea	
					HAVING COUNT(*)>1
				)		 DU
ON				A.CanalEntrada			=		DU.CanalEntrada
AND				A.NumeroOC				=		DU.NumeroOC
AND				A.NumeroDocumento		=		DU.NumeroDocumento
AND				A.Linea					=		DU.Linea
	
Order BY		A.ID ASC

--Exluye los registro duplicado

 WITH C AS
 (
  SELECT	 ID,
			 CanalEntrada,
			 NumeroOC,
			 NumeroDocumento,
			 Linea, 

  ROW_NUMBER() OVER (PARTITION BY 
                    CanalEntrada,
					NumeroOC,
					NumeroDocumento,
					Linea 
                    ORDER BY ID) AS DUPLICADO
  FROM [CORPSQLMULT01].[Multivende].[dbo].RVF_TBL_API_VENTAS_WEB B WITH (NoLock) 
 )
 SELECT * FROM C 
 WHERE DUPLICADO > 1