DROP PROCEDURE IF EXISTS [dbo].[GetTransaction]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetTransaction]
AS BEGIN

	-- Ensures that the next sequence values are above the maximum value of the related table columns
    SET NOCOUNT ON;


	SELECT TOP(1000) * FROM Warehouse.StockItemTransactions


END;
GO
