--Importamos la base de datos
USE WideWorldImporters
GO
--Creamos una función Multi Statement
--Esta función creara un rango de fechas
CREATE FUNCTION dbo.GetDateRange (@StartDate date, @NumberOfDays int)
RETURNS @DateList TABLE
(Position int, DateValue date)
AS BEGIN
	DECLARE @Counter int = 0;
	WHILE (@Counter < @NumberofDays) BEGIN
		INSERT INTO @DateList
		VALUES (@Counter + 1, DATEADD (day, @Counter, @StartDate));
	SET @Counter += 1;
END;
RETURN;
END;
GO
---------------------------------------------------------------------
--Llamamos la función con una fecha de inicio y con el número de días para el rango
SELECT* FROM dbo.GetDateRange('2010-12-31', 5);
--------------------------------------------------------------------------------------
--Hacemos limpieza
DROP FUNCTION dbo.GetDateRange


