--Usamos la tempdb
USE tempdb;
GO
----------------------------------------------------------------------------
--Creamos una tabla con una columna xml

CREATE TABLE #Invoices
( InvoiceID int,
  SalesDate datetime,
  CustomerID int,
  ItemList xml);
GO
----------------------------------------------------------------------------
--Utilizamos la conversión implícita para asignar una variable xml
DECLARE @itemString nvarchar(2000);
SET @itemString = '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>
                   </Items>';

DECLARE @itemDoc xml;
SET @itemDoc = @itemString;

INSERT INTO #Invoices VALUES (1, GetDate(), 2, @itemDoc);

SELECT * FROM #Invoices;
GO
----------------------------------------------------------------------------
-- Usamos la conversión implícita para asignar una constante de tipo String
INSERT INTO #Invoices
VALUES
(1, GetDate(), 2, '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>
                   </Items>');

SELECT * FROM #Invoices;
GO
----------------------------------------------------------------------------
--Cast explicito de string a XML
DECLARE @varToCast nvarchar(2000);
SET @varToCast = '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>
                   </Items>';
DECLARE @castedDoc xml;
SET @castedDoc = CAST(@varToCast AS xml);

INSERT INTO #Invoices VALUES(1, GetDate(), 2, @castedDoc);

SELECT * FROM #Invoices;
GO
----------------------------------------------------------------------------
--Convertir String a xml explicitamente
DECLARE @varToConvert nvarchar(2000);
SET @varToConvert = '<Items>
                       <Item ProductID="2" Quantity="3"/>
                       <Item ProductID="4" Quantity="1"/>
                     </Items>';

DECLARE @convertedDoc xml;
SET @convertedDoc = CONVERT(xml, @varToConvert);

INSERT INTO #Invoices VALUES(1, GetDate(), 2, @convertedDoc);

SELECT * FROM #Invoices;
GO
----------------------------------------------------------------------------
--Documento bien estructurado.
INSERT INTO #Invoices
VALUES
(1, GetDate(), 2, '<?xml version="1.0" ?>
                   <Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>
                   </Items>');

SELECT * FROM #Invoices;
GO
----------------------------------------------------------------------------
-- Script 14.7 Fragmento bien estructurado.
INSERT INTO #Invoices
VALUES
(1, GetDate(), 2, '<Item ProductID="2" Quantity="3"/>
                   <Item ProductID="4" Quantity="1"/>');

SELECT * FROM #Invoices;
GO
----------------------------------------------------------------------------
-- Script 14.8 No está bien estructurado. Sacará error
INSERT INTO #Invoices
VALUES
(1, GetDate(), 2, '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>');

SELECT * FROM #Invoices;
GO
----------------------------------------------------------------------------
-- Eliminamos la tabla temporal
DROP TABLE #Invoices;
GO
