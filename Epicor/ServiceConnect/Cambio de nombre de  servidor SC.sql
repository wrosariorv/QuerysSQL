SELECT *
FROM [ESCDB]. [dbo]. [ScaDESServers]



SELECT *
FROM [ESCDB]. [dbo]. [ScaDESPlugInRegs]


DECLARE @SearchValue NVARCHAR(100) = 'CORPP11-CON01';

-- Tabla temporal para guardar los hallazgos
IF OBJECT_ID('tempdb..#FoundResults') IS NOT NULL DROP TABLE #FoundResults;
CREATE TABLE #FoundResults (
    Esquema NVARCHAR(128),
    Tabla NVARCHAR(128),
    Columna NVARCHAR(128),
    RegistrosEncontrados INT
);

DECLARE @Sql NVARCHAR(MAX);
DECLARE @SchemaName NVARCHAR(128);
DECLARE @TableName NVARCHAR(128);
DECLARE @ColumnName NVARCHAR(128);

-- Cursor para recorrer columnas de tipo texto
DECLARE col_cursor CURSOR FOR
SELECT 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'text', 'ntext')
  AND TABLE_SCHEMA NOT IN ('sys', 'information_schema');

OPEN col_cursor;

FETCH NEXT FROM col_cursor INTO @SchemaName, @TableName, @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construimos una consulta que solo inserte si encuentra al menos una coincidencia
    SET @Sql = 'INSERT INTO #FoundResults (Esquema, Tabla, Columna, RegistrosEncontrados) ' +
               'SELECT ''' + @SchemaName + ''', ''' + @TableName + ''', ''' + @ColumnName + ''', COUNT(*) ' +
               'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' ' +
               'WHERE ' + QUOTENAME(@ColumnName) + ' LIKE ''%' + @SearchValue + '%'' ' +
               'HAVING COUNT(*) > 0';

    EXEC sp_executesql @Sql;

    FETCH NEXT FROM col_cursor INTO @SchemaName, @TableName, @ColumnName;
END

CLOSE col_cursor;
DEALLOCATE col_cursor;

-- Resultado final: Lista de tablas y columnas con el valor
SELECT * FROM #FoundResults ORDER BY RegistrosEncontrados DESC;


select * from ScaInstallationProperties

begin tran
UPDATE ScaInstallationProperties
SET         Value='http://CORPE11-CON01'
where
        Value='http://CORPP11-CON01'

        commit tran

begin tran
UPDATE ScaInstallationProperties
SET         Value='http://scshost'
where
        Value='http://CORPE11-CON01'

        commit tran
        http://scshost