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
('Henryk', 'Sliczny', '16261656791');