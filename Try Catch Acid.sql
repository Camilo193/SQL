-- =============================================
-- Author:		<Juan Camilo Urrego Serna, Freddy Angarita>
-- Description:	<Description: Observamos el uso de TRY, CATCH para crear una transaccion ACID>
-- =============================================
--Creamos un procedimimiento almacenado para actualizar el stock despu�s de una venta
--Este procedimiento contiene una transacci�n, verifica que todas las transacciones
--Se ejecuten correctamente o no ejecuta ninguna
CREATE PROCEDURE SaleStockHoldingUpdates2(
	@StockItemTransactionID INT,
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
		INSERT INTO [Warehouse].[StockItemTransactions]
           ([StockItemTransactionID]
           ,[StockItemID]
           ,[TransactionTypeID]
           ,[CustomerID]
           ,[InvoiceID]
           ,[SupplierID]
           ,[PurchaseOrderID]
           ,[TransactionOccurredWhen]
           ,[Quantity]
           ,[LastEditedBy]
           ,[LastEditedWhen])
     VALUES
           (@StockItemTransactionID
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
			ROLLBACK TRANSACTION--Hace Rollback si alguna transacci�n falla
			RAISERROR('No se puede completar la transacci�n', 16, 1)
		END CATCH
END
GO

--Verificamos el stock del producto 80 
SELECT StockItemID, QuantityOnHand
FROM Warehouse.StockItemHoldings
WHERE StockItemID = 80

--Vendemos 5 unidades del producto 80
EXECUTE SaleStockHoldingUpdates2 29000,80, 10, 5

--Verificamos que efectivamente el stock se modific� correctamente. 
SELECT StockItemID, QuantityOnHand
FROM Warehouse.StockItemHoldings
WHERE StockItemID = 80

----Id repetido, lanzar� errpr y no se ejecuta ninguna transacci�n
EXECUTE SaleStockHoldingUpdates2 29000,80, 10, 5

--Verificamos que el stock se mantuvo igual.
SELECT StockItemID, QuantityOnHand
FROM Warehouse.StockItemHoldings
WHERE StockItemID = 80