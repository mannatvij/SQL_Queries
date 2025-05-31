-- TRIGGER 1: Instead of Delete trigger on FactInternetSales table
-- This trigger handles cascading deletes when removing sales records
-- Note: In Adventure Works, we don't have traditional Orders/OrderDetails structure
-- So this trigger will delete related sales reason records when deleting a sale

CREATE TRIGGER trg_DeleteInternetSale
ON FactInternetSales
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Declare variables to store keys being deleted
    DECLARE @SalesOrderNumber NVARCHAR(20);
    DECLARE @SalesOrderLineNumber INT;
    
    -- Cursor to handle multiple sales being deleted
    DECLARE sales_cursor CURSOR FOR
    SELECT SalesOrderNumber, SalesOrderLineNumber FROM deleted;
    
    OPEN sales_cursor;
    FETCH NEXT FROM sales_cursor INTO @SalesOrderNumber, @SalesOrderLineNumber;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- First delete related records from FactInternetSalesReason table
        DELETE FROM FactInternetSalesReason 
        WHERE SalesOrderNumber = @SalesOrderNumber 
        AND SalesOrderLineNumber = @SalesOrderLineNumber;
        
        -- Then delete the sale from FactInternetSales table
        DELETE FROM FactInternetSales 
        WHERE SalesOrderNumber = @SalesOrderNumber 
        AND SalesOrderLineNumber = @SalesOrderLineNumber;
        
        FETCH NEXT FROM sales_cursor INTO @SalesOrderNumber, @SalesOrderLineNumber;
    END
    
    CLOSE sales_cursor;
    DEALLOCATE sales_cursor;
    
    PRINT 'Internet sale(s) and related sales reason records deleted successfully.';
END;
GO