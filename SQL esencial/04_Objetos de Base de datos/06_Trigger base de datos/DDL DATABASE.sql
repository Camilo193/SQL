--Creamos un TRIGGER que no nos deja eliminar o alterar tablas
CREATE TRIGGER changeControl   
ON DATABASE   
FOR DROP_TABLE, ALTER_TABLE   
AS   
   PRINT 'You must disable Trigger "changeControl" to drop or alter tables!'   
   ROLLBACK;
--------------------------------------------------------------------------
--Intentamos eliminar una tabla
DROP TABLE Application.SystemParameters
GO
--No nos dejará eliminar la tabla
---------------------------------------------------------------------------
--Modificamos el TRIGGER para que tampoco nos deje crear tablas
ALTER TRIGGER changeControl   
ON DATABASE   
FOR DROP_TABLE, ALTER_TABLE, CREATE_TABLE   
AS   
   PRINT 'You must disable Trigger "changeControl" to drop, alter or create tables!'   
   ROLLBACK;
---------------------------------------------------------------------------------
--Intentamos crear una tabla

CREATE TABLE TEST
( Code NCHAR(4), Category NVARCHAR(100) )
GO
----------------------------------------------------------------------------------------------
--Deshabilitamos el TRIGGER
DISABLE TRIGGER changeControl ON DATABASE
----------------------------------------------------------------------------------------------
--Intentamos crear la tabla nuevamente
CREATE TABLE TEST
( Code NCHAR(4), Category NVARCHAR(100) )
GO
----------------------------------------------------------------------------------------------
--Eliminamos la tabla
DROP TABLE TEST
----------------------------------------------------------------------------------------------
--Eliminamos el TRIGGER
DROP TRIGGER changeControl ON DATABASE;
----------------------------------------------------------------------------------------------
--Creamos un TRIGGER que capture el evento cuando se cree una vista
CREATE TRIGGER GetView ON DATABASE
FOR Create_View
AS
BEGIN
SELECT EVENTDATA()
END
GO
----------------------------------------------------------------------------------------------
--Creamos una vista y nos devuelve un esquema XML con los detalles
CREATE VIEW ViewCategories
AS
SELECT C.SupplierCategoryID As 'Code', C.SupplierCategoryName As 'Name'
FROM Purchasing.SupplierCategories As C
GO
--------------------------------------------------------------------------------------------
--Limpiamos
DROP TRIGGER GetView ON DATABASE;
DROP VIEW ViewCategories
