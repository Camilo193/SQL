--Creamos una función Multi Statement
--Esta función guardará los datos de contacto de los clientes y proovedores
CREATE FUNCTION udfContacts()
    RETURNS @contacts TABLE (
        ContactName NVARCHAR(100),
        PhoneNumber NVARCHAR(20),
		ContactType NVARCHAR(20)
    )
AS
BEGIN
    INSERT INTO @contacts
    SELECT 
        SupplierName, 
        PhoneNumber, 
        'Supplier'
    FROM
        Purchasing.Suppliers;
 
    INSERT INTO @contacts
    SELECT 
        CustomerName, 
        PhoneNumber,
        'Customer'
    FROM
        Sales.Customers;
    RETURN;
END;
GO
--------------------------
SELECT * 
FROM udfContacts();