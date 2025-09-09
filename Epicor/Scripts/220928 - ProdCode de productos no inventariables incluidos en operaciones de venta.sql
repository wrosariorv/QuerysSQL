
/************************************************************************************

ProdCode de productos no inventariables facturados. 
Se controla si forman parte de la UD que los excluye del analisis de las ventas

************************************************************************************/

SELECT			ID.Company, ID.InvoiceNum, ID.InvoiceLine, ID.PartNum, ID.LineDesc, ID.ProdCode, 
				P.ProdCode,
				UD.CodeTypeID, UD.CodeID, UD.IsActive, UD.CodeDesc
FROM			[CORPEPIDB].EpicorErp.Erp.InvcDtl			ID				WITH(NoLock)
INNER JOIN		(
				SELECT			Company, PartNum, SearchWord, PartDescription, ClassID, ProdCode	
				FROM			[CORPEPIDB].EpicorErp.Erp.Part				WITH(NoLock)
				WHERE			NonStock				=					1
				)			P
	ON			ID.Company				=				P.Company
	AND			ID.PartNum				=				P.PartNum 
LEFT OUTER JOIN	(
				SELECT			Company, CodeTypeID, CodeID, IsActive, CodeDesc 
				FROM			[CORPEPIDB].EpicorErp.Ice.UDCodes			WITH(NoLock)
				WHERE			CodeTypeID				=					'ProdGrpVar'
				)			UD
	ON			P.Company				=					UD.Company
	AND			P.ProdCode				=					UD.CodeID
LEFT OUTER JOIN	(
				SELECT			Company, CodeTypeID, CodeID, IsActive, CodeDesc 
				FROM			[CORPEPIDB].EpicorErp.Ice.UDCodes			WITH(NoLock)
				WHERE			CodeTypeID				=					'ProdGrpVar'
				)			UD2
	ON			ID.Company				=					UD2.Company
	AND			ID.ProdCode				=					UD2.CodeID
WHERE			(
				UD.CodeTypeID			IS NULL
				AND
				ID.ProdCode				<>					''
				AND			
				ID.ProdCode				NOT LIKE			'%ZZDIF%'
				AND
				P.ProdCode				NOT LIKE			'%ZZDIF%'
				)


