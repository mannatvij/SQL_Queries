CREATE PROCEDURE PopulateDateAttributes
    @inputDate DATE
AS
BEGIN
    DECLARE @startDate DATE = DATEFROMPARTS(YEAR(@inputDate), 1, 1);
    DECLARE @endDate DATE = DATEFROMPARTS(YEAR(@inputDate), 12, 31);

    INSERT INTO DateDimension (
        SKDate, Date, CalendarYear, CalendarMonth, CalendarQuarter,
        DayName, DayShortName, DayOfWeek, DayOfYear, DaySuffix,
        FiscalYear, FiscalMonth, FiscalQuarter, FiscalWeek,
        FiscalPeriod, FiscalYearPeriod
    )
    SELECT 
        CONVERT(INT, FORMAT(d, 'yyyyMMdd')) AS SKDate,
        d AS Date,
        YEAR(d) AS CalendarYear,
        MONTH(d) AS CalendarMonth,
        DATEPART(QUARTER, d) AS CalendarQuarter,
        DATENAME(WEEKDAY, d) AS DayName,
        LEFT(DATENAME(WEEKDAY, d), 3) AS DayShortName,
        DATEPART(WEEKDAY, d) AS DayOfWeek,
        DATEPART(DAYOFYEAR, d) AS DayOfYear,
        CAST(DAY(d) AS VARCHAR) +
            CASE 
                WHEN DAY(d) IN (11,12,13) THEN 'th'
                WHEN RIGHT(CAST(DAY(d) AS VARCHAR),1) = '1' THEN 'st'
                WHEN RIGHT(CAST(DAY(d) AS VARCHAR),1) = '2' THEN 'nd'
                WHEN RIGHT(CAST(DAY(d) AS VARCHAR),1) = '3' THEN 'rd'
                ELSE 'th'
            END AS DaySuffix,
        YEAR(d) AS FiscalYear,
        MONTH(d) AS FiscalMonth,
        DATEPART(QUARTER, d) AS FiscalQuarter,
        DATEPART(WEEK, d) AS FiscalWeek,
        MONTH(d) AS FiscalPeriod,
        CAST(YEAR(d) AS VARCHAR) + RIGHT('0' + CAST(MONTH(d) AS VARCHAR), 2) AS FiscalYearPeriod
    FROM (
        SELECT DATEADD(DAY, number, @startDate) AS d
        FROM master..spt_values
        WHERE type = 'P' AND number <= DATEDIFF(DAY, @startDate, @endDate)
    ) AS Dates;
END

EXEC PopulateDateAttributes '2020-07-14';
