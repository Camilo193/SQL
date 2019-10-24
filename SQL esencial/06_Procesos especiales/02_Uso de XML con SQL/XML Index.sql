-- Usamos la tempdb
USE tempdb;
GO
----------------------------------------------------------------------------------
--Creamos un esquema COLLECTION XML
CREATE XML SCHEMA COLLECTION dbo.ProductDetailsSchema
AS 
'<xsd:schema targetNamespace="urn:schemas-microsoft-com:sql:SqlRowSet3" xmlns:schema="urn:schemas-microsoft-com:sql:SqlRowSet3" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sqltypes="http://schemas.microsoft.com/sqlserver/2004/sqltypes" elementFormDefault="qualified">
  <xsd:import namespace="http://schemas.microsoft.com/sqlserver/2004/sqltypes" schemaLocation="http://schemas.microsoft.com/sqlserver/2004/sqltypes/sqltypes.xsd" />
  <xsd:element name="Production.Product">
    <xsd:complexType>
      <xsd:attribute name="ProductID" type="sqltypes:int" use="required" />
      <xsd:attribute name="Name" use="required">
        <xsd:simpleType sqltypes:sqlTypeAlias="[AdventureWorks2008R2].[dbo].[Name]">
          <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1033" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
            <xsd:maxLength value="50" />
          </xsd:restriction>
        </xsd:simpleType>
      </xsd:attribute>
      <xsd:attribute name="Color">
        <xsd:simpleType>
          <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1033" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
            <xsd:maxLength value="15" />
          </xsd:restriction>
        </xsd:simpleType>
      </xsd:attribute>
      <xsd:attribute name="Size">
        <xsd:simpleType>
          <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1033" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
            <xsd:maxLength value="5" />
          </xsd:restriction>
        </xsd:simpleType>
      </xsd:attribute>
      <xsd:attribute name="ListPrice" type="sqltypes:money" use="required" />
    </xsd:complexType>
  </xsd:element>
</xsd:schema>';
GO
----------------------------------------------------------------------------------
--Creamos la siguiente tabla con el esquema anterior
CREATE TABLE dbo.ProductImport
( ProductImportID int IDENTITY(1,1) PRIMARY KEY,
  ProductDetails xml (CONTENT dbo.ProductDetailsSchema)
);
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

