DROP PROCEDURE IF EXISTS [Sales].[SP_GetOrderLines]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Sales].[SP_GetOrderLines]
AS BEGIN

    -- Ensures that the next sequence values are above the maximum value of the related table columns
    SET NOCOUNT ON;

	SELECT * FROM Sales.OrderLines 

END;
GO


--Exec [Sales].[SP_GetOrderLines] 
 
