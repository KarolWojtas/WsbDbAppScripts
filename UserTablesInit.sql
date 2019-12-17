USE InsuranceCompany;

DELETE FROM InsuranceCompany.dbo.LifeRisk;
DELETE FROM InsuranceCompany.dbo.[Policy];
delete from InsuranceCompany.dbo.[User];
delete from InsuranceCompany.dbo.Character;

insert into InsuranceCompany.dbo.Character (Code, Description) 
values ('CENTRAL', 'Centrala'), ('CLIENT', 'Klient'), ('AGENT', 'Agent');

-- wybieram pierwszy character
-- declare @centralCharacter bigint;
-- set @centralCharacter = (select top 1 ID from InsuranceCompany.dbo.Character where InsuranceCompany.dbo.Character.Code = 'CENTRAL'); 

insert into InsuranceCompany.dbo.[User] (FirstName, LastName, PESEL, Character_ID)
values 
('Karol', 'Wojtas', '91062364630', 'CENTRAL'),
('Magdalena', 'Dobska', '91033116363', 'AGENT');

insert into InsuranceCompany.dbo.[User] (FirstName, LastName, PESEL)
values 
('Henryk', 'Sliczny', '97012909216'),
('Jan', 'Gonzalez', '90052582432');

-- Policies
INSERT INTO InsuranceCompany.dbo.Policy (Premium, Client_ID, Agent_ID, StartDate, EndDate, Approved)
VALUES
(
    0,
    (select top 1 ID from InsuranceCompany.dbo.[User] where Character_ID = 'CLIENT' ORDER BY PESEL ASC),
    (select top 1 ID from InsuranceCompany.dbo.[User] where Character_ID = 'AGENT'),
    GETDATE(),
    DATEADD(YEAR, 1, GETDATE()),
    0
),
(
    0,
    (select top 1 ID from InsuranceCompany.dbo.[User] where Character_ID = 'CLIENT'  ORDER BY PESEL DESC),
    (select top 1 ID from InsuranceCompany.dbo.[User] where Character_ID = 'AGENT'),
    GETDATE(),
    DATEADD(YEAR, 5, GETDATE()),
    0
);

-- LifeRisk
INSERT INTO LifeRisk (SU, Premium, HazardousOccupation, Policy_ID)
VALUES
(
    10000,
    0,
    0,
    (SELECT TOP 1 ID FROM [Policy] ORDER BY ID ASC)
),
(
    35000,
    0,
    1,
    (SELECT TOP 1 ID FROM [Policy] ORDER BY ID DESC)
);