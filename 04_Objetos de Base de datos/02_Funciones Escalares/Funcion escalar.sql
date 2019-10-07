
-- Creamos una función que devuelve el último día del mes anterior

CREATE FUNCTION dbo.EndOfPreviousMonth (@DateToTest date)
RETURNS date
AS BEGIN
  RETURN EOMONTH ( dateadd(month, -1, @DateToTest ));
END;
GO

--------------------------------------------------------------------
--Ejecutamos la función escalar
SELECT dbo.EndOfPreviousMonth(SYSDATETIME());
SELECT dbo.EndOfPreviousMonth('2017-03-01');
GO
--------------------------------------------------------------------
--Verificamos si la función es deterministica
SELECT OBJECTPROPERTY(OBJECT_ID('dbo.EndOfPreviousMonth'),'IsDeterministic');
GO
--------------------------------------------------------------------
--Funcion escalar ODBC
CREATE FUNCTION dbo.ODBCudf  
    (  
    @string_exp nvarchar(4000)  
    )  
RETURNS int  
AS  
BEGIN  
DECLARE @len int  
SET @len = (SELECT {fn OCTET_LENGTH( @string_exp )})  -- Devuelve el número de bytes 
RETURN(@len)  
END ;  
GO
--------------------------------------------------------------------
--Ejecutamos
SELECT dbo.ODBCudf('Returns the length.');
--------------------------------------------------------------------
