USE InsuranceCompany;
GO

-- Random Number - cannot use RAND() inside functions directly, move later to VehicleTablesInit.sql
DROP VIEW RANDOM_NUMBER_VIEW
GO
CREATE VIEW RANDOM_NUMBER_VIEW
AS
SELECT RAND() AS RANDOM_NUMBER;
GO

-- RandomNumber
DROP FUNCTION RANDOM_NUMBER
GO
CREATE FUNCTION RANDOM_NUMBER(@from int, @to int)
RETURNS INT
BEGIN
    RETURN FLOOR((SELECT RANDOM_NUMBER FROM RANDOM_NUMBER_VIEW)*(@from - @to + 1) + @to)
END
GO
-- Random Year used in VehicleModel
DROP FUNCTION RANDOM_YEAR
GO
CREATE FUNCTION RANDOM_YEAR(@begin int, @end int)
RETURNS DATE
BEGIN
    DECLARE @numberYear int;
    SET @numberYear = dbo.RANDOM_NUMBER(@begin, @end)
    RETURN CAST( CONCAT('1/1/', @numberYear) as [date])
END
GO
-- LifeRiskType
CREATE TYPE LifeRisk AS TABLE
(pesel VARCHAR(11))
GO
-- BirthDateFromPesel
DROP FUNCTION BIRTHDATE_FROM_PESEL
GO
CREATE FUNCTION BIRTHDATE_FROM_PESEL(@pesel VARCHAR(11))
RETURNS DATE
BEGIN
    DECLARE @yearNumber int, @year VARCHAR(4), @month VARCHAR(2), @day VARCHAR(2);
    DECLARE @currentYear int;
    SET @currentYear = YEAR(GETDATE()) - 2000;
    SET @yearNumber = CAST(SUBSTRING(@pesel, 1, 2) AS INT);
    IF @currentYear - @yearNumber < 0
        SET @year = CONCAT('19', @yearNumber);
    ELSE 
        SET @year = CONCAT('20', @yearNumber);
    -- pesel po 2000 do miesiąca dodaje się 20 np. maj = 25
    SET @month = SUBSTRING(@pesel, 3, 2);
    SET @day = SUBSTRING(@pesel, 5, 2);
    DECLARE @resultStr VARCHAR(20);
    SET @resultStr = CONCAT_WS('/', @month, @day, @year);
    RETURN CAST( @resultStr AS DATE);
END
GO
DROP FUNCTION CALC_BASE_PREMIUM
GO
-- Calculates base premium based on frequency, insurance period and sum insured, without commission, precision 4 decimal
CREATE FUNCTION CALC_BASE_PREMIUM(@su money, @insurancePeriod int, @frequency int)
RETURNS MONEY
BEGIN
    RETURN @su / (@insurancePeriod * @frequency);
END
GO
-- CalcLifePremium IMPORTANT you have to add DEFAULT keyword for params with default values (frequency)
DROP FUNCTION CALC_LIFE_PREMIUM
GO
CREATE FUNCTION CALC_LIFE_PREMIUM(@pesel VARCHAR(11), @insurancePeriod int, @su money, @hazardousOccupation bit, @frequency int = 12)
RETURNS MONEY
BEGIN
    DECLARE @age int;
    SET @age = DATEDIFF(YEAR, dbo.BIRTHDATE_FROM_PESEL(@pesel), GETDATE());
    RETURN dbo.CALC_BASE_PREMIUM(@su, @insurancePeriod, @frequency);
END
GO
