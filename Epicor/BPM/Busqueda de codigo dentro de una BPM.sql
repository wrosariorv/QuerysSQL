/********************************************************
Ejecutar conectado directamente a la BD del 10.1.0.170
********************************************************/
--------------------------------------------------------
-- DirectiveType 0 => Directiva de datos
-- DirectiveType 1 => Directiva de metodo. Preprocesamiento
-- DirectiveType 3 => Directiva de metodo. Postprocesamiento
--------------------------------------------------------

SELECT [Source], BpMethodCode, DirectiveType, [Name], DirectiveGroup, IsEnabled
FROM [CORPEPIDB].EpicorErp.Ice.BpDirective
WHERE CAST(Body as nvarchar(max)) LIKE '%Ingrese una CUIT valida. Controle el digito verificador%'  
--AND IsEnabled = 1


ORDER BY BpMethodCode

/********************************************************
Ejecutar conectado directamente a la BD del 10.1.0.170
********************************************************/
--------------------------------------------------------
-- DirectiveType 0 => Directiva de datos
-- DirectiveType 1 => Directiva de metodo. Preprocesamiento
-- DirectiveType 3 => Directiva de metodo. Postprocesamiento
--------------------------------------------------------

SELECT [Source], BpMethodCode, DirectiveType, [Name], DirectiveGroup, IsEnabled
FROM [CORPEPIDB].EpicorErp.Ice.BpDirective
WHERE CAST(Body as nvarchar(max)) LIKE '%El CUIT del CLIente no es un CUIT valido%'  
--AND IsEnabled = 1


ORDER BY BpMethodCode