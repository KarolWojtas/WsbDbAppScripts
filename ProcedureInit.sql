USE InsuranceCompany
GO
DROP PROCEDURE CREATE_POLICY_PROCEDURE
GO
-- CreatePolicyProcedure
CREATE PROCEDURE CREATE_POLICY_PROCEDURE(@policyId bigint)
AS
BEGIN
-- set proper fields
    DECLARE @totalPremium money = (
        SELECT ISNULL(life.Premium, 0) + ISNULL(vehicle.Premium, 0) + ISNULL(house.Premium, 0) FROM [Policy]
        LEFT JOIN LifeRisk life ON life.Policy_ID = @policyId 
        LEFT JOIN HouseRisk house ON house.Policy_ID = @policyId
        LEFT JOIN VehicleRisk vehicle ON vehicle.Policy_ID = @policyId
        WHERE [Policy].ID = @policyId
        );
    IF(@totalPremium = 0)
        BEGIN
            RAISERROR('Polisa nie moe zostać wystawiona, poniewaz składka jest równa zero', 16, 1);
            RETURN;
        END

    UPDATE [Policy]
    SET Premium = @totalPremium,
    Editable = 0
    WHERE [Policy].ID = @policyId;
    -- create task
    INSERT INTO [Task] (Policy_ID, Originator_ID, Operator_ID, Status_ID)
    (
        SELECT @policyId, Agent_ID, dbo.LEAST_BUSY_CENTRAL(), 'SENT_TO_APPROVAL' FROM [Policy]
        WHERE [Policy].ID = @policyId
    );
END
GO
DROP PROCEDURE VERIFY_POLICY
GO
CREATE PROCEDURE VERIFY_POLICY(@policyId bigint, @approved bit)
AS
BEGIN
    DECLARE @currentPolicyStatus varchar(50) = (SELECT Status_ID FROM Task WHERE Policy_ID = @policyId);
    IF @currentPolicyStatus <> 'SENT_TO_APPROVAL'
        BEGIN
            RAISERROR('Nie mozna zaktualizować polisy, bo posiada ona nieodpowiedni status.', 16, 1);
            RETURN;
        END
    UPDATE [Policy]
    SET Approved = @approved
    WHERE [Policy].ID = @policyId;

    DECLARE @status VARCHAR(50);
    IF @approved = 1
        SET @status = 'APPROVED';
    ELSE
        SET @status = 'NOT_APPROVED';
    UPDATE [Task]
    SET Status_ID = @status,
        Operator_ID = Originator_ID
    WHERE Task.Policy_ID = @policyId;
END
GO
DROP PROCEDURE SEND_TO_CLIENT
GO
CREATE PROCEDURE SEND_TO_CLIENT(@policyId bigint)
AS
BEGIN
    DECLARE @currentPolicyStatus varchar(50) = (SELECT Status_ID FROM Task WHERE Policy_ID = @policyId);
    IF @currentPolicyStatus <> 'APPROVED'
        BEGIN
            RAISERROR('Nie mozna przeslac polisy klientowi, bo posiada ona nieodpowiedni status.', 16, 1);
            RETURN;
        END
    UPDATE Task
    SET Status_ID = 'SENT_TO_CLIENT'
    WHERE Policy_ID = @policyId;
END