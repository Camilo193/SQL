SELECT * 
FROM Warehouse.StockItemTransactions

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
		29123465 
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

--Ejecutamos el procedimiento y le pasamos el parametro
EXECUTE TVPProcedure @TVPInsert

--Verificamos que efectivamente el dato se guardo en la tabla original
SELECT * 
FROM Warehouse.StockItemTransactions
WHERE StockItemTransactionID = 29123465
