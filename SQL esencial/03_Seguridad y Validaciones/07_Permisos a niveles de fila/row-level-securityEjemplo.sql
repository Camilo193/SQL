-------------------------------------
--PERMISOS A NIVEL DE FILA
-------------------------------------
DROP USER IF EXISTS  Manager;
DROP USER IF EXISTS  Sales1;
DROP USER IF EXISTS  Sales2;
DROP SECURITY POLICY IF EXISTS SalesFilter;  
DROP FUNCTION IF EXISTS [Security].fn_securitypredicate;
DROP SCHEMA IF EXISTS [Security];
DROP TABLE IF EXISTS Sales;


CREATE USER Manager WITHOUT LOGIN;  
CREATE USER Sales1 WITHOUT LOGIN;  
CREATE USER Sales2 WITHOUT LOGIN; 

--Cree una tabla que contenga datos.
DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales  
    (  
    OrderID int,  
    SalesRep sysname,  
    Product varchar(10),  
    Qty int  
    );  

--Rellene la tabla con seis filas de datos que muestren tres pedidos para cada representante de ventas.
INSERT INTO Sales VALUES (1, 'Sales1', 'Valve', 5);
INSERT INTO Sales VALUES (2, 'Sales1', 'Wheel', 2);
INSERT INTO Sales VALUES (3, 'Sales1', 'Valve', 4);
INSERT INTO Sales VALUES (4, 'Sales2', 'Bracket', 2);
INSERT INTO Sales VALUES (5, 'Sales2', 'Wheel', 5);
INSERT INTO Sales VALUES (6, 'Sales2', 'Seat', 5);
-- View the 6 rows in the table  
SELECT * FROM Sales;

--Conceda acceso de lectura en la tabla para cada usuario.
GRANT SELECT ON Sales TO Manager;  
GRANT SELECT ON Sales TO Sales1;  
GRANT SELECT ON Sales TO Sales2;  

DROP SCHEMA IF EXISTS [Security]
GO
CREATE SCHEMA [Security];  
GO  

DROP FUNCTION IF EXISTS [Security].fn_securitypredicate;
GO  
CREATE FUNCTION [Security].fn_securitypredicate(@SalesRep AS sysname)  
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result
WHERE @SalesRep = USER_NAME() OR USER_NAME() = 'Manager';  

--Cree una directiva de seguridad agregando la función como un predicado de filtro. El estado se debe configurar en ON para habilitar la directiva.
GO
DROP SECURITY POLICY IF EXISTS SalesFilter;  
GO
CREATE SECURITY POLICY SalesFilter  
ADD FILTER PREDICATE Security.fn_securitypredicate(SalesRep)
ON dbo.Sales  
WITH (STATE = ON);  


--Permisos SELECT para la función fn_securitypredicate
GRANT SELECT ON security.fn_securitypredicate TO Manager;  
GRANT SELECT ON security.fn_securitypredicate TO Sales1;  
GRANT SELECT ON security.fn_securitypredicate TO Sales2;  

--Pruebe ahora el predicado de filtrado seleccionando de la tabla Ventas como cada usuario.
EXECUTE AS USER = 'Sales1';  
SELECT * FROM Sales;
REVERT;  
  
EXECUTE AS USER = 'Sales2';  
SELECT * FROM Sales;
REVERT;  
  
EXECUTE AS USER = 'Manager';  
SELECT * FROM Sales;
REVERT;  

-------------------------------------------------------------------
--Codigo de limpieza
-------------------------------------------------------------------
DROP USER IF EXISTS  Manager;
DROP USER IF EXISTS  Sales1;
DROP USER IF EXISTS  Sales2;
DROP SECURITY POLICY IF EXISTS SalesFilter;  
DROP FUNCTION IF EXISTS [Security].fn_securitypredicate;
DROP SCHEMA IF EXISTS [Security];
DROP TABLE IF EXISTS Sales;



