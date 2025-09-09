

SELECT				P.Company, P.PartNum, P.SearchWord, P.PartDescription, P.ProdCode, P.ClassID, 
					PU.Character03												AS	EmpFabicante, 
					PU.Character05												AS	EmpComercializadora, 
					ISNULL(GL1.GLControlType, '')								AS	ProdCode_GLControlType, 
					ISNULL(GL1.GLControlCode, '')								AS	ProdCode_GLControlCode

FROM				[CORPEPIDB].EpicorErp.Erp.Part				P				WITH (NoLock) 
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part_UD			PU				WITH (NoLock) 
	ON				P.SysRowID					=				PU.ForeignSysRowID
LEFT OUTER JOIN		(
					SELECT				Company, RelatedToFile, Key1, GLControlType, GLControlCode 
					FROM				[CORPEPIDB].EpicorErp.Erp.EntityGLC							WITH (NoLock) 
					WHERE				RelatedToFile			=				'Part'
						AND				GLControlType			=				'Product Group'
					)		GL1
	ON				P.Company					=				GL1.Company 
	AND				P.PartNum					=				GL1.Key1

WHERE		

-- Productos de venta por cuenta y orden que no tienen asociado un GLControl
					(
					P.ClassID						<>				''
					AND 
					PU.Character03					<>				PU.Character05				-- Empresa fabricante diferente a empresa comercializadora 
					AND
					ISNULL(PU.Character05, '')		<>				''
					AND
					ISNULL(GL1.GLControlType, '')	=				''
					AND
					P.ProdCode						NOT IN			('ZZDIFPR', 'DIFROCYO')
					)

	OR

-- Productos de venta por cuenta y orden que tienes mal la clase de parte
					(
					P.ClassID						<>				''
					AND 
					PU.Character03					<>				PU.Character05				-- Empresa fabricante diferente a empresa comercializadora 
					AND
					ISNULL(PU.Character05, '')		<>				''
					AND
					P.ClassID						NOT IN			('SUCO', 'SKCO', 'PTCO')
					AND
					P.ProdCode						NOT IN			('ZZDIFPR', 'DIFROCYO')
					)

ORDER BY			P.Company, P.PartNum

