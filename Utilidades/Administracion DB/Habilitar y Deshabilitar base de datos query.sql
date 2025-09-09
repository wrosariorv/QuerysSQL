USE master; 


ALTER DATABASE SIP
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

ALTER DATABASE SIP
SET OFFLINE;

ALTER DATABASE SIP
SET MULTI_USER;

ALTER DATABASE SIP
SET ONLINE;

ALTER DATABASE WS
SET MULTI_USER;

ALTER DATABASE WS
SET ONLINE;


USE master; -- Asegúrate de estar en el contexto de la base de datos "master"

-- Pon la base de datos en modo de usuario único para forzar el cierre de conexiones
ALTER DATABASE TuBaseDeDatos
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- Deshabilita la base de datos (reemplaza "TuBaseDeDatos" con el nombre de tu base de datos)
ALTER DATABASE TuBaseDeDatos
SET OFFLINE;

-- Restaura el modo de usuario múltiple para la base de datos
ALTER DATABASE TuBaseDeDatos
SET MULTI_USER;


SELECT state_desc FROM sys.databases WHERE name = 'SIP'