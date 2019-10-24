--Importamos la base de datos
USE WideWorldImporters
GO
--------------------------------------------------------------------------
--Creamos un TYPE de la tabla Warehouse.StockItemTransactions
CREATE TYPE TVPStockItemTransactions AS TABLE 
		(StockItemTransactionID INT PRIMARY KEY
		,StockItemID INT NOT NULL
		,TransactionTypeID INT NOT NULL
		,CustomerID INT
		,InvoiceID INT
		,SupplierID INT
		,PurchaseOrderID INT
		,TransactionOccurredWhen DATETIME2(7) NOT NULL
		,Quantity DECIMAL(18,3) NOT NULL
		,LastEditedBy INT NOT NULL
		,LastEditedWhen DATETIME2(7) NOT NULL) 
GO
--------------------------------------------------------------------------
--Creamos un procedimiento que recibe un parametro tipo tabla
--para luego insertar datos en una tabla
CREATE PROCEDURE TVPProcedure
	--Se debe agregar el READONLY
	@TVP TVPStockItemTransactions READONLY --Nombre de la variable, nombre del type
AS
	INSERT INTO Warehouse.StockItemTransactions(
		 StockItemTransactionID
		,StockItemID
		,TransactionTypeID
		,CustomerID
		,InvoiceID
		,SupplierID
		,PurchaseOrderID
		,TransactionOccurredWhen
		,Quantity
		,LastEditedBy
		,LastEditedWhen)
		--Los datos a insertar
		SELECT * FROM @TVP
GO
--------------------------------------------------------------------------
--Ejecutamos todo este bloque junto
--Declaramos la variable para insertar los datos
DECLARE @TVPInsert AS TVPStockItemTransactions
INSERT INTO @TVPInsert(
		 StockItemTransactionID
		,StockItemID
		,TransactionTypeID
		,CustomerID
		,InvoiceID
		,SupplierID
		,PurchaseOrderID
		,TransactionOccurredWhen
		,Quantity
		,LastEditedBy
		,LastEditedWhen)
		VALUES(
		2900012
		,222
		,10
		,NULL
		,NULL
		,NULL
		,NULL
		,GETDATE()
		,12
		,2
		,GETDATE())
EXECUTE TVPProcedure @TVPInsert
GO
--------------------------------------------------------------------------
--Verificamos que efectivamente el dato se guardo en la tabla original
SELECT * 
FROM Warehouse.StockItemTransactions
WHERE StockItemTransactionID = 2900012
--------------------------------------------------------------------------
--Limpiamos
DROP PROCEDURE TVPProcedure
DROP TYPE TVPStockItemTransactions

DELETE FROM Warehouse.StockItemTransactions
WHERE StockItemTransactionID = 2900012
DELETE FROM Warehouse.StockItemTransactions
WHERE StockItemTransactionID = 2900013



