SELECT DISTINCT o.name AS ObjectName, o.type_desc AS ObjectType, m.definition
FROM sys.sql_modules m
INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE m.definition LIKE '%CORPL11-SSRS%';