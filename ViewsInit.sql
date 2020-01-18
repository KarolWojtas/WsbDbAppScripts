USE InsuranceCompany
GO
DROP VIEW SENT_TO_CLIENT_SUMMARY
GO
-- table with finished policies of given clients
CREATE VIEW SENT_TO_CLIENT_SUMMARY
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
    WHERE u.Character_ID = 'CLIENT'
    GROUP BY t.Status_ID, u.ID, u.FirstName, u.LastName, u.PESEL
    HAVING t.Status_ID = 'SENT_TO_CLIENT';
GO
DROP VIEW AGENT_SUMMARY
GO
CREATE VIEW AGENT_SUMMARY
AS
    SELECT u.ID, u.FirstName, u.LastName, u.PESEL
    FROM [User] u
    WHERE u.Character_ID = 'AGENT'
    GROUP BY u.ID, u.FirstName, u.LastName, u.PESEL;
GO