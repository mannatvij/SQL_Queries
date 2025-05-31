CREATE FUNCTION dbo.FormatDateYYYYMMDD
(
    @InputDate DATETIME
)
RETURNS VARCHAR(8)
AS
BEGIN
    DECLARE @FormattedDate VARCHAR(8)

    SET @FormattedDate = 
        CAST(YEAR(@InputDate) AS VARCHAR(4)) +
        RIGHT('0' + CAST(MONTH(@InputDate) AS VARCHAR(2)), 2) +
        RIGHT('0' + CAST(DAY(@InputDate) AS VARCHAR(2)), 2)

    RETURN @FormattedDate
END;
SELECT dbo.FormatDateYYYYMMDD('2006-11-21 23:34:05.920') AS FormattedDate;
-- Output: 20061121