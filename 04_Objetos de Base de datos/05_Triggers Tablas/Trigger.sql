USE WideWorldImporters
SELECT *
FROM Warehouse.StockItemHoldings

--Creamos un Trigger que nos impide vender un producto cuando no tenga
--el stock suficiente
CREATE TRIGGER TR_SalesOrders_Insert
ON Warehouse.StockItemHoldings
AFTER UPDATE AS BEGIN
  IF EXISTS( SELECT 1 
             FROM updated AS u
             WHERE u.QuantityOnHand < 0
           ) BEGIN
    PRINT 'The quantity on hand cannot be less than 0';
    ROLLBACK;           
  END;
END;
GO

--Verificamos el stock del producto 80 
SELECT StockItemID, QuantityOnHand
FROM Warehouse.StockItemHoldings
WHERE StockItemID = 80
GO

--Vendemos 50 unidades del producto 80
--Genera un error en la transacción ACID de SaleStockHoldingUpdates2
--La excepción se debe a que no deja actualizar la informacíón
EXECUTE SaleStockHoldingUpdates2 29000,80, 10, 50
GO
--Creamos una tabla con dos columnas string
CREATE TABLE dbo.PostalCode
( CustomerID int PRIMARY KEY,
  PostalCode nvarchar(5) NOT NULL,
  PostalSubCode nvarchar(5) NULL
);
GO
--Creamos una vista y concatenamos las dos columnas
CREATE VIEW dbo.PostalRegion
AS
SELECT CustomerID,
       PostalCode + COALESCE('-' + PostalSubCode,'') AS PostalRegion
FROM dbo.PostalCode;
GO
--
-- Insertamos datos en la tabla

INSERT dbo.PostalCode (CustomerID,PostalCode,PostalSubCode)
VALUES (1,'23422','234'),
       (2,'23523',NULL),
       (3,'08022','523');
GO
       
-- Consultamos la vista para ver el resultado
SELECT * FROM dbo.PostalRegion;
GO

-- Intentamos insertar en la vista - sacará un error

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO

-- Intentamos actualizar en la vista - sacará un error

UPDATE dbo.PostalRegion SET PostalRegion = '23234-523' WHERE CustomerID = 3;
GO

-- Ahora intentamos eliminar

DELETE FROM dbo.PostalRegion WHERE CustomerID = 3;
GO

--¿Por qué el INSERT y UPDATE sacan error pero el DELETE NO?

--Creamos un Trigger de inserción
CREATE TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO
--
--Intentamos insertar nuevamente

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO
--Le agregamos el SET NOCOUNT ON, para que la insercción no devuelva una row adicional
ALTER TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
SET NOCOUNT ON;
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO

-- Insertamos nuevamente

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (5,'92232-142');
GO
--Vemos que solo muestra la row afectada
--Insertamos multiple rows
INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (6,'11111-111'),
       (7,'99999-999');
GO
--Finalmente visualizamos 
SELECT * FROM dbo.PostalRegion;
GO

--Mostramos los triggers que existen con su respectiva información
SELECT * FROM sys.triggers;
GO

