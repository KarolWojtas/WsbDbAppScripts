USE InsuranceCompany;
GO
DROP TRIGGER INSERT_LIFE_PREMIUM
GO 
-- Set premium on Life risk after insert
-- LifeRisk (@pesel VARCHAR(11), @insurancePeriod int, @su money, @hazardousOccupation bit, @frequency int = 12)
CREATE TRIGGER INSERT_LIFE_PREMIUM
ON LifeRisk
AFTER INSERT
AS 
BEGIN
    UPDATE LifeRisk 
    SET Premium = InsuranceCompany.dbo.CALC_LIFE_PREMIUM(
        [User].PESEL,
        DATEDIFF(YEAR, [Policy].StartDate, [Policy].EndDate),
        inserted.SU,
        inserted.HazardousOccupation, 
        DEFAULT
        )
    FROM LifeRisk
    LEFT OUTER JOIN inserted
    ON LifeRisk.ID = inserted.ID
    LEFT OUTER JOIN [Policy]
    ON [Policy].ID = inserted.ID
    LEFT OUTER JOIN [User]
    ON [User].ID = [Policy].Client_ID
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
    SET Premium = InsuranceCompany.dbo.CALC_HOUSE_PREMIUM(
        DATEDIFF(YEAR, [Policy].StartDate, [Policy].EndDate),
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
    LEFT OUTER JOIN [Policy]
    ON [Policy].ID = inserted.ID
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
        [User].PESEL,
        DATEDIFF(YEAR, [Policy].StartDate, [Policy].EndDate),
        inserted.SU,
        inserted.VehicleModel_ID,
        inserted.Mileage,
        DEFAULT
        )
    FROM VehicleRisk
    LEFT OUTER JOIN inserted
    ON VehicleRisk.ID = inserted.ID
    LEFT OUTER JOIN [Policy]
    ON [Policy].ID = inserted.ID
    LEFT OUTER JOIN [User]
    ON [User].ID = [Policy].Client_ID
    WHERE VehicleRisk.ID IN (SELECT ID FROM inserted)
END
GO

