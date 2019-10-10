-- Usamos la tempdb
USE tempdb;
GO
----------------------------------------------------------------------------------
--Creamos XML Primary Index
CREATE PRIMARY XML INDEX IX_ProductImport_ProductDetails
ON dbo.ProductImport (ProductDetails);
GO
----------------------------------------------------------------------------------
--Creamos un secondary VALUE index
CREATE XML INDEX IX_ProductImport_ProductDetails_Value
ON dbo.ProductImport (ProductDetails)
USING XML INDEX IX_ProductImport_ProductDetails
FOR VALUE;
GO
----------------------------------------------------------------------------------
--Hacemos la siguiente consulta
SELECT * FROM sys.xml_indexes;
GO
----------------------------------------------------------------------------------
--Eliminamos y creamos nuevamente la table sin una clave primaria
DROP TABLE dbo.ProductImport;
GO

CREATE TABLE dbo.ProductImport
( ProductImportID int IDENTITY(1,1),
  ProductDetails xml (CONTENT dbo.ProductDetailsSchema)
);
GO
----------------------------------------------------------------------------------
--Intentamos agregar XML Primary Index. Sacará un error
CREATE PRIMARY XML INDEX IX_ProductImport_ProductDetails
ON dbo.ProductImport (ProductDetails);
GO

