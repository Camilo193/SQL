USE tempdb;
GO

--Creamos una colecci�n de esquemas xml
CREATE XML SCHEMA COLLECTION ResumeSchemaCollection
AS
N'<?xml version="1.0" ?>
  <xsd:schema 
     targetNamespace="http://schemas.adventure-works.com/EmployeeResume" 
     xmlns="http://schemas.adventure-works.com/EmployeeResume" 
     elementFormDefault="qualified" 
     attributeFormDefault="unqualified"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema" >
    <xsd:element name="resume">
      <xsd:complexType>
        <xsd:sequence>
          <xsd:element name="name" type="xsd:string" 
                       minOccurs="1" maxOccurs="1"/>
          <xsd:element name="employmentHistory">
            <xsd:complexType>
              <xsd:sequence minOccurs="1" maxOccurs="unbounded">
                <xsd:element name="employer">
                  <xsd:complexType>
                      <xsd:simpleContent>
                        <xsd:extension base="xsd:string">
                          <xsd:attribute name="endDate" 
                                         use="optional"/>
                        </xsd:extension>
                      </xsd:simpleContent>
                  </xsd:complexType>
                </xsd:element>
              </xsd:sequence>
            </xsd:complexType>
          </xsd:element>
        </xsd:sequence>
      </xsd:complexType>
    </xsd:element>
  </xsd:schema>';
GO
-------------------------------------------------------------------------------------
--Obtenemos informaci�n de los componentes en la colecci�n de los esquemas
--Tenga en cuenta que los esquemas se almacenan como componentes, 
--no como el texto del esquema original
SELECT cp.* 
FROM sys.xml_schema_components AS cp
JOIN sys.xml_schema_collections AS c
ON cp.xml_collection_id = c.xml_collection_id
WHERE c.name = 'ResumeSchemaCollection';
GO

