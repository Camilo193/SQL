--Validar el nivel de aislamiento en nuestrar bases de datos
SELECT name, snapshot_isolation_state, is_read_committed_snapshot_on FROM sys.databases;
--------------------------------------------------------------------------------------------
--Cambiamos el nivel de aislamiento según sea el caso
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
GO  
BEGIN TRANSACTION;  
GO  
SELECT *   
    FROM Warehouse.StockItemTransactions  
GO  
SELECT *   
    FROM Warehouse.StockItems;  
GO  
COMMIT TRANSACTION;  
GO 

--Niveles de aislamiento
-------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
------------------------------------------------
--Esto reemplaza READ COMMITTED con SNAPSHOT:
ALTER DATABASE WideWorldImporters  
SET READ_COMMITTED_SNAPSHOT ON--Valor predeterminado de SQL Azure
--Permite el acceso a filas versionadas bajo el nivel de aislamiento READ COMMITTED.
 ALTER DATABASE WideWorldImporters  
SET ALLOW_SNAPSHOT_ISOLATION ON

--Desactiva lo anterior
ALTER DATABASE WideWorldImporters  
SET READ_COMMITTED_SNAPSHOT OFF--Valor predeterminado de SQL Server

ALTER DATABASE WideWorldImporters  
SET ALLOW_SNAPSHOT_ISOLATION OFF
--------------------------------------------------------------------------------------------
--Demostraciones
--Esté será el número original: (406) 555-0100
--Podremos ver sus cambios
USE WideWorldImporters
SELECT CustomerID, PhoneNumber FROM Sales.Customers WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
-- Corremos esta transacción

BEGIN TRANSACTION
	UPDATE Sales.Customers 
	SET PhoneNumber = N'999-555-9999'
	WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
--Probamos LEVEL READ UNCOMMITTED
--Se muestra el valor actualizado para la columna Teléfono, 
--incluso si la transacción no se confirma
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SELECT CustomerID, PhoneNumber 
FROM Sales.Customers 
WHERE CustomerID = 2;
GO
---------------------------------------------------------------------------------------------
--Devolvemos la transacción
--Una vez que la sesión de bloqueo se revierte, esta consulta devuelve un valor
ROLLBACK;
GO
---------------------------------------------------------------------------------------------
--Demostramos que el aislamiento READ COMMITTED con 
--READ_COMMITTED_SNAPSHOT OFF evita una lectura sucia
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
SELECT CustomerID, PhoneNumber 
FROM Sales.Customers WITH (READCOMMITTEDLOCK)
WHERE CustomerID = 2;
GO
---------------------------------------------------------------------------------------------
--Lectura no repetible
--READ COMMITTED con READ_COMMITTED_SNAPSHOT OFF permite la lectura no repetible
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
	SELECT CustomerID, PhoneNumber 
	FROM Sales.Customers WITH (READCOMMITTEDLOCK)
	WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
--Actualizamos
UPDATE Sales.Customers
SET PhoneNumber = N'333-555-3333'
WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
--Tenga en cuenta que el valor de la columna Teléfono ha cambiado durante la transacción.
SELECT CustomerID, PhoneNumber 
FROM Sales.Customers WITH (READCOMMITTEDLOCK)
WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
-- REPEATABLE READ evita lectura no repetible
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
GO
BEGIN TRANSACTION
	SELECT CustomerID, PhoneNumber 
	FROM Sales.Customers
	WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
-- Actualizamos y tenemos un bloqueo
UPDATE Sales.Customers
SET PhoneNumber = N'444-555-4444'
WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
--Tenga en cuenta que el valor de la columna Teléfono no ha cambiado durante la transacción
	SELECT CustomerID, PhoneNumber 
	FROM Sales.Customers
	WHERE CustomerID = 2;
COMMIT TRANSACTION;
-- Cuando se confirma esta transacción, la consulta bloqueada se completa
---------------------------------------------------------------------------------------------
-- REPEATABLE READ permite lectura fantasma
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRANSACTION
	SELECT COUNT(*) AS CustCount 
	FROM Sales.Customers
	WHERE PhoneNumber < '111-555-2222';
---------------------------------------------------------------------------------------------
-- Ejecutamos el Insert
INSERT Sales.Customers
(CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy)
SELECT  'Test' AS CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, N'111-555-2222' AS PhoneNumber, FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy
FROM Sales.Customers
WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
--Tenga en cuenta que el valor del COUNT ha aumentado en uno
	SELECT COUNT(*) AS CustCount 
	FROM Sales.Customers
	WHERE PhoneNumber < '111-555-2222';
COMMIT TRANSACTION;
---------------------------------------------------------------------------------------------
-- Serializable y lectura fantasma
--SERIALIZABLE previene lectura fantasma
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO
BEGIN TRANSACTION
	SELECT COUNT(*) AS CustCount 
	FROM Sales.Customers
	WHERE PhoneNumber < '111-555-2222';
---------------------------------------------------------------------------------------------
-- Ejecutamos el Insert y se bloquea
INSERT Sales.Customers
(CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy)
SELECT  'Test2' AS CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, N'111-555-2222' AS PhoneNumber, FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy
FROM Sales.Customers
WHERE CustomerID = 2;
---------------------------------------------------------------------------------------------
--Tenga en cuenta que el valor del COUNT coincide con la primera consulta
	SELECT COUNT(*) AS CustCount 
	FROM Sales.Customers
	WHERE PhoneNumber < '111-555-2222';
COMMIT TRANSACTION;
--Cuando se confirma esta transacción, la consulta bloqueada se completa
---------------------------------------------------------------------------------------------
-- Snapshot
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
------------------------------------
BEGIN TRANSACTION;
UPDATE Sales.Customers
	SET CustomerName = N'Mc Milk'
	WHERE CustomerID = 5;
--Podemos ver que hay un bloqueo exclusivo (X) en una llave y un par de bloqueos
--de intención exclusiva (IX) en una página y un objeto. Por lo tanto pesimista
--Se está utilizando el bloqueo, incluso bajo aislamiento SNAPSHOT.
SELECT *
FROM sys.dm_tran_version_store
WHERE database_id = DB_ID(N'WideWorldImporters');
--La columna request_session_id muestra qué sesión es responsable de cada bloqueo.
SELECT *
FROM sys.dm_tran_locks
WHERE resource_database_id = DB_ID(N'WideWorldImporters');
--
SELECT *
FROM sys.dm_tran_locks
WHERE resource_database_id = DB_ID(N'WideWorldImporters');
---------------------------------------------------------------------------------------------
--Confirmamos la transacción
COMMIT TRANSACTION;
---------------------------------------------------------------------------------------------


