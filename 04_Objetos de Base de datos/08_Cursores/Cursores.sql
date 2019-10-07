--Usamos la base de datos
USE WideWorldImporters
GO
-------------------------------------------------------------------------------------
--Declaramos las variables a usar con el cursor
DECLARE @CustomerID INT
DECLARE @CustomerName NVARCHAR(100), @PostalPostalCode NVARCHAR(10)
-- Declaramos el cursos llamado SupermarketCustomers
DECLARE SupermarketCustomers Cursor FOR
--Realizamos la consulta
 SELECT CustomerID, CustomerName, PostalPostalCode 
 FROM Sales.Customers
 WHERE CustomerCategoryID = 4
-- Abrimos el cursor
OPEN SupermarketCustomers
-- Extraemos datos y los asignamos a las variables
FETCH NEXT FROM SupermarketCustomers INTO @CustomerID, @CustomerName, @PostalPostalCode 
-- Realizar esta acción hasta que no se encuentren más filas
WHILE @@FETCH_STATUS = 0
BEGIN
 -- Obtenemos la siguiente fila del cursor
 FETCH NEXT FROM SupermarketCustomers INTO @CustomerID, @CustomerName, @PostalPostalCode
 --Podríamos ejecutar un procedimiento o interactuar con las variables a nuestro beneficio
 --EXEC MyStoredProc @CustomerID, @CustomerName, @PostalPostalCode
 
END
--Mostramos el último dato asignado a las variables
SELECT @CustomerID, @CustomerName, @PostalPostalCode
-- Cerramos el cursos para liberarlo de bloqueos
CLOSE SupermarketCustomers
-- Liberamos la memoria usada por el cursor
DEALLOCATE SupermarketCustomers
GO
-------------------------------------------------------------------------------------
-- Otra alternativa de hacer un cursor usando WHILE loop

-- Creamos una tabla temporal
CREATE TABLE #ActiveCustomer (
 RowID INT IDENTITY(1, 1), 
 CustomerID INT,
 CustomerName NVARCHAR(100),
 PostalPostalCode NVARCHAR(10)
)
DECLARE @NumberRecords INT, @RowCount INT
DECLARE @CustomerID INT, @CustomerName NVARCHAR(100), @PostalPostalCode NVARCHAR(10)

--Insertamos el conjunto de resultado en la tabla temporal
INSERT INTO #ActiveCustomer (CustomerID, CustomerName, PostalPostalCode)
--Realizamos la consulta
 SELECT CustomerID, CustomerName, PostalPostalCode 
 FROM Sales.Customers
 WHERE CustomerCategoryID = 4

--Obtenemos el número de registros de la tabla temporal
SET @NumberRecords = @@ROWCOUNT
SET @RowCount = 1

--Recorremos los registros en la tabla temporal
--Usamos el constructor WHILE LOOP
WHILE @RowCount <= @NumberRecords
BEGIN
 SELECT @CustomerID = CustomerID, @CustomerName = CustomerName, @PostalPostalCode = PostalPostalCode 
 FROM #ActiveCustomer
 WHERE RowID = @RowCount
 --Podríamos ejecutar un procedimiento o interactuar con las variables a nuestro beneficio
 --EXEC MyStoredProc @CustomerID, @CustomerName, @PostalPostalCode

 SET @RowCount = @RowCount + 1
END
--Tenemos la misma funcionalidad que el primer ejemplo pero sin usar un cursor. 
--Esto nos brinda los beneficios de que la tabla no está bloqueada 
--También tendremos un script SQL operativo más rápido al evitar cursores que son lentos
--Muy ocasionalmente un cursor ofrece  mejor rendimiento que un método alternativo
--Recuerde que el tiempo de ejecución del script no es lo único que se debe verificar,
--el impacto en las consultas que otros usuarios ejecutan al mismo tiempo también es un factor clave.