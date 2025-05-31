CREATE PROCEDURE DeleteOrderDetails
    @OrderID NVARCHAR(20),
    @ProductID INT
AS
BEGIN
    -- Check if the OrderID exists
    IF NOT EXISTS (
        SELECT 1 FROM dbo.FactInternetSales WHERE SalesOrderNumber = @OrderID
    )
    BEGIN
        PRINT 'Error: Order ID ' + @OrderID + ' does not exist.';
        RETURN -1;
    END

    -- Check if the ProductID exists for that order
    IF NOT EXISTS (
        SELECT 1 FROM dbo.FactInternetSales 
        WHERE SalesOrderNumber = @OrderID AND ProductKey = @ProductID
    )
    BEGIN
        PRINT 'Error: Product ID ' + CAST(@ProductID AS NVARCHAR) + 
              ' does not exist for Order ID ' + @OrderID + '.';
        RETURN -1;
    END

    -- Delete the matching record
    DELETE FROM dbo.FactInternetSales
    WHERE SalesOrderNumber = @OrderID AND ProductKey = @ProductID;

    PRINT 'Record deleted successfully.';
END;
SELECT TOP 10 SalesOrderNumber, OrderDate, ProductKey, OrderQuantity, UnitPrice, SalesAmount
FROM dbo.FactInternetSales;
EXEC DeleteOrderDetails @OrderID = 'SO43699', @ProductID = 346;
