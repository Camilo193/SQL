--Importamos la base de datos
USE WideWorldImporters
GO
---------------------------------------------------------------------------------------
--Creamos una nueva tabla para el ejemplo
CREATE TABLE Sales.CustomerOrderXML
(
        ID INT NOT NULL IDENTITY,
        CustomerID INT NOT NULL,
        OrderSummary XML
);
---------------------------------------------------------------------------------------
--Llenamos la tabla con datos con el siguiente Script
INSERT INTO Sales.CustomerOrderXML (CustomerID,
OrderSummary)
SELECT
        CustomerID,
        (
SELECT
CustomerName 'OrderHeader/CustomerName'
, OrderDate 'OrderHeader/OrderDate' , OrderID 'OrderHeader/OrderID'
,(

SELECT

LineItems2.StockItemID
  '@ProductID'
, StockItems.StockItemName '@ProductName'
, LineItems2.UnitPrice
'@Price'
, Quantity '@Qty'
FROM Sales.OrderLines LineItems2 INNER JOIN Warehouse.StockItems StockItems
ON LineItems2.StockItemID
= StockItems.StockItemID WHERE LineItems2.OrderID =
      Base.OrderID
      FOR XML PATH('Product'), TYPE
) 'OrderDetails'

FROM
 (

SELECT DISTINCT
          Customers.CustomerName
        , SalesOrder.OrderDate
        , SalesOrder.OrderID
FROM Sales.Orders SalesOrder
INNER JOIN Sales.OrderLines LineItem
        ON SalesOrder.OrderID =
        LineItem.OrderID
INNER JOIN Sales.Customers Customers
        ON Customers.CustomerID =
        SalesOrder.CustomerID
WHERE customers.CustomerID = OuterCust.
CustomerID
) Base
FOR XML PATH('Order'), ROOT ('SalesOrders'), TYPE
        ) AS OrderSummary
FROM Sales.Customers OuterCust;
---------------------------------------------------------------------------------------
--Consultamos la tabla para ver que realmente guardo los registros correctamente
SELECT * from Sales.CustomerOrderXML
---------------------------------------------------------------------------------------
--Ejecutamos las consultas tipo path y buscamos la diferencia
SELECT ID, CustomerID
FROM Sales.CustomerOrderXML
WHERE ID IN (119,122)
FOR XML PATH ('Orders');
GO
SELECT ID AS "@ProductID" , CustomerID
FROM Sales.CustomerOrderXML
WHERE ID IN (119,122)
FOR XML PATH ('Orders');
GO
-------------------------------------------------------------------------------------
--Colocamos todo junto en una sola consulta
--Devuelve un documento XML en el formato Path.
SELECT
       CustomerName 'OrderHeader/CustomerName' 
     , OrderDate 'OrderHeader/OrderDate'
     , OrderID 'OrderHeader/OrderID'
     ,(

SELECT
        LineItems2.StockItemID '@ProductID'
      , StockItems.StockItemName '@ProductName'
      , LineItems2.UnitPrice '@Price'
            , Quantity '@Qty'  
      FROM Sales.OrderLines LineItems2
      INNER JOIN Warehouse.StockItems StockItems
              ON LineItems2.StockItemID = StockItems.StockItemID
      WHERE LineItems2.OrderID = Base.OrderID
      FOR XML PATH('Product'), TYPE
      ) 'OrderDetails'

FROM 
(

SELECT DISTINCT
          Customers.CustomerName
        , SalesOrder.OrderDate
        , SalesOrder.OrderID
FROM Sales.Orders SalesOrder
INNER JOIN Sales.OrderLines LineItem
        ON SalesOrder.OrderID = LineItem.OrderID
INNER JOIN Sales.Customers Customers
        ON Customers.CustomerID = SalesOrder.CustomerID
        WHERE customers.CustomerName = 'Agrita Abele'
) Base
FOR XML PATH('Order'), ROOT ('SalesOrders') ;
-------------------------------------------------------------------------------------
--Ejemplo de XML Xquery
declare @myDoc xml  
set @myDoc = '<Root>  
<ProductDescription ProductID="1" ProductName="Road Bike">  
<Features>  
  <Warranty>1 year parts and labor</Warranty>  
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>  
</Features>  
</ProductDescription>  
</Root>'  
SELECT @myDoc.query('/Root/ProductDescription/Features') 
-------------------------------------------------------------------------------------------------
--Ejemplo de XML Xquery
DECLARE @price money  
SET @price=2500  
DECLARE @x xml  
SET @x = ''  
SELECT @x.query('<value>{sql:variable("@price") }</value>')  