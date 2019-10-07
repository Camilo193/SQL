--TRIGGER con EVENTDATA cuando se cree una base de datos en el servidor
USE master ;  
GO  
CREATE TRIGGER ddl_trig_database   
ON ALL SERVER   
FOR CREATE_DATABASE   
AS   
    PRINT 'Database Created.'  
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')  
GO  
----------------------------------------------------------------------------------------------
--Creamos una nueva base de datos
CREATE DATABASE Sales  
GO
----------------------------------------------------------------------------------------------
--Eliminamos el Trigger en todo el servidor
DROP TRIGGER ddl_trig_database  
ON ALL SERVER;  
GO 
----------------------------------------------------------------------------------------------
--Eliminamos la tabla de ventas
DROP DATABASE Sales
----------------------------------------------------------------------------------------------
-- logon rechaza un intento de iniciar sesión en SQL Server como miembro del inicio de sesión 
--login_test si ya hay tres sesiones de usuario ejecutándose con ese inicio de sesión.
CREATE LOGIN login_test WITH PASSWORD = '3KHJ6dhx(0xVYsdf' MUST_CHANGE,  
    CHECK_EXPIRATION = ON;  
GO 
------------------
GRANT VIEW SERVER STATE TO login_test;  
GO  
CREATE TRIGGER connection_limit_trigger  
ON ALL SERVER WITH EXECUTE AS 'login_test'  
FOR LOGON  
AS  
BEGIN  
IF ORIGINAL_LOGIN()= 'login_test' AND  
    (SELECT COUNT(*) FROM sys.dm_exec_sessions  
            WHERE is_user_process = 1 AND  
                original_login_name = 'login_test') > 3  
    ROLLBACK;  
END;  
----------------------------------------------------------------------------------------------
--Limpiamos
DROP TRIGGER connection_limit_trigger ON ALL SERVER
DROP LOGIN login_test
----------------------------------------------------------------------------------------------
CREATE TRIGGER safety   
ON DATABASE   
FOR DROP_SYNONYM  
AS   
IF (@@ROWCOUNT = 0)
RETURN;
   RAISERROR ('You must disable Trigger "safety" to remove synonyms!', 10, 1)  
   ROLLBACK  
GO 
----------------------------------------------------------------------------------------------
--Seleccionamos los eventos que activan el desencadenador safety
SELECT TE.*  
FROM sys.trigger_events AS TE  
JOIN sys.triggers AS T ON T.object_id = TE.object_id  
WHERE T.parent_class = 0 AND T.name = 'safety';  
GO  
----------------------------------------------------------------------------------------------
--Limpiamos
DROP TRIGGER safety  
ON DATABASE;  
GO  

