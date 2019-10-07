--Consultamos si CDC está habilitado para las diferentes bases de datos
USE master 
GO 
SELECT [name], database_id, is_cdc_enabled  
FROM sys.databases       
GO
-------------------------------------------------------------------------------------
--Activamos CDC para nuestra BD
--Nos lanzará error por tener tablas memory-Optimized 
USE WideWorldImporters 
GO 
EXEC sys.sp_cdc_enable_db 
GO 

--Consultamos las tablas memory-Optimized 
SELECT * 
FROM sys.tables 
WHERE is_memory_optimized = 1
