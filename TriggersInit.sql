USE InsuranceCompany;
GO
DROP TRIGGER INSERT_LIFE_PREMIUM
GO 
-- Set premium on Life risk after insert
-- LifeRisk (@pesel VARCHAR(11), @insurancePeriod int, @su money, @hazardousOccupation bit, @frequency int = 12)
CREATE TRIGGER INSERT_LIFE_PREMIUM
ON LifeRisk
AFTER INSERT, UPDATE
AS 
BEGIN
    UPDATE LifeRisk 
    SET Premium = InsuranceCompany.dbo.CALC_LIFE_PREMIUM(
        u.PESEL,
        DATEDIFF(YEAR, p.StartDate, p.EndDate),
        inserted.SU,
        inserted.HazardousOccupation, 
        DEFAULT
        )
    FROM LifeRisk
    LEFT OUTER JOIN inserted
    ON LifeRisk.ID = inserted.ID
    LEFT OUTER JOIN [dbo].[Policy] p
    ON p.ID = inserted.Policy_ID
    LEFT OUTER JOIN [dbo].[User] u
    ON u.ID = p.Client_ID
    WHERE LifeRisk.ID IN (SELECT ID FROM inserted)
END
GO
DROP TRIGGER INSERT_HOUSE_PREMIUM
GO 
-- Set premium on House risk after insert
-- HouseRisk CALC_HOUSE_PREMIUM(@insurancePeriod int, @fireSu money, @floodSu money,  @floorNumber smallint = 1, @floorTotal smallint = 1,
--  @detached bit = 0, @frequency int = 12)
CREATE TRIGGER INSERT_HOUSE_PREMIUM
ON HouseRisk
AFTER INSERT, UPDATE
AS 
BEGIN
    UPDATE HouseRisk 
    -- todo cos z ins period nie tak
    SET Premium = InsuranceCompany.dbo.CALC_HOUSE_PREMIUM(
        DATEDIFF(YEAR, p.StartDate, p.EndDate),
        inserted.Fire_SU,
        inserted.Flood_SU,
        inserted.FloorNumber,
        inserted.FloorTotal,
        inserted.Detached,
        DEFAULT
        )
    FROM HouseRisk
    LEFT OUTER JOIN inserted
    ON HouseRisk.ID = inserted.ID
    LEFT OUTER JOIN [Policy] p
    ON p.ID = inserted.Policy_ID
    WHERE HouseRisk.ID IN (SELECT ID FROM inserted)
END
GO
DROP TRIGGER INSERT_VEHICLE_PREMIUM
GO
-- Set premium on Vehicle risk after insert
-- VehicleRisk CALC_VEHICLE_PREMIUM(@pesel VARCHAR(11), @insurancePeriod int, @su money, @vehicleModelId bigint, @mileage int, @frequency int = 12)
CREATE TRIGGER INSERT_VEHICLE_PREMIUM
ON VehicleRisk
AFTER INSERT, UPDATE
AS 
BEGIN
    UPDATE VehicleRisk 
    SET Premium = InsuranceCompany.dbo.CALC_VEHICLE_PREMIUM(
        u.PESEL,
        DATEDIFF(YEAR, p.StartDate, p.EndDate),
        inserted.SU,
        inserted.VehicleModel_ID,
        inserted.Mileage,
        DEFAULT
        )
    FROM VehicleRisk
    LEFT OUTER JOIN inserted
    ON VehicleRisk.ID = inserted.ID
    LEFT OUTER JOIN [dbo].[Policy] p
    ON p.ID = inserted.Policy_ID
    LEFT OUTER JOIN [dbo].[User] u
    ON u.ID = p.Client_ID
    WHERE VehicleRisk.ID IN (SELECT ID FROM inserted)
END
GO
DROP TRIGGER TASK_UPDATE
GO
-- This trigger chages datetime of last update on given task
CREATE TRIGGER TASK_UPDATE
ON Task
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Task
    SET UpdateDatetime = GETDATE()
    WHERE Task.ID IN (SELECT ID FROM inserted)
END
