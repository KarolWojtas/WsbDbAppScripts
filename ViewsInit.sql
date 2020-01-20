USE InsuranceCompany
GO
DROP VIEW ACTIVE_CLIENT_POLICIES
GO
-- Summary of Client Policies which were offered (status 'SENT_TO_CLIENT') and their insurance period is active
CREATE VIEW ACTIVE_CLIENT_POLICIES
AS
    SELECT u.ID ClientID, u.FirstName, u.LastName, u.PESEL, 
        DATEDIFF(YEAR, dbo.BIRTHDATE_FROM_PESEL(u.PESEL), GETDATE()) as Age,
        COUNT(p.ID) as NumberOfPolicies,
        SUM(p.Premium) as ActivePoliciesPremium,
        COUNT(vr.ID) NumberOfVehiclesInsured,
        COUNT(hr.ID) NumberOfHousesInsured
    FROM Task t
    LEFT JOIN [Policy] p ON t.Policy_ID = p.ID
    LEFT JOIN [User] u ON u.ID = p.Client_ID
    LEFT JOIN HouseRisk hr ON p.ID = hr.Policy_ID
    LEFT JOIN VehicleRisk vr ON p.ID = vr.Policy_ID
    WHERE u.Character_ID = 'CLIENT' AND GETDATE() BETWEEN p.StartDate AND p.EndDate
    GROUP BY t.Status_ID, u.ID, u.FirstName, u.LastName, u.PESEL
    HAVING t.Status_ID = 'SENT_TO_CLIENT';
GO
DROP VIEW AGENT_TASK_SUMMARY
GO
CREATE VIEW AGENT_TASK_SUMMARY
AS
    SELECT a.FirstName + ' ' + a.LastName OriginatorName, 
        t.Status_ID, t.UpdateDatetime,
        o.FirstName + ' ' + o.LastName OperatorName,
        c.PESEL ClientPesel, c.FirstName + ' ' + c.LastName ClientName, p.Premium
    FROM Task t
    LEFT JOIN [Policy] p ON t.Policy_ID = p.ID
    LEFT JOIN [User] a ON t.Originator_ID = a.ID
    LEFT JOIN [User] o ON t.Operator_ID = o.ID
    LEFT JOIN [User] c ON p.Client_ID = c.ID
    WHERE a.Character_ID = 'AGENT'
GO
-- todo widok dla centrali z zadaniami, opisem ryzyk i liczbą zatw/kalk/niezatw polis klienta
DROP VIEW CENTRAL_TASK_SUMMARY
GO
CREATE VIEW CENTRAL_TASK_SUMMARY
AS
    SELECT 
    central.ID CentralID, central.FirstName + ' ' + central.LastName CentralName,
    t.UpdateDatetime, DATEDIFF(DAY, GETDATE(), p.StartDate) as DaysBeforePolicyStart,
    p.Premium PolicyPremium,
    client.ID ClientID, client.PESEL ClientPesel, client.FirstName + ' ' + client.LastName ClientName,
    ISNULL(dbo.CLIENT_POLICY_COUNT(client.ID, 'APPROVED'), 0) ClientPoliciesApproved,
    ISNULL(dbo.CLIENT_POLICY_COUNT(client.ID, 'NOT_APPROVED'), 0) ClientPoliciesNotApproved,
    ISNULL(dbo.CLIENT_POLICY_COUNT(client.ID, 'CALCULATION'), 0) ClientPoliciesDuringCalculation
    FROM Task t
    LEFT JOIN [Policy] p ON p.ID = t.Policy_ID
    LEFT JOIN [User] central ON central.ID = t.Operator_ID
    LEFT JOIN [User] client ON client.ID = p.Client_ID
    WHERE central.Character_ID = 'CENTRAL'
GO