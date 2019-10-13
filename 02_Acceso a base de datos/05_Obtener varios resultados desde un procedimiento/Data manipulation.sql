--Importamos la base de datos
USE WideWorldImporters
GO
----------------------------------------------------------------------------------------------------
--Creamos un procedimiento para obtener el resultado de dos consultas diferentes
CREATE PROCEDURE getItemHoldings
AS
BEGIN
	SET NOCOUNT ON;
	--Nos devuelve las transacciones que involucran mayor cantidad
	SELECT TOP 10 *
	FROM Warehouse.StockItemTransactions
	ORDER BY Quantity DESC
	--Nos devuelve los items con mayor stock en inventario
	SELECT TOP 10 *
	FROM Warehouse.StockItemHoldings
	ORDER BY QuantityOnHand DESC

END
GO
----------------------------------------------------------------------------------------------------
--Obtenemos el resultado de dos consultas diferentes
--Se podrán leer los atributos que queramos
EXECUTE getItemHoldings
----------------------------------------------------------------------------------------------------
--Limpiamos luego de ejecutarlo con c#
DROP PROCEDURE getItemHoldings








		


		
