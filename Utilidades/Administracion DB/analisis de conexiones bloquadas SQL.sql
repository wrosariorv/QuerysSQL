USE [master]
GO
SELECT  session_id,
blocking_session_id,
wait_time,
wait_type,
last_wait_type,
wait_resource,
lock_timeout
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0
GO
--Muestra la sesión que esta generando el bloqueo.

SELECT * FROM sys.dm_exec_requests WHERE blocking_session_id <> 0;
GO
--El siguiente comando nos muestra las sesiones bloqueadas
SELECT session_id ,status ,blocking_session_id,
wait_type ,wait_time ,wait_resource ,transaction_id 
FROM sys.dm_exec_requests WHERE status = N'suspended';
GO
--Esta vista dinámica muestra las tareas que están esperando por algún recurso.
SELECT session_id, wait_duration_ms, wait_type, blocking_session_id 
FROM sys.dm_os_waiting_tasks WHERE blocking_session_id <> 0
GO
--Eliminar procesos
kill 62

---Borra automaticamente
SELECT  * FROM master.dbo.sysprocesses 
WHERE blocked <> 0 AND spid <> @@spid

DECLARE @spid int

SELECT @spid = MIN(spid) FROM master.dbo.sysprocesses 
WHERE blocked <> 0 AND spid <> @@spid

WHILE @spid IS NOT NULL
BEGIN
    BEGIN TRY
        EXECUTE('KILL ' + @spid)
    END TRY
    BEGIN CATCH
        -- manejar el error "Only user processes can be killed" aquí
        PRINT 'No se puede matar SPID ' + CAST(@spid AS varchar(10)) + ': ' + ERROR_MESSAGE()
    END CATCH
    SELECT @spid = MIN(spid) FROM master.dbo.sysprocesses 
    WHERE blocked <> 0 AND spid <> @@spid
END


sp_whoisactive