USE InsuranceCompany;

DELETE FROM InsuranceCompany.dbo.LifeRisk;
delete from dbo.HouseRisk;
delete from dbo.VehicleRisk;
DELETE FROM InsuranceCompany.dbo.[Policy];
delete from InsuranceCompany.dbo.[User];
delete from InsuranceCompany.dbo.Character;
delete from InsuranceCompany.dbo.TaskStatus;

insert into InsuranceCompany.dbo.Character (Code, Description) 
values ('CENTRAL', 'Centrala'), ('CLIENT', 'Klient'), ('AGENT', 'Agent');

INSERT INTO InsuranceCompany.dbo.TaskStatus (ID, Description)
VALUES 
('SENT_TO_APPROVAL', 'Wysłane do akceptacji'),
('APPROVED', 'Zatwierdzone'),
('SENT_TO_CLIENT', 'Wysłane do klienta'), 
('NOT_APPROVED', 'Nie zaakceptowane');

-- wybieram pierwszy character
-- declare @centralCharacter bigint;
-- set @centralCharacter = (select top 1 ID from InsuranceCompany.dbo.Character where InsuranceCompany.dbo.Character.Code = 'CENTRAL'); 

insert into InsuranceCompany.dbo.[User] (FirstName, LastName, PESEL, Character_ID)
values 
('Karol', 'Wojtyła', '91062364630', 'CENTRAL'),
('Magdalena', 'Dulek', '91033116363', 'AGENT');

insert into InsuranceCompany.dbo.[User] (FirstName, LastName, PESEL)
values 
('Henryk', 'Ślimak', '97012909216'),
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
-- HouseRisk
INSERT INTO HouseRisk (Fire_SU, Premium, FloorNumber, FloorTotal, Detached, Flood_SU, Policy_ID)
VALUES
(
    5000,
    0,
    2,
    10,
    0,
    10000,
    (SELECT TOP 1 ID FROM [Policy] ORDER BY ID ASC)
),
(
    7500,
    0,
    1,
    5,
    1,
    20000,
    (SELECT TOP 1 ID FROM [Policy] ORDER BY ID DESC)
);