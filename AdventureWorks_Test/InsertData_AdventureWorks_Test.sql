
-- Used to load the database
CREATE OR ALTER Proc dbo.usp_InitializeTestDb
as
BEGIN
    BEGIN TRAN
        BEGIN TRY            

            Delete from Agents.EmployeeDepartmentHistory;
            Delete from Agents.EmployeePayHistory;
            Delete from Agents.Employee;
            Delete from Agents.EconomicAgentsAddress;
            Delete from Agents.Address;
            Delete from Agents.PersonPhone;
            Delete from Agents.[Password];
            Delete from Agents.EmailAddress;
            Delete from Agents.AgentContact;
            Delete from Agents.Person;
            Delete from Agents.StateProvince;
            Delete from Agents.SalesTerritory;

            -- These have no dependencies
            Delete from Agents.EconomicAgents;
            Delete from Agents.Department;
            Delete from Agents.Shift;            
            Delete from Agents.CountryRegion;
            Delete from Agents.PhoneNumberType; 
            Delete from Agents.ContactType;
            Delete from Agents.AddressType;


            DBCC CHECKIDENT ("Agents.Address", RESEED, 0);                    
            DBCC CHECKIDENT ("Agents.EmailAddress", RESEED, 0);
            DBCC CHECKIDENT ("Agents.StateProvince", RESEED, 0);
            DBCC CHECKIDENT ("Agents.SalesTerritory", RESEED, 0);
            DBCC CHECKIDENT ("Agents.EconomicAgents", RESEED, 0);
            DBCC CHECKIDENT ("Agents.Department", RESEED, 0);
            DBCC CHECKIDENT ("Agents.Shift", RESEED, 0);
            DBCC CHECKIDENT ("Agents.PhoneNumberType", RESEED, 0);
            DBCC CHECKIDENT ("Agents.ContactType", RESEED, 0);
            DBCC CHECKIDENT ("Agents.AddressType", RESEED, 0);

            -- Agents.AddressType
            SET IDENTITY_INSERT Agents.AddressType ON;
                INSERT INTO Agents.AddressType
                    ([AddressTypeID], [Name], [rowguid], [ModifiedDate])
                SELECT 
                    [AddressTypeID], [Name], [rowguid], [ModifiedDate]
                FROM Person.AddressType;
            SET IDENTITY_INSERT Agents.AddressType OFF;

            -- Agents.ContactType
            SET IDENTITY_INSERT Agents.ContactType ON;
                INSERT INTO Agents.ContactType
                    ([ContactTypeID], [Name], [ModifiedDate])
                SELECT 
                    [ContactTypeID], [Name], [ModifiedDate]
                FROM Person.ContactType;
            SET IDENTITY_INSERT Agents.ContactType OFF;

            -- Agents.PhoneNumberType
            SET IDENTITY_INSERT Agents.PhoneNumberType ON;
                INSERT INTO Agents.PhoneNumberType
                    ([PhoneNumberTypeID], [Name], [ModifiedDate])
                SELECT 
                    [PhoneNumberTypeID], [Name], [ModifiedDate]
                FROM Person.PhoneNumberType;
            SET IDENTITY_INSERT Agents.PhoneNumberType OFF;

            -- Agents.CountryRegion
            INSERT INTO Agents.CountryRegion
                ([CountryRegionCode], [Name], [ModifiedDate])
            SELECT 
                [CountryRegionCode], [Name], [ModifiedDate]
            FROM Person.CountryRegion;

            -- Agents.Shift
            SET IDENTITY_INSERT Agents.Shift ON;
                INSERT INTO Agents.Shift
                    ([ShiftID], [Name] ,[StartTime], [EndTime], [ModifiedDate])
                SELECT 
                    [ShiftID], [Name] ,[StartTime], [EndTime], [ModifiedDate]
                FROM HumanResources.Shift;
            SET IDENTITY_INSERT Agents.Shift OFF;

            -- Agents.Department
            SET IDENTITY_INSERT Agents.Department ON;
                INSERT INTO Agents.Department
                    ([DepartmentID], [Name] ,[GroupName], [ModifiedDate])
                SELECT 
                    [DepartmentID], [Name] ,[GroupName], [ModifiedDate]
                FROM HumanResources.Department;
            SET IDENTITY_INSERT Agents.Department OFF;

            -- Agents.EconomicAgents
            SET IDENTITY_INSERT Agents.EconomicAgents ON;
                INSERT INTO Agents.EconomicAgents
                    ([AgentID], [rowguid], [ModifiedDate])
                SELECT 
                    [BusinessEntityID], [rowguid], [ModifiedDate]
                FROM Person.BusinessEntity be
                WHERE be.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);
            SET IDENTITY_INSERT Agents.EconomicAgents OFF;

            -- Agents.SalesTerritory
            SET IDENTITY_INSERT Agents.SalesTerritory ON;
                INSERT INTO Agents.SalesTerritory
                    ([TerritoryID], [Name], [CountryRegionCode], [Group], [SalesYTD], [SalesLastYear], [CostYTD], [CostLastYear], [rowguid], [ModifiedDate])
                SELECT 
                    [TerritoryID], [Name], [CountryRegionCode], [Group], [SalesYTD], [SalesLastYear], [CostYTD], [CostLastYear], [rowguid], [ModifiedDate]
                FROM Sales.SalesTerritory;
            SET IDENTITY_INSERT Agents.SalesTerritory OFF;

            -- Agents.StateProvince
            SET IDENTITY_INSERT Agents.StateProvince ON;
                INSERT INTO Agents.StateProvince
                    ([StateProvinceID], [StateProvinceCode], [CountryRegionCode], [IsOnlyStateProvinceFlag], [Name], [TerritoryID], [rowguid], [ModifiedDate])
                SELECT 
                    [StateProvinceID], [StateProvinceCode], [CountryRegionCode], [IsOnlyStateProvinceFlag], [Name], [TerritoryID], [rowguid], [ModifiedDate]
                FROM Person.StateProvince;
            SET IDENTITY_INSERT Agents.StateProvince OFF;

            -- Agents.Person
            INSERT INTO Agents.Person
                ([AgentID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [Suffix], [EmailPromotion], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [Suffix], [EmailPromotion], [rowguid], [ModifiedDate]
            FROM Person.Person p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Agents.AgentContact
            INSERT INTO Agents.AgentContact
                ([AgentID], [PersonID], [ContactTypeID], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PersonID], [ContactTypeID], [rowguid], [ModifiedDate]
            FROM Person.BusinessEntityContact p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Agents.EmailAddress
            SET IDENTITY_INSERT Agents.EmailAddress ON;
                INSERT INTO Agents.EmailAddress
                    ([AgentID], [EmailAddressID], [EmailAddress], [rowguid], [ModifiedDate])
                SELECT 
                    [BusinessEntityID], [EmailAddressID], [EmailAddress], [rowguid], [ModifiedDate]
                FROM Person.EmailAddress p
                WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);
            SET IDENTITY_INSERT Agents.EmailAddress OFF;

            -- Agents.[Password]
            INSERT INTO Agents.[Password]
                ([AgentID], [PasswordHash], [PasswordSalt], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PasswordHash], [PasswordSalt], [rowguid], [ModifiedDate]
            FROM Person.[Password] p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Agents.PersonPhone
            INSERT INTO Agents.PersonPhone
                ([AgentID], [PhoneNumber], [PhoneNumberTypeID], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PhoneNumber], [PhoneNumberTypeID], [ModifiedDate]
            FROM Person.PersonPhone p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Agents.Address
            SET IDENTITY_INSERT Agents.Address ON;
                INSERT INTO Agents.Address
                    ([AddressID], [AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation], [rowguid], [ModifiedDate])
                SELECT 
                    [AddressID], [AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation], [rowguid], [ModifiedDate]
                FROM Person.Address p
                WHERE p.AddressID IN 
                    (
                        SELECT AddressID 
                        FROM Person.BusinessEntityAddress 
                        WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee)
                    );
            SET IDENTITY_INSERT Agents.Address OFF;

            -- Agents.EconomicAgentsAddress
            INSERT INTO Agents.EconomicAgentsAddress
                ([AgentID], [AddressID], [AddressTypeID], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [AddressID], [AddressTypeID], [rowguid], [ModifiedDate]
            FROM Person.[BusinessEntityAddress] p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Agents.Employee
            INSERT INTO Agents.Employee
                ([AgentID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], 
                [Gender], [HireDate], [SalariedFlag], [VacationHours], [SickLeaveHours], [CurrentFlag], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], 
                [Gender], [HireDate], [SalariedFlag], [VacationHours], [SickLeaveHours], [CurrentFlag], [rowguid], [ModifiedDate]
            FROM HumanResources.Employee;

            -- Agents.EmployeePayHistory
            INSERT INTO Agents.EmployeePayHistory
                ([AgentID], [RateChangeDate], [Rate], [PayFrequency], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [RateChangeDate], [Rate], [PayFrequency], [ModifiedDate]                
            FROM HumanResources.EmployeePayHistory;

            -- Agents.EmployeeDepartmentHistory
            INSERT INTO Agents.EmployeeDepartmentHistory
                ([AgentID], [DepartmentID], [ShiftID], [StartDate], [EndDate], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [DepartmentID], [ShiftID], [StartDate], [EndDate], [ModifiedDate]                
            FROM HumanResources.EmployeeDepartmentHistory;
    
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
                -- if error, roll back any chanegs done by any of the sql statements
                ROLLBACK TRANSACTION

                SELECT
                    ERROR_NUMBER() AS ErrorNumber,
                    -- ERROR_STATE() AS ErrorState,
                    -- ERROR_SEVERITY() AS ErrorSeverity,
                    -- ERROR_PROCEDURE() AS ErrorProcedure,
                    ERROR_LINE() AS ErrorLine,
                    ERROR_MESSAGE() AS ErrorMessage;                
        END CATCH    
END