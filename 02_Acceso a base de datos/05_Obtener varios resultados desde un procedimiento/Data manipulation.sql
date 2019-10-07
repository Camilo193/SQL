-- =============================================
-- Author:		<Juan Camilo Urrego Serna,,Freddy Angarita>
-- Description:	<Creamos un procedimiento almacenado que nos devuelve dos consultas>
-- =============================================
CREATE PROCEDURE getItemHoldings
AS
BEGIN
	SET NOCOUNT ON;
	--Nos devuelve las transacciones que involucran mayor cantidad
	SELECT TOP 20 *
	FROM Warehouse.StockItemTransactions
	ORDER BY Quantity DESC
	--Nos devuelve los items con mayor stock en inventario
	SELECT TOP 20 *
	FROM Warehouse.StockItemHoldings
	ORDER BY QuantityOnHand DESC

END
GO
--Obtenemos el resultado de dos consultas diferentes
--Se podrán leer los atributos que queramos
EXECUTE getItemHoldings








		


		