
Declare @orderID INT = 4

	
Declare @jsonOutput NVarchar(Max) 

SET @jsonOutput = ISNULL(
					(SELECT * FROM Sales.OrderLines 
					Where OrderID=@orderID
					FOR JSON AUTO), '[]');

--Validacion de JSON Valido
IF (ISJSON(@jsonOutput)=1)
	Select 'Es Valido'
ELSE
	Select 'No Valido'

--Resultado tranformado en formato JSON
Select @jsonOutput as jsonOutput


--El resultado JSON se puede tranformar como tabla nuevamente e incluso almacenarlo

--INSERT INTO <sampleTable>  
SELECT *  
FROM OPENJSON(@jsonOutput) 
WITH (OrderLineID int 'strict $.OrderLineID',
		OrderID	int 'strict $.OrderID',
		StockItemID	int 'strict $.StockItemID',
		Description	nvarchar(200) 'strict $.Description',
		PackageTypeID	int 'strict $.PackageTypeID',
		Quantity	int 'strict $.Quantity',
		UnitPrice	decimal 'strict $.UnitPrice',
		TaxRate	decimal 'strict $.TaxRate',
		PickedQuantity	int 'strict $.PickedQuantity',
		PickingCompletedWhen	datetime2 'strict $.PickingCompletedWhen',
		LastEditedBy	int 'strict $.LastEditedBy',
		LastEditedWhen	datetime2 'strict $.LastEditedWhen'
		)


--Se puede modificar internamente el valor del JSON, Se modifica OrderID y PackageTypeID de los registros en la posicion 1 de la tabla
SET @jsonOutput = JSON_MODIFY(
						JSON_MODIFY(@jsonOutput,'$[1].PackageTypeID',222)
																		,'$[1].OrderID',100);


--resultado modificado 
SELECT * 
FROM OPENJSON(@jsonOutput) 
WITH (OrderLineID int 'strict $.OrderLineID',
		OrderID	int 'strict $.OrderID',
		StockItemID	int 'strict $.StockItemID',
		Description	nvarchar(200) 'strict $.Description',
		PackageTypeID	int 'strict $.PackageTypeID',
		Quantity	int 'strict $.Quantity',
		UnitPrice	decimal 'strict $.UnitPrice',
		TaxRate	decimal 'strict $.TaxRate',
		PickedQuantity	int 'strict $.PickedQuantity',
		PickingCompletedWhen	datetime2 'strict $.PickingCompletedWhen',
		LastEditedBy	int 'strict $.LastEditedBy',
		LastEditedWhen	datetime2 'strict $.LastEditedWhen'
		)
WHERE OrderLineID = CAST( JSON_VALUE(@jsonOutput, '$[1].OrderLineID')  as INT )


--se puede extraer un valor en particular del Json
select JSON_VALUE(@jsonOutput, '$[2].OrderLineID') 


