--1. Se crea un file group para datos optimizados en memoria 
ALTER DATABASE WideWorldImporters 
	ADD FILEGROUP wwi_memory_data 
		CONTAINS MEMORY_OPTIMIZED_DATA;
GO

ALTER DATABASE WideWorldImporters 
	ADD FILE (NAME = 'WWIMemData', FILENAME = 'D:\Data\WideWorldImp_MemoryData.ndf')
		TO FILEGROUP wwi_memory_data;
GO

--Msg 10797, Level 15, State 2, Line 2
--Only one MEMORY_OPTIMIZED_DATA filegroup is allowed per database.

--2. Se consulta si ya la base de datos posee un filegroup destinado para datos optimizados en memoria 
select * from sys.filegroups where type_desc = 'MEMORY_OPTIMIZED_DATA_FILEGROUP'




--3. Se procede a crear una tabla optimizada en memoria persistente. (los datos seran conservados).
--3.1 En caso de ser necesario se establece el nivel de aislamiento a MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT
ALTER DATABASE WideWorldImporters
    SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON;
GO 

CREATE TABLE dbo.ShoppingCart (   
    ShoppingCartId INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,  
    UserId INT NOT NULL INDEX ix_UserId NONCLUSTERED
        HASH WITH (BUCKET_COUNT=1000000),
    CreatedDate DATETIME2 NOT NULL,   
    TotalPrice MONEY  
    ) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_AND_DATA)   
GO  


--4. Se procede a crear una tabla optimizada en memoria no persistente. (los datos no seran persistentes). Se producen perdidas de datos si el servidor es apagado inesperadamente.
Drop Table If Exists dbo.UserSession
Go

CREATE TABLE dbo.UserSession (   
   SessionId INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
   UserId int NOT NULL,   
   CreatedDate DATETIME2 NOT NULL,  
   ShoppingCartId INT
    )   
    WITH (MEMORY_OPTIMIZED=ON, DURABILITY=SCHEMA_ONLY)
GO  

--5. Se procede a crear una tabla optimizada en memoria con clave primaria compuesta.
CREATE TABLE dbo.ShoppingCartProducts(
	ShoppingCartId INTEGER NOT NULL,
	ProductId INTEGER NOT NULL,
	ProductCode INTEGER NULL,
	Quantity INTEGER NOT NULL
	PRIMARY KEY NONCLUSTERED (ShoppingCartId, ProductId))
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
GO

--6. Se procede a crear una tabla optimizada en memoria con la creacion de un indice hash de clave primaria.
Drop Table If Exists dbo.UserSession
Go

CREATE TABLE dbo.UserSession (   
   SessionId INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=400000),
   UserId int NOT NULL,   
   CreatedDate DATETIME2 NOT NULL,  
   ShoppingCartId INT
    )   
    WITH (MEMORY_OPTIMIZED=ON, DURABILITY=SCHEMA_AND_DATA)
GO  


-- 7. Insercion de datos en las tablas en memoria
INSERT dbo.UserSession VALUES (342, SYSDATETIME(), 4);
INSERT dbo.UserSession VALUES (65, SYSDATETIME(), NULL)   
INSERT dbo.UserSession VALUES (8798, SYSDATETIME(), 1)   
INSERT dbo.UserSession VALUES (80, SYSDATETIME(), NULL)   
INSERT dbo.UserSession VALUES (4321, SYSDATETIME(), NULL)   
INSERT dbo.UserSession VALUES (8578, SYSDATETIME(), NULL)   
  
INSERT dbo.ShoppingCart VALUES (8798, SYSDATETIME(), NULL)   
INSERT dbo.ShoppingCart VALUES (23, SYSDATETIME(), 45.4)   
INSERT dbo.ShoppingCart VALUES (80, SYSDATETIME(), NULL)   
INSERT dbo.ShoppingCart VALUES (342, SYSDATETIME(), 65.4)   
GO  
  

--8. Verificacion de los datos insertados por medio de select 
SELECT * FROM dbo.UserSession;
SELECT * FROM dbo.ShoppingCart;
GO  



--9. Operacion de modificacion sobre las tablas en memoria
BEGIN TRAN;
   UPDATE dbo.UserSession SET ShoppingCartId=3 WHERE SessionId=4;
   UPDATE dbo.ShoppingCart SET TotalPrice=65.84 WHERE ShoppingCartId=3;
COMMIT;
GO   
  
 
--10. Verificacion de los datos actualizados por medio de select 

SELECT *   
    FROM dbo.UserSession u
        JOIN dbo.ShoppingCart s on u.ShoppingCartId=s.ShoppingCartId
    WHERE u.SessionId=4;
 GO  


