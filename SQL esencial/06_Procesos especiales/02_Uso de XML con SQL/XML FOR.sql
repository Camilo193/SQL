--Importamos la base de datos
USE WideWorldImporters
GO
--------------------------------------------------------------------------------------------------------------
--Hacemos la siguiente consulta
SELECT CustomerID, 
       CustomerName, 
       CustomerCategoryName, 
       PrimaryContact, 
       AlternateContact, 
       PhoneNumber, 
       WebsiteURL, 
       DeliveryMethod
FROM WideWorldImporters.Website.Customers
WHERE CustomerID < 3;
--------------------------------------------------------------------------------------------------------------
--Ahora hacemos la consulta con  la sentencia FOR XML
--Podemos abrir el resultado
SELECT CustomerID, 
       CustomerName, 
       CustomerCategoryName, 
       PrimaryContact, 
       AlternateContact, 
       PhoneNumber, 
       WebsiteURL, 
       DeliveryMethod
FROM WideWorldImporters.Website.Customers
WHERE CustomerID < 3 FOR XML PATH;
--------------------------------------------------------------------------------------------------------------
--Podemos agregar un alias en el Select 
--Nos muestra el alias en vez de la etiqueta de metadatos <Customerdata> para cada fila de datos
--También podemos cambiar la etiqueta row 
--Agregamos Customers para la etiqueta
SELECT CustomerID as "@CustomerID", 
       CustomerName, 
       CustomerCategoryName, 
       PrimaryContact, 
       AlternateContact, 
       PhoneNumber, 
       WebsiteURL, 
       DeliveryMethod
FROM WideWorldImporters.Website.Customers
WHERE CustomerID < 3 FOR XML PATH('Customer'), ROOT('Customers');
