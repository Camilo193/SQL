--Habilitamos el CT para nuestra base de datos
USE master
GO
ALTER DATABASE WideWorldImporters
SET CHANGE_TRACKING = ON
(CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON)
GO
--------------------------------------------------------------------------------
--Usamos nuestra base de datos
USE WideWorldImporters
GO
--Habilitamos CT PARA UNA TABLA (Debe tener clave primaria o lanzará un error)
ALTER TABLE Application.PaymentMethods
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = ON)
GO
--------------------------------------------------------------------------------
USE WideWorldImporters
GO
--Insertamos nuevos valores a la tabla
INSERT INTO Application.PaymentMethods
           (PaymentMethodID
           ,PaymentMethodName
           ,LastEditedBy)
     VALUES
           (5,'Paypal', 1)
		   ,(6, 'BBVA', 1)
		   ,(7,'CoinDesk',1)
GO
--------------------------------------------------------------------------------
--Observamos el seguimiento de cambios registrados
SELECT * FROM CHANGETABLE 
(CHANGES Application.PaymentMethods,0) as CT ORDER BY SYS_CHANGE_VERSION
GO
--------------------------------------------------------------------------------
--Para obtener el registro insertado completo
--Unimos la función CHANGETABLE con la tabla de origen
SELECT CT.SYS_CHANGE_VERSION, 
  CT.SYS_CHANGE_OPERATION, EM.* 
  FROM CHANGETABLE 
(CHANGES Application.PaymentMethods,0) as CT 
JOIN Application.PaymentMethods EM
ON CT.PaymentMethodID = EM.PaymentMethodID
ORDER BY SYS_CHANGE_VERSION
--------------------------------------------------------------------------------
--Actualizamos un registro
UPDATE Application.PaymentMethods
SET PaymentMethodName = 'Bitcoin'
WHERE PaymentMethodID = 7
GO
--------------------------------------------------------------------------------
--Ejecutando la consulta anterior vemos que el registro que actualizamos
--cambio su SYS_CHANGE_VERSION por 2.
--Registrará la última versión del cambio que se realiza en esa fila
SELECT CT.SYS_CHANGE_VERSION, 
  CT.SYS_CHANGE_OPERATION, EM.* 
  FROM CHANGETABLE 
(CHANGES Application.PaymentMethods,0) as CT 
JOIN Application.PaymentMethods EM
ON CT.PaymentMethodID = EM.PaymentMethodID
ORDER BY SYS_CHANGE_VERSION
GO
--------------------------------------------------------------------------------
--Eliminamos un registro
DELETE FROM Application.PaymentMethods
WHERE PaymentMethodID = 7
GO
--------------------------------------------------------------------------------
--Ejecutamos la consulta vemos que no muestro los registros eliminados
--porque ya no hacen parte de la tabla original
SELECT CT.SYS_CHANGE_VERSION, 
  CT.SYS_CHANGE_OPERATION, EM.* 
  FROM CHANGETABLE 
(CHANGES Application.PaymentMethods,0) as CT 
JOIN Application.PaymentMethods EM
ON CT.PaymentMethodID = EM.PaymentMethodID
ORDER BY SYS_CHANGE_VERSION
GO
--------------------------------------------------------------------------------
--Pero con un LEFT JOIN podremos ver el dato eliminado
SELECT CT.SYS_CHANGE_VERSION, 
  CT.SYS_CHANGE_OPERATION, EM.* 
  FROM CHANGETABLE 
(CHANGES Application.PaymentMethods,0) as CT 
LEFT JOIN Application.PaymentMethods EM
ON CT.PaymentMethodID = EM.PaymentMethodID
ORDER BY SYS_CHANGE_VERSION
GO
--------------------------------------------------------------------------------
--Usamos nuestra base de datos
USE WideWorldImporters
GO
--Deshabilitamos CT PARA UNA TABLA (Debe tener clave primaria o lanzará un error)
ALTER TABLE Application.Cities
DISABLE CHANGE_TRACKING
GO
--------------------------------------------------------------------------------
--Deshabilitamos el CT para nuestra base de datos
USE master
GO
ALTER DATABASE WideWorldImporters
SET CHANGE_TRACKING = OFF
GO