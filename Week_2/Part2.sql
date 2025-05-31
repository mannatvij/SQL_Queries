-- Drop old version if it exists
IF OBJECT_ID('UpdateOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE UpdateOrderDetails;
GO

CREATE PROCEDURE UpdateOrderDetails
    @SalesOrderNumber NVARCHAR(20),
    @ProductID INT,
    @NewOrderQuantity INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldOrderQuantity INT;
    DECLARE @QuantityDiff INT;
    DECLARE @DateKey INT;

    -- Step 1: Get the old quantity
    SELECT @OldOrderQuantity = OrderQuantity, @DateKey = OrderDateKey
    FROM FactInternetSales
    WHERE SalesOrderNumber = @SalesOrderNumber AND ProductKey = @ProductID;

    -- Step 2: Handle case when no matching order is found
    IF @OldOrderQuantity IS NULL
    BEGIN
        PRINT ' Order not found. Cannot update.';
        RETURN;
    END

    -- Step 3: Calculate the difference
    SET @QuantityDiff = @NewOrderQuantity - @OldOrderQuantity;

    -- Step 4: Update the quantity in FactInternetSales
    UPDATE FactInternetSales
    SET OrderQuantity = @NewOrderQuantity
    WHERE SalesOrderNumber = @SalesOrderNumber AND ProductKey = @ProductID;

    -- Step 5: Check if inventory exists and is valid
    IF EXISTS (
        SELECT 1 FROM FactProductInventory 
        WHERE ProductKey = @ProductID AND DateKey = @DateKey AND UnitsBalance IS NOT NULL
    )
    BEGIN
        -- Step 6: Safely update inventory balance
        UPDATE FactProductInventory
        SET UnitsBalance = UnitsBalance - @QuantityDiff
        WHERE ProductKey = @ProductID AND DateKey = @DateKey;
    END
    ELSE
    BEGIN
        PRINT 'Inventory not updated: No matching inventory record or UnitsBalance is NULL.';
    END

    -- Step 7: Confirmation message
    PRINT ' Order updated successfully!';
END;
GO
EXEC UpdateOrderDetails 
    @SalesOrderNumber = 'SO50995', 
    @ProductID = 709, 
    @NewOrderQuantity = 10;
INSERT INTO dbo.FactProductInventory 
(ProductKey, DateKey, MovementDate, UnitCost, UnitsIn, UnitsOut, UnitsBalance)
VALUES

-- Product 1 inventory movements
(1, 20050101, '2023-01-01', 12.50, 100, 0, 100),
(1, 20050102, '2023-01-02', 12.50, 0, 25, 75),
(1, 20050103, '2023-01-05', 12.75, 50, 0, 125);
EXEC UpdateOrderDetails 
    @SalesOrderNumber = 'SO12345', 
    @ProductID = 101, 
    @NewOrderQuantity = 10;




