DROP FUNCTION IF EXISTS dbo.FormatDatePretty;
GO

CREATE FUNCTION dbo.FormatDatePretty
(
    @InputDate DATETIME
)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @FormattedDate VARCHAR(10)

    SET @FormattedDate = RIGHT('0' + CAST(MONTH(@InputDate) AS VARCHAR), 2) + '/' +
                         RIGHT('0' + CAST(DAY(@InputDate) AS VARCHAR), 2) + '/' +
                         CAST(YEAR(@InputDate) AS VARCHAR)

    RETURN @FormattedDate
END;
GO
SELECT dbo.FormatDatePretty('2006-11-21 23:34:05.920') AS FormattedDate;