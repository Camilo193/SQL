--Importamos la base de datos
USE WideWorldImporters
GO
-------------------------------------------------------------------------
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
-------------------------------------------------------------------------
--Declaramos el parametro de salida y lo usamos en el procedimiento
--Ejecutamos las 3 lineas juntas
DECLARE @output INT
EXECUTE dbo.GetCustomer 1, @output OUTPUT
--Ahora podemos usar el parametro
SELECT @output
GO
---------------------------------------------------------------------------

