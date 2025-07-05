--Create Table
IF OBJECT_ID('Customer_Dim', 'U') IS NOT NULL
    DROP TABLE Customer_Dim;
GO
CREATE TABLE Customer_Dim (
    CustomerID INT,
    Name VARCHAR(100),
    Address VARCHAR(255),
    CurrentFlag BIT,              -- For SCD2 & 6
    StartDate DATE,               -- For SCD2 & 6
    EndDate DATE,                 -- For SCD2 & 6
    PreviousAddress VARCHAR(255),-- For SCD3 & 6
    PRIMARY KEY (CustomerID, StartDate) -- supports multiple versions in Type 2
);
GO

--Procedure Type 0
IF OBJECT_ID('Update_SCD0', 'P') IS NOT NULL
    DROP PROCEDURE Update_SCD0;
GO
CREATE PROCEDURE Update_SCD0
    @CustomerID INT,
    @Name VARCHAR(100),
    @Address VARCHAR(255)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Customer_Dim 
        WHERE CustomerID = @CustomerID 
              AND (Name != @Name OR Address != @Address)
    )
    BEGIN
        RAISERROR('SCD Type 0: Changes not allowed.', 16, 1);
    END
END
GO

--Procedure Type 1
IF OBJECT_ID('Update_SCD1', 'P') IS NOT NULL
    DROP PROCEDURE Update_SCD1;
GO
CREATE PROCEDURE Update_SCD1
    @CustomerID INT,
    @Name VARCHAR(100),
    @Address VARCHAR(255)
AS
BEGIN
    UPDATE Customer_Dim
    SET Name = @Name,
        Address = @Address
    WHERE CustomerID = @CustomerID;
END
GO

--Prodecure type 2
IF OBJECT_ID('Update_SCD2', 'P') IS NOT NULL
    DROP PROCEDURE Update_SCD2;
GO
CREATE PROCEDURE Update_SCD2
    @CustomerID INT,
    @Name VARCHAR(100),
    @Address VARCHAR(255)
AS
BEGIN
    DECLARE @Today DATE = GETDATE();
    IF EXISTS (
        SELECT 1 FROM Customer_Dim 
        WHERE CustomerID = @CustomerID AND CurrentFlag = 1 
              AND (Name != @Name OR Address != @Address)
    )
    BEGIN
        -- Expire current version
        UPDATE Customer_Dim
        SET CurrentFlag = 0,
            EndDate = @Today
        WHERE CustomerID = @CustomerID AND CurrentFlag = 1;

        -- Insert new version
        INSERT INTO Customer_Dim (CustomerID, Name, Address, CurrentFlag, StartDate, EndDate)
        VALUES (@CustomerID, @Name, @Address, 1, @Today, NULL);
    END
END
GO

--Procedure Type 3
IF OBJECT_ID('Update_SCD3', 'P') IS NOT NULL
    DROP PROCEDURE Update_SCD3;
GO
CREATE PROCEDURE Update_SCD3
    @CustomerID INT,
    @NewAddress VARCHAR(255)
AS
BEGIN
    UPDATE Customer_Dim
    SET PreviousAddress = Address,
        Address = @NewAddress
    WHERE CustomerID = @CustomerID;
END
GO

--Procedure type 4
IF OBJECT_ID('Customer_Dim_History', 'U') IS NOT NULL
    DROP TABLE Customer_Dim_History;
GO
CREATE TABLE Customer_Dim_History (
    CustomerID INT,
    Name VARCHAR(100),
    Address VARCHAR(255),
    ChangeDate DATE
);
GO

IF OBJECT_ID('Update_SCD4', 'P') IS NOT NULL
    DROP PROCEDURE Update_SCD4;
GO
CREATE PROCEDURE Update_SCD4
    @CustomerID INT,
    @Name VARCHAR(100),
    @Address VARCHAR(255)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Customer_Dim 
        WHERE CustomerID = @CustomerID 
              AND (Name != @Name OR Address != @Address)
    )
    BEGIN
        -- Archive current record
        INSERT INTO Customer_Dim_History (CustomerID, Name, Address, ChangeDate)
        SELECT CustomerID, Name, Address, GETDATE()
        FROM Customer_Dim
        WHERE CustomerID = @CustomerID;

        -- Overwrite current
        UPDATE Customer_Dim
        SET Name = @Name,
            Address = @Address
        WHERE CustomerID = @CustomerID;
    END
END
GO

IF OBJECT_ID('Update_SCD6', 'P') IS NOT NULL
    DROP PROCEDURE Update_SCD6;
GO

--Procedure type 6
CREATE PROCEDURE Update_SCD6
    @CustomerID INT,
    @Name VARCHAR(100),
    @Address VARCHAR(255)
AS
BEGIN
    DECLARE @Today DATE = GETDATE();

    IF EXISTS (
        SELECT 1 FROM Customer_Dim 
        WHERE CustomerID = @CustomerID 
              AND CurrentFlag = 1 
              AND (Name != @Name OR Address != @Address)
    )
    BEGIN
        -- Expire old version
        UPDATE Customer_Dim
        SET CurrentFlag = 0,
            EndDate = @Today
        WHERE CustomerID = @CustomerID AND CurrentFlag = 1;

        -- Insert new version with PreviousAddress
        DECLARE @OldAddress VARCHAR(255) = (
            SELECT TOP 1 Address FROM Customer_Dim 
            WHERE CustomerID = @CustomerID AND EndDate = @Today
        );

        INSERT INTO Customer_Dim (
            CustomerID, Name, Address, PreviousAddress,
            CurrentFlag, StartDate, EndDate
        )
        VALUES (
            @CustomerID, @Name, @Address, @OldAddress,
            1, @Today, NULL
        );
    END
END
GO
INSERT INTO Customer_Dim (CustomerID, Name, Address, CurrentFlag, StartDate, EndDate)
VALUES (1, 'Alice', 'Wonderland', 1, '2024-01-01', NULL);
GO

--To select all. 
SELECT * FROM Customer_Dim;

--To Check type 0 changes. 
EXEC Update_SCD0 @CustomerID = 1, @Name = 'Alicia', @Address = 'Newland';

--To check Type 1 Overwrite.
EXEC Update_SCD1 @CustomerID = 1, @Name = 'Alicia', @Address = 'Newland';
SELECT * FROM Customer_Dim;

--Type 2 Insert new row.
EXEC Update_SCD2 @CustomerID = 1, @Name = 'Alice', @Address = 'Oldtown';
SELECT * FROM Customer_Dim ORDER BY StartDate;

--Type 3 track previous address
EXEC Update_SCD3 @CustomerID = 1, @NewAddress = 'Moonbase Alpha';
SELECT * FROM Customer_Dim;

--Type 4 Insert to history table
EXEC Update_SCD4 @CustomerID = 1, @Name = 'Queen Alice', @Address = 'Wonder Palace';
SELECT * FROM Customer_Dim;
SELECT * FROM Customer_Dim_History;

--Type 6 Hybrid
EXEC Update_SCD6 @CustomerID = 1, @Name = 'Alice Prime', @Address = 'New Earth';
SELECT * FROM Customer_Dim;