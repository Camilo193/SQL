--Creamos una funci�n table-valued
--Esta funci�n nos trae una transaccion entre dos fechas
--Esta funcion se conoce como inline porque retorna un conjunto de datos de un SELECT
CREATE FUNCTION udfTransactionInYear (
    @start_data DATETIME2,
    @end_data DATETIME2
)
RETURNS TABLE
AS
RETURN
    SELECT 
        StockItemTransactionID,
        CustomerID,
        Quantity,
		TransactionOccurredWhen
    FROM
        Warehouse.StockItemTransactions
    WHERE
        TransactionOccurredWhen BETWEEN @start_data AND @end_data
-----------------------------------------------------------------
--Hacemos un Select con la funci�n en el FROM
SELECT StockItemTransactionID, CustomerID, Quantity, TransactionOccurredWhen
FROM udfTransactionInYear('2013-01-26', '2014-03-25')
