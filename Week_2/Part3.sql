ALTER PROCEDURE GetOrderDetails
    @OrderID NVARCHAR(25)
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM dbo.FactInternetSales 
        WHERE SalesOrderNumber = @OrderID
    )
    BEGIN
        SELECT *
        FROM dbo.FactInternetSales 
        WHERE SalesOrderNumber = @OrderID;
    END
    ELSE
    BEGIN
        PRINT 'The OrderID ' + @OrderID + ' does not exist';
        RETURN 1;
    END
END;
EXEC GetOrderDetails @OrderID = 'SO43700'; 

