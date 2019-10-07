--Importamos la base de datos
USE WideWorldImporters
GO
-----------------------------------------------------------------------------
--Creamos un procedimiento para obtener el cliente
CREATE PROCEDURE dbo.GetCustomer
		@OrderID INT, --Parametro de entrada
		@CustomerID INT OUTPUT --Parametro de salida
AS
BEGIN
	SELECT @CustomerID = cst.CustomerID
	FROM Sales.Customers as cst, Sales.Orders as ord
	WHERE cst.CustomerID = ord.CustomerID AND ord.OrderID = @OrderId
END
GO
-----------------------------------------------------------------------------
--Declaramos el parametro de salida y lo usamos en el procedimiento
--Ejecutamos las 3 lineas juntas
DECLARE @output INT
EXECUTE dbo.GetCustomer 1, @output OUTPUT
--Ahora podemos usar el parametro
SELECT @output
GO
-----------------------------------------------------------------------------
--Limpiamos
DROP PROCEDURE dbo.GetCustomer
-----------------------------------------------------------------------------
--Creamos un procedimiento para mostrar el uso de SET NOCOUNT ON/OFF
CREATE PROCEDURE PrintTransactions
	AS
BEGIN
	SELECT * 
	FROM Warehouse.StockItemTransactions
END
GO
-----------------------------------------------------------------------------
--Ejecutamos el procedimiento y vemos que nos devuelve las filas afectadas
EXECUTE PrintTransactions
-----------------------------------------------------------------------------
--Modificamos el procedimiento para ver el SET NOCOUNT ON
ALTER PROCEDURE dbo.PrintTransactions
	AS
BEGIN	
	SET NOCOUNT ON;
	SELECT * 
	FROM Warehouse.StockItemTransactions
END
GO
-----------------------------------------------------------------------------
--Ejecutamos el procedimiento y vemos que no muestra mensajes
EXECUTE PrintTransactions
-----------------------------------------------------------------------------
--Limpiamos
DROP PROCEDURE PrintTransactions
