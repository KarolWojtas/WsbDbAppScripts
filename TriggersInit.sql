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
    DECLARE @pesel VARCHAR(11), @insPeriod int, @su money, @hazOcc bit, @freq int, @id bigint;
    -- TODO get age from pesel from policy from person LOOOOOL
    SET @pesel = '94081832195';
    SELECT @su = FIRST_VALUE(SU) OVER (ORDER BY ID) FROM inserted;
    -- TODO
    SET @insPeriod = 10;
    SELECT @hazOcc = FIRST_VALUE(HazardousOccupation) OVER (ORDER BY ID) FROM inserted;
    SET @freq = 12;
    SELECT @id = FIRST_VALUE(ID) OVER (ORDER BY ID) FROM inserted;
    UPDATE LifeRisk 
    SET Premium = InsuranceCompany.CALC_LIFE_PREMIUM(@pesel, @insPeriod, @su, @hazOcc, @freq)
    WHERE ID = @id
END
GO
-- TODO TEST THIS ^^^