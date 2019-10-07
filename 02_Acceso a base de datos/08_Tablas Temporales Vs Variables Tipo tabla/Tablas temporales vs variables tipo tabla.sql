--------------------------------------------
--Tabla Temporal vs Variable Tipo Tabla
--------------------------------------------

--------------------------------------------
--Tabla Temporal
--------------------------------------------
DROP TABLE IF EXISTS #temp1;

CREATE TABLE #temp1(
        StockItemID int
		,StockItemName nvarchar(100)
		)

INSERT INTO #temp1
SELECT StockItemID,StockItemName
FROM [Warehouse].[StockItems]

------------------------------------------------
--Ejemplo de consulta con una tabla mas grande
------------------------------------------------
SET STATISTICS IO ON
	SELECT a.*,tmp.StockItemName
	FROM [Sales].[OrderLines] a 
	INNER JOIN #temp1 tmp ON a.StockItemID = tmp.StockItemID
SET STATISTICS IO OFF

-----------------------------------------------
--Variable Tipo Tabla
-----------------------------------------------
DECLARE @temp1 TABLE (  StockItemID int, StockItemName nvarchar(100))
INSERT INTO @temp1
SELECT StockItemID,StockItemName
FROM [Warehouse].[StockItems]

-------------------------------------------------
--Ejemplo de consulta con una tabla mas grande
-------------------------------------------------
SET STATISTICS IO ON
	SELECT a.*,tmp.StockItemName
	FROM [Sales].[OrderLines] a 
	INNER JOIN @temp1 tmp ON a.StockItemID = tmp.StockItemID
SET STATISTICS IO OFF

--Como conclusión cada uno de los tipos de tabla tiene su escenario de aplicación.
