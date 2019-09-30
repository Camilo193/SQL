------------------------------------------------------
USE WideWorldImporters
GO
------------------------------------------------------
-- Verifique que el procedimiento almacenado no exista.
IF OBJECT_ID ( 'GetErrorInfo', 'P' ) IS NOT NULL   
    DROP PROCEDURE GetErrorInfo;  
GO  
------------------------------------------------------
-- Crear procedimiento para recuperar información de error.  
CREATE PROCEDURE GetErrorInfo  
AS  
SELECT  
--Retorna el número del error
    ERROR_NUMBER() AS ErrorNumber
--Retorna la severidad del error
    ,ERROR_SEVERITY() AS ErrorSeverity
--Retorna el estado del número del error
    ,ERROR_STATE() AS ErrorState
--Retorna el nombre del procedimiento almacenado o trigger donde ocurrió el error.
    ,ERROR_PROCEDURE() AS ErrorProcedure  
--Retorna el número de línea dentro de la rutina que causó el error
    ,ERROR_LINE() AS ErrorLine  
--Retorna el texto completo del mensaje de error. El texto incluye los valores 
--suministrados para cualquier parámetro sustituible, como longitudes, nombres de objetos u horas.
    ,ERROR_MESSAGE() AS ErrorMessage;  
GO 
------------------------------------------------------
  
------------------------------------------------------
BEGIN TRY  
    -- Generamos un error de división por cero.  
    SELECT 1/0;  
END TRY  
BEGIN CATCH  
    -- Ejecutamos el método 
    EXECUTE GetErrorInfo;  
END CATCH;
GO
------------------------------------------------------

-- SET XACT_ABORT ON hará que la transacción no sea confirmable  
-- cuando haya una violación de constraint.   
SET XACT_ABORT ON;
GO
------------------------------------------------------
--Ejecutamos esta transacción
BEGIN TRY  
    BEGIN TRANSACTION;  
        -- Hay una restricción de FOREIGN KEY.
        -- esto generará un constraint violation error.  
        DELETE FROM Warehouse.StockItemHoldings  
            WHERE StockItemID = 199;  
    -- Si el DELETE tiene exito, la transacción se confirma.  
    COMMIT TRANSACTION;  
END TRY
BEGIN CATCH  
    -- Ejecutamos el método para obtener información de errores  
    EXECUTE GetErrorInfo;  
  
    -- Probando XACT_STATE:  
        -- If 1, la transacción es confirmable.  
        -- If -1, la transacción no es confirmable y debe ser deshecha (ROLL BACK)  
        -- XACT_STATE = 0 significa que no hay una transacción y  
        --    COMMIT o ROLLBACK deberian generar error.
  
    -- Probando si el estado es -1.  
    IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT  
            N'The transaction is in an uncommittable state.' +  
            'Rolling back transaction.'  
        ROLLBACK TRANSACTION;  
    END;  
  
    -- Probando si el estado es 1.  
    IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT  
            N'The transaction is committable.' +  
            'Committing transaction.'  
        COMMIT TRANSACTION;     
    END;  
END CATCH;  
GO
------------------------------------------------------
