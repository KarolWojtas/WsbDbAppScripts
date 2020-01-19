USE InsuranceCompany
GO
DROP VIEW ACTIVE_CLIENT_POLICIES
GO
-- Summary of Client Policies which were offered (status 'SENT_TO_CLIENT') and their insurance period is active
CREATE VIEW ACTIVE_CLIENT_POLICIES
AS
    SELECT u.ID, u.FirstName, u.LastName, u.PESEL, 
        DATEDIFF(YEAR, dbo.BIRTHDATE_FROM_PESEL(u.PESEL), GETDATE()) as Age,
        COUNT(p.ID) as NumberOfPolicies,
        SUM(p.Premium) as TotalPremium,
        COUNT(vr.ID) NumberOfVehiclesInsured,
        COUNT(hr.ID) NumberOfHousesInsured,
        t.Status_ID as Status
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
    SELECT u.FirstName AgentFirstName, u.LastName AgentLastName, t.Status_ID,
        c.PESEL, c.FirstName + ' ' + c.LastName ClientName, p.Premium
    FROM Task t
    LEFT JOIN [Policy] p ON t.Policy_ID = p.ID
    LEFT JOIN [User] u ON t.Operator_ID = u.ID
    LEFT JOIN [User] c ON p.Client_ID = c.ID
    WHERE u.Character_ID = 'AGENT'
GO
