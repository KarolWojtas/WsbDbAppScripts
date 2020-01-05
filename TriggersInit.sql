USE InsuranceCompany;
GO
DROP TRIGGER UPDATE_LIFE_PREMIUM
GO 
-- Set premium on Life risk after update / insert
-- LifeRisk (@pesel VARCHAR(11), @insurancePeriod int, @su money, @hazardousOccupation bit, @frequency int = 12)
CREATE TRIGGER UPDATE_LIFE_PREMIUM
ON LifeRisk
AFTER INSERT, UPDATE
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
    -- tutaj dodać WHERE LifeRisk.ID IN (SELECT ID FROM inserted)
    -- żeby ograniczyć rekordy aktualizowane, bez tego są wszystkie chyba
END
GO
-- TODO fix birthdate to text conversion
