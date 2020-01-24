USE InsuranceCompany;
GO
-- VIEWS used by functions declared in this file
-- Random Number - cannot use RAND() inside functions directly, move later to VehicleTablesInit.sql
DROP VIEW RANDOM_NUMBER_VIEW
GO
CREATE VIEW RANDOM_NUMBER_VIEW
AS
SELECT RAND() AS RANDOM_NUMBER;
GO
DROP VIEW CENTRAL_TASKS
GO
-- Central user id and number of tasks he/she is assigned to
CREATE VIEW CENTRAL_TASKS
AS
    SELECT u.ID as Central_ID, COUNT(t.ID) as NumberOfTasks FROM [User] u
    LEFT JOIN [Task] t ON u.ID = t.Operator_ID
    WHERE u.Character_ID = 'CENTRAL'
    GROUP BY u.ID
GO

-- FUNCTIONS
-- RandomNumber
DROP FUNCTION RANDOM_NUMBER
GO
CREATE FUNCTION RANDOM_NUMBER(@from int, @to int)
RETURNS INT
BEGIN
    RETURN FLOOR((SELECT RANDOM_NUMBER FROM RANDOM_NUMBER_VIEW)*(@from - @to + 1) + @to)
END
GO
-- BirthDateFromPesel
DROP FUNCTION BIRTHDATE_FROM_PESEL
GO
CREATE FUNCTION BIRTHDATE_FROM_PESEL(@pesel VARCHAR(11))
RETURNS DATE
BEGIN
    DECLARE @yearPref VARCHAR(2), @monthNum INT, @yearStr VARCHAR(4), @monthStr VARCHAR(2), @dayStr VARCHAR(2);
    SET @monthNum = CAST(SUBSTRING(@pesel, 3, 2) AS INT);
    IF @monthNum > 12
        BEGIN
            SET @yearPref = '20';
            SET @monthStr = FORMAT(@monthNum - 20,'D2');
        END
    ELSE 
        BEGIN
            SET @yearPref = '19';
            SET @monthStr = FORMAT(@monthNum,'D2');
        END
    SET @dayStr = SUBSTRING(@pesel, 5, 2);
    SET @yearStr = CONCAT(@yearPref, SUBSTRING(@pesel, 1, 2));
    DECLARE @resultStr VARCHAR(20);
    SET @resultStr = CONCAT(@yearStr, @monthStr, @dayStr);
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
    DECLARE @age int, @basePremium money, @additionalPremium money;
    SET @age = DATEDIFF(YEAR, dbo.BIRTHDATE_FROM_PESEL(@pesel), GETDATE());
    SET @basePremium = dbo.CALC_BASE_PREMIUM(@su, @insurancePeriod, @frequency);
    SET @additionalPremium = 0;
    IF @hazardousOccupation = 1
        SET @additionalPremium = @additionalPremium + (0.1 * @basePremium);
    IF @age > 50
        SET @additionalPremium = @additionalPremium + ((@age - 50) / 100 * @basePremium);
    RETURN (@basePremium + @additionalPremium);
END
GO
-- CalcHousePremium
DROP FUNCTION CALC_HOUSE_PREMIUM
GO
CREATE FUNCTION CALC_HOUSE_PREMIUM(@insurancePeriod int, @fireSu money, @floodSu money,  @floorNumber smallint = 1, 
    @floorTotal smallint = 1, @detached bit = 0, @frequency int = 12)
RETURNS MONEY
BEGIN
    DECLARE @totalSu money = 0;
    -- detached house
    IF @detached = 1
        SET @totalSu = @fireSu + @floodSu + (0.02 * @fireSu * @floorTotal);
    -- flat
    ELSE
        SET @totalSu = @fireSu + @floodSu + (@floorNumber / @floorTotal * @fireSu * 0.2) + ((1 - (@floorNumber / @floorTotal) * 0.2 * @floodSu));
    RETURN dbo.CALC_BASE_PREMIUM(@totalSu, @insurancePeriod, @frequency);
END
GO
-- CalcVehiclePremium
DROP FUNCTION CALC_VEHICLE_PREMIUM
GO
CREATE FUNCTION CALC_VEHICLE_PREMIUM(@pesel VARCHAR(11), @insurancePeriod int, @su money, @vehicleModelId bigint, @mileage int, @frequency int = 12)
RETURNS MONEY
BEGIN
    DECLARE @age int, @vehicleAge int, @horsepower int, @horsepowerMultiplier decimal = 0, @additionalPremium money = 0;
    SET @vehicleAge = DATEDIFF(YEAR, (SELECT Year FROM VehicleModel WHERE ID = @vehicleModelId), GETDATE());
    SET @age = DATEDIFF(YEAR, dbo.BIRTHDATE_FROM_PESEL(@pesel), GETDATE());
    SET @horsepower = (SELECT Horsepower FROM VehicleModel WHERE ID = @vehicleModelId);
    IF @age < 25
        SET @additionalPremium = 0.5 * ((25 - @age) * 0.1) * @su;
    IF @horsepower BETWEEN 0 AND 80
        SET @horsepowerMultiplier = 0.01
    ELSE IF @horsepower BETWEEN 81 and 140
        SET @horsepowerMultiplier = 0.02
    ELSE 
        SET @horsepowerMultiplier = 0.03
    SET @additionalPremium = @additionalPremium + (@su * 0.01 * @vehicleAge); -- client age 
    SET @additionalPremium = @additionalPremium + (@su * @horsepowerMultiplier); -- horsepower
    IF @mileage > 100000
        SET @additionalPremium = @additionalPremium + (@mileage / 5000000 * @su) -- mileage
    RETURN dbo.CALC_BASE_PREMIUM(@su + @additionalPremium, @insurancePeriod, @frequency);
END
GO
-- returns random Central user id with least tasks assigned
DROP FUNCTION LEAST_BUSY_CENTRAL
GO
CREATE FUNCTION LEAST_BUSY_CENTRAL()
RETURNS bigint
BEGIN
    DECLARE @minTaskNumber int = (SELECT MIN(NumberOfTasks) FROM CENTRAL_TASKS);
    DECLARE @randomCentralId int;
    SET @randomCentralId = (
        SELECT TOP 1 Central_ID FROM CENTRAL_TASKS 
        WHERE NumberOfTasks = @minTaskNumber);
        -- todo maybe random but it is tricky
    RETURN @randomCentralId;
END
GO
DROP FUNCTION CLIENT_POLICY_COUNT
GO
CREATE FUNCTION CLIENT_POLICY_COUNT(@clientId bigint, @type varchar(30))
RETURNS int
BEGIN
    DECLARE @count int = 0;
    IF @type  IN ('APPROVED', 'SENT_TO_CLIENT')
        SET @count = (
            SELECT COUNT(t.ID) FROM Task t
            LEFT JOIN [Policy] p ON t.Policy_ID = p.ID
            WHERE p.Client_ID = @clientId AND t.Status_ID IN ('APPROVED', 'SENT_TO_CLIENT')
            GROUP BY p.Client_ID
            )
    ELSE IF @type = 'NOT_APPROVED'
        SET @count = (
            SELECT COUNT(t.ID) FROM Task t
            LEFT JOIN [Policy] p ON t.Policy_ID = p.ID
            WHERE p.Client_ID = @clientId AND t.Status_ID = 'NOT_APPROVED'
            GROUP BY p.Client_ID
            )
    ELSE IF @type = 'CALCULATION'
        SET @count = (
            SELECT COUNT(p.ID) FROM [Policy] p
            GROUP BY p.Client_ID, p.ID
            HAVING p.ID NOT IN (SELECT Policy_ID FROM Task t ) AND p.Client_ID = @clientId
        )
    RETURN @count
END
