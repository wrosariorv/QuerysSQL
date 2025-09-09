use RVF_Local

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;


CREATE TABLE PDF_BinarioStorage (
    Id INT IDENTITY PRIMARY KEY,
    Nombre NVARCHAR(255),
    Contenido VARBINARY(MAX),
    FechaCarga DATETIME DEFAULT GETDATE()
);


DECLARE @Binario VARBINARY(MAX);
--SELECT @Binario = BulkColumn
--FROM OPENROWSET(BULK N'\\Corpe11-ssrs\caea\Archivos\Diseno Web con HTML5 y CSS3 G Sanchez Cano.pdf', SINGLE_BLOB) AS Archivo;

SELECT @Binario = BulkColumn
FROM OPENROWSET(BULK N'\\Corpe11-ssrs\caea\Archivos\UC-Microservicios con ASP.NETCore.pdf', SINGLE_BLOB) AS Archivo;


DECLARE @NombreArchivo NVARCHAR(255) = 'UC-Microservicios con ASP.NETCore.pdf';
DECLARE @Binario VARBINARY(MAX);

-- Leer PDF directamente con ruta literal
SELECT @Binario = BulkColumn
FROM OPENROWSET(BULK N'\\Corpe11-ssrs\caea\Archivos\UC-Microservicios con ASP.NETCore.pdf', SINGLE_BLOB) AS Archivo;

-- Insertar (ejemplo)
INSERT INTO PDF_BinarioStorage (Nombre, Contenido)
VALUES (@NombreArchivo, @Binario);


-- Exportar a archivo (esto se hace desde C#, PowerShell, o herramientas como SSIS)
SELECT *
FROM PDF_BinarioStorage
WHERE Id = 2;

--select LEN(Contenido) from PDF_BinarioStorage

DECLARE @bin VARBINARY(MAX);

-- Obtener el binario del PDF
SELECT @bin = Contenido
FROM PDF_BinarioStorage
WHERE Id = 1;

-- Convertir a Base64
SELECT
    CAST('' AS XML).value('xs:base64Binary(sql:variable("@bin"))', 'NVARCHAR(MAX)') AS Base64Contenido
	--,LEN(CAST('' AS XML).value('xs:base64Binary(sql:variable("@bin"))', 'NVARCHAR(MAX)')) AS Cantidad

