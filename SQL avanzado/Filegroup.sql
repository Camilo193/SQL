---------------------------------------------------------------------------------
--Importamos master
USE master;
GO

---------------------------------------------------------------------------------
--Creamos filegroups
-- Agregamos el FileGroup1
ALTER DATABASE WideWorldImporters
ADD FILEGROUP FileGroup1;
GO
---------------------------------------------------------------------------------
ALTER DATABASE WideWorldImporters 
ADD FILE 
(
    NAME = WideWorldImporters,
    FILENAME = 'D:\MSSQL\Data\WideWorldImporters1.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup1;
---------------------------------------------------------------------------------
-- Agregamos el  FileGroup2
ALTER DATABASE WideWorldImporters
ADD FILEGROUP FileGroup2;
GO
---------------------------------------------------------------------------------
ALTER DATABASE WideWorldImporters 
ADD FILE 
(
    NAME = WideWorldImporters,
    FILENAME = 'D:\MSSQL\Data\WideWorldImporters1.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup2;
---------------------------------------------------------------------------------
-- Agregamos el FileGroup3
ALTER DATABASE WideWorldImporters
ADD FILEGROUP FileGroup3;
GO
---------------------------------------------------------------------------------
ALTER DATABASE WideWorldImporters 
ADD FILE 
(
    NAME = WideWorldImporters,
    FILENAME = 'D:\MSSQL\Data\WideWorldImporters1.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup3;
---------------------------------------------------------------------------------
--Agregamos el FileGroup4
ALTER DATABASE WideWorldImporters
ADD FILEGROUP FileGroup4;
GO
---------------------------------------------------------------------------------
ALTER DATABASE WideWorldImporters 
ADD FILE 
(
    NAME = WideWorldImporters,
    FILENAME = 'D:\MSSQL\Data\WideWorldImporters1.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup4;
---------------------------------------------------------------------------------
--Importamos la base de datos
USE WideWorldImporters;
GO
---------------------------------------------------------------------------------
-- Creamos una función de partición
--En este ejemplo vamos a utilizar RANGE LEFT
CREATE PARTITION FUNCTION YearlyPartitionFunction (datetime) 
AS RANGE LEFT 
FOR VALUES ('2011-12-31 00:00:00.000', '2012-12-31 00:00:00.000',  '2013-12-31 00:00:00.000');
GO

---------------------------------------------------------------------------------
-- Creamos un esquema de partición
CREATE PARTITION SCHEME OrdersByYear 
AS PARTITION YearlyPartitionFunction 
TO (FileGroup1, FileGroup2, FileGroup3, FileGroup4);
GO
---------------------------------------------------------------------------------
-- Creamos una tabla particionada
--Usamos la particion y el esquema seleccionando TransactionOccurredWhen
CREATE TABLE Warehouse.StockItemTransactions_Partitioned(
	StockItemTransactionID int NOT NULL,
	StockItemID int NOT NULL,
	TransactionTypeID int NOT NULL,
	CustomerID int NULL,
	InvoiceID int NULL,
	SupplierID int NULL,
	PurchaseOrderID int NULL,
	TransactionOccurredWhen datetime2(7) NOT NULL,
	Quantity decimal(18, 3) NOT NULL,
	LastEditedBy int NOT NULL,
	LastEditedWhen datetime2(7) NOT NULL
)
-- Filegroup scheme
ON OrdersByYear(TransactionOccurredWhen);
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Copiamos la información en la tabla particionada
INSERT INTO Warehouse.StockItemTransactions_Partitioned
		(StockItemTransactionID, StockItemID, TransactionTypeID, CustomerID, InvoiceID, SupplierID, PurchaseOrderID, 
		TransactionOccurredWhen, Quantity, LastEditedBy, LastEditedWhen)
SELECT	StockItemTransactionID, StockItemID, TransactionTypeID, CustomerID, InvoiceID, SupplierID, PurchaseOrderID, 
		TransactionOccurredWhen, Quantity, LastEditedBy, LastEditedWhen
FROM	 Warehouse.StockItemTransactions
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mostramos la distribución de filas en la partición
--Contamos el numero de filas por año
SELECT	DISTINCT DATEPART(YEAR, TransactionOccurredWhen) AS [Year], COUNT(*) AS TotalOrders
FROM	Warehouse.StockItemTransactions_Partitioned
GROUP	BY DATEPART(YEAR, TransactionOccurredWhen)
ORDER	BY 1
---------------------------------------------------------------------------------
--Contamos el número de filas por particion, el número debe ser el mismo
SELECT	s.name AS SchemaName,
		t.name AS TableName,
		COALESCE(f.name, d.name) AS [FileGroup], 
		SUM(p.rows) AS [RowCount],
		SUM(a.total_pages) AS DataPages
FROM	sys.tables AS t
INNER	JOIN sys.indexes AS i ON i.object_id = t.object_id
INNER	JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id = i.index_id
INNER	JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
INNER	JOIN sys.schemas AS s ON s.schema_id = t.schema_id
LEFT	JOIN sys.filegroups AS f ON f.data_space_id = i.data_space_id
LEFT	JOIN sys.destination_data_spaces AS dds ON dds.partition_scheme_id = i.data_space_id AND dds.destination_id = p.partition_number
LEFT	JOIN sys.filegroups AS d ON d.data_space_id = dds.data_space_id
WHERE	t.[type] = 'U' AND i.index_id IN (0, 1) AND t.name LIKE 'SalesOrderHeader_Partitioned'
GROUP	BY s.NAME, COALESCE(f.NAME, d.NAME), t.NAME, t.object_id
ORDER	BY t.name
---------------------------------------------------------------------------------
