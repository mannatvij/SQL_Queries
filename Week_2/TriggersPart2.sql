
CREATE TRIGGER trg_CheckInventoryOnSale
ON FactInternetSales
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProductKey INT, @OrderQuantity INT, @AvailableUnits INT, @DateKey INT;
    DECLARE @ErrorMessage NVARCHAR(255);
    
    -- Cursor to check each inserted sales record
    DECLARE inventory_cursor CURSOR FOR
    SELECT ProductKey, OrderQuantity, OrderDateKey FROM inserted;
    
    OPEN inventory_cursor;
    FETCH NEXT FROM inventory_cursor INTO @ProductKey, @OrderQuantity, @DateKey;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get current inventory for the product from FactProductInventory
        -- Using the most recent inventory record for the product
        SELECT TOP 1 @AvailableUnits = UnitsBalance
        FROM FactProductInventory 
        WHERE ProductKey = @ProductKey 
        AND DateKey <= @DateKey
        ORDER BY DateKey DESC;
        
        -- If no inventory record found, assume 0 units
        IF @AvailableUnits IS NULL
            SET @AvailableUnits = 0;
        
        -- Check if sufficient inventory exists
        IF @AvailableUnits < @OrderQuantity
        BEGIN
            -- Insufficient inventory - rollback transaction
            SET @ErrorMessage = 'Insufficient inventory for ProductKey ' + CAST(@ProductKey AS VARCHAR(10)) + 
                              '. Available: ' + CAST(@AvailableUnits AS VARCHAR(10)) + 
                              ', Requested: ' + CAST(@OrderQuantity AS VARCHAR(10));
            
            RAISERROR(@ErrorMessage, 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        ELSE
        BEGIN
            -- Sufficient inventory exists - create/update inventory record
            -- In a real scenario, you might want to insert a new inventory transaction
            -- For this example, we'll update the most recent inventory balance
            
            -- Find the most recent inventory record
            DECLARE @InventoryDateKey INT;
            SELECT TOP 1 @InventoryDateKey = DateKey
            FROM FactProductInventory 
            WHERE ProductKey = @ProductKey 
            ORDER BY DateKey DESC;
            
            -- Update inventory balance (reduce by order quantity)
            IF @InventoryDateKey IS NOT NULL
            BEGIN
                UPDATE FactProductInventory 
                SET UnitsBalance = UnitsBalance - @OrderQuantity
                WHERE ProductKey = @ProductKey 
                AND DateKey = @InventoryDateKey;
            END
            ELSE
            BEGIN
                -- No existing inventory record, this might indicate a data issue
                SET @ErrorMessage = 'No inventory record found for ProductKey ' + CAST(@ProductKey AS VARCHAR(10));
                RAISERROR(@ErrorMessage, 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        FETCH NEXT FROM inventory_cursor INTO @ProductKey, @OrderQuantity, @DateKey;
    END
    
    CLOSE inventory_cursor;
    DEALLOCATE inventory_cursor;
    
    PRINT 'Internet sale processed successfully. Inventory updated.';
END;
GO