-- Deshabilitar la comprobación de integridad referencial y eliminar todas las claves foráneas
DECLARE @ConstraintName NVARCHAR(128)
DECLARE @TableName NVARCHAR(128)
DECLARE @sql NVARCHAR(MAX)

-- Eliminar las FK (claves foráneas)
DECLARE cursor_fks CURSOR FOR
SELECT fk.name AS FKName, t.name AS TableName
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id

OPEN cursor_fks
FETCH NEXT FROM cursor_fks INTO @ConstraintName, @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'ALTER TABLE [' + @TableName + '] DROP CONSTRAINT [' + @ConstraintName + ']'
    EXEC sp_executesql @sql
    FETCH NEXT FROM cursor_fks INTO @ConstraintName, @TableName
END

CLOSE cursor_fks
DEALLOCATE cursor_fks

-- Eliminar todas las tablas
DECLARE @Table NVARCHAR(128)
DECLARE cursor_tables CURSOR FOR
SELECT name FROM sys.tables

OPEN cursor_tables
FETCH NEXT FROM cursor_tables INTO @Table

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'DROP TABLE [' + @Table + ']'
    EXEC sp_executesql @sql
    FETCH NEXT FROM cursor_tables INTO @Table
END

CLOSE cursor_tables
DEALLOCATE cursor_tables

-- Eliminar todas las vistas
DECLARE @View NVARCHAR(128)
DECLARE cursor_views CURSOR FOR
SELECT name FROM sys.views

OPEN cursor_views
FETCH NEXT FROM cursor_views INTO @View

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'DROP VIEW [' + @View + ']'
    EXEC sp_executesql @sql
    FETCH NEXT FROM cursor_views INTO @View
END

CLOSE cursor_views
DEALLOCATE cursor_views

-- Eliminar todos los procedimientos almacenados (Stored Procedures)
DECLARE @Proc NVARCHAR(128)
DECLARE cursor_procs CURSOR FOR
SELECT name FROM sys.procedures

OPEN cursor_procs
FETCH NEXT FROM cursor_procs INTO @Proc

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'DROP PROCEDURE [' + @Proc + ']'
    EXEC sp_executesql @sql
    FETCH NEXT FROM cursor_procs INTO @Proc
END

CLOSE cursor_procs
DEALLOCATE cursor_procs
