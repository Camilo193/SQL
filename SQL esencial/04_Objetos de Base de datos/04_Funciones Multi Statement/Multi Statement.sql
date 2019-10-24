--------------------------------------------------------------------------------------
--Usamos el master
USE master;
GO

--------------------------------------------------------------------------------------
--Creamos un nuevo Login para hacer pruebas
CREATE LOGIN TestContext 
  WITH PASSWORD = 'P@ssw0rd',
       CHECK_POLICY = OFF;
GO
--------------------------------------------------------------------------------------
--Importamos la base de datos
USE WideWorldImporters
GO
--------------------------------------------------------------------------------------
--Creamos un login para la base de datos
CREATE USER TestContext FOR LOGIN TestContext;
GO
--------------------------------------------------------------------------------------
--Creamos una función Multi Statement
--Esta función creara un rango de fechas
CREATE FUNCTION dbo.GetDateRange (@StartDate date, @NumberOfDays int)
RETURNS @DateList TABLE
(Position int, DateValue date)
AS BEGIN
	DECLARE @Counter int = 0;
	WHILE (@Counter < @NumberofDays) BEGIN
		INSERT INTO @DateList
		VALUES (@Counter + 1, DATEADD (day, @Counter, @StartDate));
	SET @Counter += 1;
END;
RETURN;
END;
GO
--------------------------------------------------------------------------------------
--Llamamos la función con una fecha de inicio y con el número de días para el rango
SELECT* FROM dbo.GetDateRange('2010-12-31', 5);
--------------------------------------------------------------------------------------
--Creamos otra función Multi statement
CREATE FUNCTION dbo.CheckContext()
RETURNS @UserTokenList TABLE (principal_id int, 
                              sid varbinary(85), 
                              type nvarchar(128), 
                              usage nvarchar(128),
                              name nvarchar(128))
WITH EXECUTE AS 'TestContext'
AS BEGIN
  INSERT @UserTokenList 
    SELECT principal_id,
           sid,
           type,
           usage,
           name 
    FROM sys.user_token;
  RETURN 
END;
GO
--------------------------------------------------------------------------------------
--Se devolverá una lista de tokens de usuario.
SELECT * FROM dbo.CheckContext();
GO

--------------------------------------------------------------------------------------
--Hacemos limpieza
DROP FUNCTION dbo.GetDateRange
DROP FUNCTION dbo.CheckContext;
GO
