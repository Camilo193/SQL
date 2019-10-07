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
-- Realizar esta acci�n hasta que no se encuentren m�s filas
WHILE @@FETCH_STATUS = 0
BEGIN
 -- Obtenemos la siguiente fila del cursor
 FETCH NEXT FROM SupermarketCustomers INTO @CustomerID, @CustomerName, @PostalPostalCode
 --Podr�amos ejecutar un procedimiento o interactuar con las variables a nuestro beneficio
 --EXEC MyStoredProc @CustomerID, @CustomerName, @PostalPostalCode
 
END
--Mostramos el �ltimo dato asignado a las variables
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

--Obtenemos el n�mero de registros de la tabla temporal
SET @NumberRecords = @@ROWCOUNT
SET @RowCount = 1

--Recorremos los registros en la tabla temporal
--Usamos el constructor WHILE LOOP
WHILE @RowCount <= @NumberRecords
BEGIN
 SELECT @CustomerID = CustomerID, @CustomerName = CustomerName, @PostalPostalCode = PostalPostalCode 
 FROM #ActiveCustomer
 WHERE RowID = @RowCount
 --Podr�amos ejecutar un procedimiento o interactuar con las variables a nuestro beneficio
 --EXEC MyStoredProc @CustomerID, @CustomerName, @PostalPostalCode

 SET @RowCount = @RowCount + 1
END
--Tenemos la misma funcionalidad que el primer ejemplo pero sin usar un cursor. 
--Esto nos brinda los beneficios de que la tabla no est� bloqueada 
--Tambi�n tendremos un script SQL operativo m�s r�pido al evitar cursores que son lentos
--Muy ocasionalmente un cursor ofrece  mejor rendimiento que un m�todo alternativo
--Recuerde que el tiempo de ejecuci�n del script no es lo �nico que se debe verificar,
--el impacto en las consultas que otros usuarios ejecutan al mismo tiempo tambi�n es un factor clave.