USE AdventureWorks_Dev
GO
-- Used to load the database
CREATE OR ALTER Proc dbo.usp_InitializeTestDb
as
BEGIN
    BEGIN TRAN
        BEGIN TRY            

            Delete from HumanResources.EmployeeDepartmentHistory;
            Delete from HumanResources.EmployeePayHistory;
            Delete from HumanResources.Employee;
            Delete from Person.BusinessEntityAddress;
            Delete from Person.Address;
            Delete from Person.PersonPhone;
            Delete from Person.[Password];
            Delete from Person.EmailAddress;
            Delete from Person.BusinessEntityContact;
            Delete from Person.Person;
            Delete from Person.StateProvince;
            Delete from Sales.SalesTerritory;

            -- These have no dependencies
            Delete from Person.BusinessEntity;
            Delete from HumanResources.Department;
            Delete from HumanResources.Shift;            
            Delete from Person.CountryRegion;
            Delete from Person.PhoneNumberType; 
            Delete from Person.ContactType;
            Delete from Person.AddressType;


            DBCC CHECKIDENT ("Person.Address", RESEED, 0);                    
            DBCC CHECKIDENT ("Person.EmailAddress", RESEED, 0);
            DBCC CHECKIDENT ("Person.StateProvince", RESEED, 0);
            DBCC CHECKIDENT ("Sales.SalesTerritory", RESEED, 0);
            DBCC CHECKIDENT ("Person.BusinessEntity", RESEED, 0);
            DBCC CHECKIDENT ("HumanResources.Department", RESEED, 0);
            DBCC CHECKIDENT ("HumanResources.Shift", RESEED, 0);
            DBCC CHECKIDENT ("Person.PhoneNumberType", RESEED, 0);
            DBCC CHECKIDENT ("Person.ContactType", RESEED, 0);
            DBCC CHECKIDENT ("Person.AddressType", RESEED, 0);

            -- Person.AddressType
            SET IDENTITY_INSERT Person.AddressType ON;
                INSERT INTO Person.AddressType
                    ([AddressTypeID], [Name], [rowguid], [ModifiedDate])
                SELECT 
                    [AddressTypeID], [Name], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Person.AddressType;
            SET IDENTITY_INSERT Agents.AddressType OFF;

            -- Person.ContactType
            SET IDENTITY_INSERT Person.ContactType ON;
                INSERT INTO Person.ContactType
                    ([ContactTypeID], [Name], [ModifiedDate])
                SELECT 
                    [ContactTypeID], [Name], [ModifiedDate]
                FROM AdventureWorks2019.Person.ContactType;
            SET IDENTITY_INSERT Person.ContactType OFF;

            -- Person.PhoneNumberType
            SET IDENTITY_INSERT Person.PhoneNumberType ON;
                INSERT INTO Person.PhoneNumberType
                    ([PhoneNumberTypeID], [Name], [ModifiedDate])
                SELECT 
                    [PhoneNumberTypeID], [Name], [ModifiedDate]
                FROM AdventureWorks2019.Person.PhoneNumberType;
            SET IDENTITY_INSERT Person.PhoneNumberType OFF;

            -- Person.CountryRegion
            INSERT INTO Person.CountryRegion
                ([CountryRegionCode], [Name], [ModifiedDate])
            SELECT 
                [CountryRegionCode], [Name], [ModifiedDate]
            FROM AdventureWorks2019.Person.CountryRegion;

            -- HumanResources.Shift
            SET IDENTITY_INSERT HumanResources.Shift ON;
                INSERT INTO HumanResources.Shift
                    ([ShiftID], [Name] ,[StartTime], [EndTime], [ModifiedDate])
                SELECT 
                    [ShiftID], [Name] ,[StartTime], [EndTime], [ModifiedDate]
                FROM AdventureWorks2019.HumanResources.Shift;
            SET IDENTITY_INSERT HumanResources.Shift OFF;

            -- HumanResources.Department
            SET IDENTITY_INSERT HumanResources.Department ON;
                INSERT INTO HumanResources.Department
                    ([DepartmentID], [Name] ,[GroupName], [ModifiedDate])
                SELECT 
                    [DepartmentID], [Name] ,[GroupName], [ModifiedDate]
                FROM AdventureWorks2019.HumanResources.Department;
            SET IDENTITY_INSERT Agents.Department OFF;

            -- Person.BusinessEntity
            SET IDENTITY_INSERT Person.BusinessEntity ON;
                INSERT INTO Person.BusinessEntity
                    ([BusinessEntityID], [rowguid], [ModifiedDate])
                SELECT 
                    [BusinessEntityID], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Person.BusinessEntity be
                WHERE be.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);
            SET IDENTITY_INSERT Person.BusinessEntity OFF;

            -- Sales.SalesTerritory
            SET IDENTITY_INSERT Sales.SalesTerritory ON;
                INSERT INTO Sales.SalesTerritory
                    ([TerritoryID], [Name], [CountryRegionCode], [Group], [SalesYTD], [SalesLastYear], [CostYTD], [CostLastYear], [rowguid], [ModifiedDate])
                SELECT 
                    [TerritoryID], [Name], [CountryRegionCode], [Group], [SalesYTD], [SalesLastYear], [CostYTD], [CostLastYear], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Sales.SalesTerritory;
            SET IDENTITY_INSERT Sales.SalesTerritory OFF;

            -- Person.StateProvince
            SET IDENTITY_INSERT Person.StateProvince ON;
                INSERT INTO Person.StateProvince
                    ([StateProvinceID], [StateProvinceCode], [CountryRegionCode], [IsOnlyStateProvinceFlag], [Name], [TerritoryID], [rowguid], [ModifiedDate])
                SELECT 
                    [StateProvinceID], [StateProvinceCode], [CountryRegionCode], [IsOnlyStateProvinceFlag], [Name], [TerritoryID], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Person.StateProvince;
            SET IDENTITY_INSERT Person.StateProvince OFF;

            -- Person.Person
            INSERT INTO Person.Person
                ([BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [Suffix], [EmailPromotion], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [Suffix], [EmailPromotion], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.Person p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Person.BusinessEntityContact
            INSERT INTO Person.BusinessEntityContact
                ([BusinessEntityID], [PersonID], [ContactTypeID], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PersonID], [ContactTypeID], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.BusinessEntityContact p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Person.EmailAddress
            SET IDENTITY_INSERT Person.EmailAddress ON;
                INSERT INTO Person.EmailAddress
                    ([BusinessEntityID], [EmailAddressID], [EmailAddress], [rowguid], [ModifiedDate])
                SELECT 
                    [BusinessEntityID], [EmailAddressID], [EmailAddress], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Person.EmailAddress p
                WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);
            SET IDENTITY_INSERT Person.EmailAddress OFF;

            -- Person.[Password]
            INSERT INTO Person.[Password]
                ([BusinessEntityID], [PasswordHash], [PasswordSalt], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PasswordHash], [PasswordSalt], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.[Password] p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Person.PersonPhone
            INSERT INTO Person.PersonPhone
                ([BusinessEntityID], [PhoneNumber], [PhoneNumberTypeID], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PhoneNumber], [PhoneNumberTypeID], [ModifiedDate]
            FROM AdventureWorks2019.Person.PersonPhone p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- Person.Address
            SET IDENTITY_INSERT Person.Address ON;
                INSERT INTO Person.Address
                    ([AddressID], [AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation], [rowguid], [ModifiedDate])
                SELECT 
                    [AddressID], [AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Person.Address p
                WHERE p.AddressID IN 
                    (
                        SELECT AddressID 
                        FROM Person.BusinessEntityAddress 
                        WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee)
                    );
            SET IDENTITY_INSERT Person.Address OFF;

            -- Person.BusinessEntityAddress
            INSERT INTO Person.BusinessEntityAddress
                ([BusinessEntityID], [AddressID], [AddressTypeID], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [AddressID], [AddressTypeID], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.[BusinessEntityAddress] p
            WHERE p.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

            -- HumanResources.Employee
            INSERT INTO HumanResources.Employee
                ([BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], 
                [Gender], [HireDate], [SalariedFlag], [VacationHours], [SickLeaveHours], [CurrentFlag], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], 
                [Gender], [HireDate], [SalariedFlag], [VacationHours], [SickLeaveHours], [CurrentFlag], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.HumanResources.Employee;

            -- HumanResources.EmployeePayHistory
            INSERT INTO HumanResources.EmployeePayHistory
                ([BusinessEntityID], [RateChangeDate], [Rate], [PayFrequency], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [RateChangeDate], [Rate], [PayFrequency], [ModifiedDate]                
            FROM AdventureWorks2019.HumanResources.EmployeePayHistory;

            -- HumanResources.EmployeeDepartmentHistory
            INSERT INTO HumanResources.EmployeeDepartmentHistory
                ([BusinessEntityID], [DepartmentID], [ShiftID], [StartDate], [EndDate], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [DepartmentID], [ShiftID], [StartDate], [EndDate], [ModifiedDate]                
            FROM AdventureWorks2019.HumanResources.EmployeeDepartmentHistory;
    
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