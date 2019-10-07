USE WideWorldImporters
GO
----------------------------------------------
--Para crear un esquema:
----------------------------------------------
DROP  SCHEMA IF EXISTS demo
GO
CREATE SCHEMA demo AUTHORIZATION DBO
GO
DROP  TABLE IF EXISTS dbo.DemoEsquema
GO
CREATE TABLE dbo.DemoEsquema(id int);

--Para mover un objeto de un esquema a otro:
ALTER SCHEMA demo TRANSFER dbo.DemoEsquema;
GO
DROP  SCHEMA IF EXISTS demo
GO
DROP  TABLE IF EXISTS dbo.DemoEsquema
GO


