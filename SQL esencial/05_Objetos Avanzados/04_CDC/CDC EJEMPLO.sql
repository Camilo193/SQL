--Creamos una nueva base de datos para hacer las pruebas CDC
USE MASTER
GO
CREATE DATABASE TestCDC
GO
--Para esta prueba es importante activar el SQL Server AGENT (MSSQLServer)
-------------------------------------------------------------------------------------------
--Importamos la base de datos
USE TestCDC
GO
-------------------------------------------------------------------------------------------
-- Activamos
EXECUTE sys.sp_cdc_enable_db
GO
-------------------------------------------------------------------------------------------
--Verificamos que este activada la funcion cdc
SELECT is_cdc_enabled, * 
FROM sys.databases 
WHERE name='TestCDC'
--is_cdc_enabled = 1 significa que cdc está activo
-------------------------------------------------------------------------------------------
--Creamos la tabla empleado para hacer pruebas
CREATE TABLE dbo.Employee (
EmployeeID INT IDENTITY PRIMARY KEY,
FirstName VARCHAR(100),
LastName VARCHAR(100),
Position VARCHAR(100),
PayScale DECIMAL
)
GO
-------------------------------------------------------------------------------------------
--Insertamos algunos valores
INSERT INTO dbo.Employee(FirstName, LastName, Position, PayScale)
VALUES
('User1', 'Test1', 'Software Engineer', 150000),
('User2', 'Test2', 'Quality Assuarance Engineer', 120000),
('USer3', 'Test3', 'Business Analyst', 250000),
('USer4', 'Test4', 'Systems Engineer', 150000),
('USer5', 'Test5', 'Project Manager', 200000)
GO
-------------------------------------------------------------------------------------------
--Activamos el cdc para las tablas relevantes para ver los cambios
--Nota: Debe de estar activado el SQL Server Agent
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo', --Nombre del esquema de la tabla
@source_name   = N'Employee', --Nombre de la tabla
@role_name     = N'UserRole', --Rol de base de datos utilizado para acceder a los datos modificados.
@supports_net_changes = 1 --Esto es compatible para consultar cambios netos. Esto significa 
--que todos los cambios que suceden en un registro se resumirán en forma de cambio neto
GO
-------------------------------------------------------------------------------------------
--Insertamos un dato en la tabla
INSERT INTO dbo.Employee(FirstName, LastName, Position, PayScale)
VALUES('user6', 'Test6', 'Senior Software Engineer', 235000)
GO
-------------------------------------------------------------------------------------------
--Eliminamos un dato en la tabla
DELETE FROM dbo.Employee
WHERE EmployeeID = 2
GO
-------------------------------------------------------------------------------------------
--Actualizamos un dato en la tabla
UPDATE dbo.Employee
SET PayScale = 275000, FirstName = 'MUser3'
WHERE EmployeeID = 3
GO
-------------------------------------------------------------------------------------------
--Actualizamos un dato en la tabla
UPDATE dbo.Employee
SET PayScale = 300000
WHERE EmployeeID = 3
GO
-------------------------------------------------------------------------------------------
--Veamos el conjunto de resultados de cambios 
--Operation: 1 = delete, 2 = insert, 3 = value before update and 4 = value after update
SELECT * FROM cdc.dbo_Employee_CT
--Veamos la tabla original
SELECT * FROM dbo.Employee
-------------------------------------------------------------------------------------------

--En nuestro ejemplo, hemos realizado actualizaciones de EmployeeID = 3. 
--Veamos todos los cambios utilizando la función "cdc.fn_cdc_get_all_changes".
DECLARE @MinimumLSN binary(10), @MaximumLSN binary(10)
SET @MinimumLSN = sys.fn_cdc_get_min_lsn('dbo_Employee')
SET @MaximumLSN = sys.fn_cdc_get_max_lsn()
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Employee (@MinimumLSN, @MaximumLSN, N'all');
GO
-------------------------------------------------------------------------------------------
--Tenemos 4 filas diferentes para cada operación DML realizada. 
--Devuelve dos filas para la actualización de EmployeeID = 3.
--Ahora ejecutemos la función "cdc.fn_cdc_get_net_changes".
DECLARE @MinimumLSN binary(10), @MaximumLSN binary(10)
SET @MinimumLSN = sys.fn_cdc_get_min_lsn('dbo_Employee')
SET @MaximumLSN = sys.fn_cdc_get_max_lsn()
SELECT * FROM cdc.fn_cdc_get_net_changes_dbo_Employee (@MinimumLSN, @MaximumLSN, N'all');
GO
-------------------------------------------------------------------------------------------
--Limpiamos
USE TestCDC
EXECUTE sys.sp_cdc_disable_db
-------------------------------------------------------------------------------------------
--Eliminamos la base de datos
USE MASTER
GO
DROP DATABASE TestCDC
GO
-------------------------------------------------------------------------------------------

