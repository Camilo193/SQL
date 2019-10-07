USE WideWorldImporters
--Creamos un procedimiento almacenado ACID
-------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SaleStockHoldingUpdates( 
	@ItemId INT,--(Item a vender)
	@TransactionTypeID INT,--Tipo de transacci�n (10 para vender)
	@Quantity DECIMAL(18,3)--Cantidad a vender
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @qoh INT--Stock en el inventario
		--Transacci�n 1
		SELECT @qoh = QuantityOnHand 
		FROM Warehouse.StockItemHoldings
		WHERE StockItemID = @ItemId
		--Transacci�n 2
		INSERT INTO Warehouse.StockItemTransactions
           (StockItemTransactionID
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
     VALUES
           (294505--Valor quemado de una llave primaria, para sacar un error adrede en la segunda ejecuci�n
           ,@ItemId--Item que se vendi�
           ,@TransactionTypeID--Tipo de transacci�n (10 es venta)
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,GETDATE()
           ,@Quantity--Cantidad vendida
           ,1
           ,GETDATE())
		--Transacci�n 3
		UPDATE Warehouse.StockItemHoldings --Modifica stock del producto que se vendi�
		SET QuantityOnHand = QuantityOnHand - @Quantity --Cantidad actual menos la que se vendi�
		WHERE StockItemID = @ItemId

		COMMIT TRANSACTION --Confirmamos la transacci�n
		--Si alguna de las 3 transacciones falla, no se ejecuta ninguna
	END TRY
		BEGIN CATCH
			IF @@trancount > 0
				ROLLBACK TRANSACTION--Hace Rollback si alguna transacci�n falla
				RAISERROR('No se puede completar la transacci�n', 16, 1)
		END CATCH
END
GO
-------------------------------------------------------------------------------------------------------
--Verificamos el stock del producto 86
SELECT StockItemID, QuantityOnHand
FROM Warehouse.StockItemHoldings
WHERE StockItemID = 86
-------------------------------------------------------------------------------------------------------
--Vendemos 2 unidades del producto 86
EXECUTE SaleStockHoldingUpdates 86, 10, 2
-------------------------------------------------------------------------------------------------------
--Verificamos que efectivamente el stock se modific� correctamente.
SELECT StockItemID, QuantityOnHand
FROM Warehouse.StockItemHoldings
WHERE StockItemID = 86
-------------------------------------------------------------------------------------------------------
--Ejecutamos una nueva venta, pero esta vez lanzar� error y no se ejecuta ninguna transacci�n
EXECUTE SaleStockHoldingUpdates 86, 10, 2
-------------------------------------------------------------------------------------------------------
--Verificamos que el stock se mantuvo igual.
SELECT StockItemID, QuantityOnHand
FROM Warehouse.StockItemHoldings
WHERE StockItemID = 86
-------------------------------------------------------------------------------------------------------
--Limpiamos
DROP PROCEDURE SaleStockHoldingUpdates