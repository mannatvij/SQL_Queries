DROP PROCEDURE IF EXISTS InsertOrderDetails;
GO

CREATE PROCEDURE InsertOrderDetails
    @OrderID NVARCHAR(20),
    @ProductID INT,
    @Quantity SMALLINT,
    @UnitPrice MONEY = NULL,
    @DiscountPct FLOAT = 0
AS
BEGIN
    DECLARE @AvailableUnits INT
    DECLARE @ReorderPoint INT
    DECLARE @FinalUnitPrice MONEY
    DECLARE @OrderDateKey INT = 20250530 
    DECLARE @DueDateKey INT = 20250610
    DECLARE @ShipDateKey INT = 20250605
    DECLARE @DiscountAmount MONEY
    DECLARE @ProductStandardCost MONEY

    -- 1. Get inventory balance from FactProductInventory
    SELECT TOP 1 
        @AvailableUnits = UnitsBalance
    FROM dbo.FactProductInventory
    WHERE ProductKey = @ProductID
    ORDER BY DateKey DESC;

    -- 2. Get product price info from DimProduct
    SELECT 
        @ReorderPoint = ReorderPoint,
        @FinalUnitPrice = ISNULL(@UnitPrice, ListPrice),
        @ProductStandardCost = StandardCost
    FROM dbo.DimProduct
    WHERE ProductKey = @ProductID;

    -- 3. Check stock availability
    IF @AvailableUnits IS NULL OR @AvailableUnits < @Quantity
    BEGIN
        PRINT ' Not enough stock. Order cannot be placed.';
        RETURN;
    END

    -- 4. Calculate discount amount
    SET @DiscountAmount = @FinalUnitPrice * @Quantity * @DiscountPct;

    -- 5. Insert into FactInternetSales
    INSERT INTO dbo.FactInternetSales (
        ProductKey, OrderDateKey, DueDateKey, ShipDateKey,
        SalesOrderNumber, OrderQuantity, UnitPrice, UnitPriceDiscountPct,
        DiscountAmount, ProductStandardCost, TotalProductCost
    )
    VALUES (
        @ProductID, @OrderDateKey, @DueDateKey, @ShipDateKey,
        @OrderID, @Quantity, @FinalUnitPrice, @DiscountPct,
        @DiscountAmount, @ProductStandardCost, @ProductStandardCost * @Quantity
    );

    -- 6. Print success
    PRINT ' Order placed successfully!';

    -- 7. Reorder warning
    IF (@AvailableUnits - @Quantity) < @ReorderPoint
    BEGIN
        PRINT ' Reorder alert: Stock is below reorder point.';
    END
END;
GO
EXEC InsertOrderDetails 
    @OrderID = 'SO9999', 
    @ProductID = 214, 
    @Quantity = 5, 
    @UnitPrice = NULL,       -- use default list price
    @DiscountPct = 0.10;  