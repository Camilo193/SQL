USE WideWorldImporters
GO
--Procedimiento para ejemplos de objetos nativos
-----------------------------------------------------------------------------
CREATE PROCEDURE dbo.GetTransaction
AS
BEGIN
	SET NOCOUNT OFF;
	SELECT TOP 1 * 
	FROM Warehouse.StockItemTransactions
END
-----------------------------------------------------------------------------
--Después de ejecutar ExecuteScalar.cs hacemos la siguiente consulta
--para validar que efectivamente se inserto el dato.
SELECT *
FROM Application.PaymentMethods
WHERE PaymentMethodName = 'Redeban'
-----------------------------------------------------------------------------
--Agregamos 3 registros que luego vamos a eliminar para ver el resultado
--con ExecuteNonQuery
INSERT INTO Application.PaymentMethods (PaymentMethodName, LastEditedBy) 
VALUES ('Redebancos', 2);

INSERT INTO Application.PaymentMethods (PaymentMethodName, LastEditedBy) 
VALUES ('Paypal', 2);

INSERT INTO Application.PaymentMethods (PaymentMethodName, LastEditedBy) 
VALUES ('Bitcoin', 2);
-----------------------------------------------------------------------------
----Miramos que efectivamente inbsertó
SELECT *  
FROM Application.PaymentMethods
-----------------------------------------------------------------------------
CREATE PROCEDURE DeleteAdviserPaymentMethods
AS
BEGIN
	SET NOCOUNT OFF; --Importante para mostar la salida en ExecuteNonQuery
	DELETE 
	FROM Application.PaymentMethods
	WHERE LastEditedBy = 2
END

--Ejecutamos este procedimiento en C# para ver las salidas
-----------------------------------------------------------------------------
--Verificamos que efectivamente eliminó los datos luego de ejecutar ExecuteNonQueryx.cs
SELECT *  
FROM Application.PaymentMethods


