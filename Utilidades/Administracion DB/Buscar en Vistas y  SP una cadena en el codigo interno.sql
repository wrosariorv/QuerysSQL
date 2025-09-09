SELECT name, type_desc
FROM sys.objects
WHERE type IN ('P') -- P for Stored Procedures, V for Views
AND OBJECT_DEFINITION(object_id) LIKE '%FechaDesde%'
ORDER BY type_desc, name;
