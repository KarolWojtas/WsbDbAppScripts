USE InsuranceCompany
GO
DROP PROCEDURE CREATE_POLICY_PROCEDURE
GO
-- CreatePolicyProcedure
CREATE PROCEDURE CREATE_POLICY_PROCEDURE(@policyId bigint)
AS
BEGIN
-- set proper fields
    UPDATE [Policy]
    SET Premium = (
        SELECT ISNULL(life.Premium, 0) + ISNULL(vehicle.Premium, 0) + ISNULL(house.Premium, 0) FROM [Policy]
        LEFT JOIN LifeRisk life ON life.Policy_ID = @policyId 
        LEFT JOIN HouseRisk house ON house.Policy_ID = @policyId
        LEFT JOIN VehicleRisk vehicle ON vehicle.Policy_ID = @policyId
        WHERE [Policy].ID = @policyId
        ),
    Editable = 0
    WHERE [Policy].ID = @policyId;
    -- create task
    INSERT INTO [Task] (Policy_ID, Originator_ID, Operator_ID, Status_ID)
    (
        SELECT @policyId, Agent_ID, dbo.LEAST_BUSY_CENTRAL(), 'SENT_TO_APPROVAL' FROM [Policy]
        WHERE [Policy].ID = @policyId
    );
END