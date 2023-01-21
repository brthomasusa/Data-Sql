SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Used to load the database
CREATE OR ALTER  Proc [dbo].[usp_InitializeTestDb]
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

            -- These have no dependencies
            Delete from Person.BusinessEntity;
            Delete from HumanResources.Department;
            Delete from HumanResources.Shift;            

            DBCC CHECKIDENT ("Person.Address", RESEED, 0);                    
            DBCC CHECKIDENT ("Person.EmailAddress", RESEED, 0);
            DBCC CHECKIDENT ("Person.BusinessEntity", RESEED, 0);
            DBCC CHECKIDENT ("HumanResources.Department", RESEED, 0);
            DBCC CHECKIDENT ("HumanResources.Shift", RESEED, 0);

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
            SET IDENTITY_INSERT HumanResources.Department OFF;

            -- Person.BusinessEntity
            SET IDENTITY_INSERT Person.BusinessEntity ON;
                INSERT INTO Person.BusinessEntity
                    ([BusinessEntityID], [rowguid], [ModifiedDate])
                SELECT 
                    [BusinessEntityID], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Person.BusinessEntity be
                WHERE be.BusinessEntityID IN 
                (
                    SELECT BusinessEntityID 
                    FROM AdventureWorks2019.HumanResources.Employee
                    WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
                );
            SET IDENTITY_INSERT Person.BusinessEntity OFF;

            -- Person.Person
            INSERT INTO Person.Person
                ([BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [Suffix], [EmailPromotion], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName], [Suffix], [EmailPromotion], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.Person p
            WHERE p.BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );

            -- Person.BusinessEntityContact
            INSERT INTO Person.BusinessEntityContact
                ([BusinessEntityID], [PersonID], [ContactTypeID], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PersonID], [ContactTypeID], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.BusinessEntityContact p
            WHERE p.BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );

            -- Person.EmailAddress
            SET IDENTITY_INSERT Person.EmailAddress ON;
                INSERT INTO Person.EmailAddress
                    ([BusinessEntityID], [EmailAddressID], [EmailAddress], [rowguid], [ModifiedDate])
                SELECT 
                    [BusinessEntityID], [EmailAddressID], [EmailAddress], [rowguid], [ModifiedDate]
                FROM AdventureWorks2019.Person.EmailAddress p
                WHERE p.BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );
            SET IDENTITY_INSERT Person.EmailAddress OFF;

            -- Person.[Password]
            INSERT INTO Person.[Password]
                ([BusinessEntityID], [PasswordHash], [PasswordSalt], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PasswordHash], [PasswordSalt], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.[Password] p
            WHERE p.BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );

            -- Person.PersonPhone
            INSERT INTO Person.PersonPhone
                ([BusinessEntityID], [PhoneNumber], [PhoneNumberTypeID], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [PhoneNumber], [PhoneNumberTypeID], [ModifiedDate]
            FROM AdventureWorks2019.Person.PersonPhone p
            WHERE p.BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );

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
                        FROM AdventureWorks2019.Person.BusinessEntityAddress 
                        WHERE BusinessEntityID IN 
                        (
                            SELECT BusinessEntityID 
                            FROM AdventureWorks2019.HumanResources.Employee
                            WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
                        )
                    );
            SET IDENTITY_INSERT Person.Address OFF;

            -- Person.BusinessEntityAddress
            INSERT INTO Person.BusinessEntityAddress
                ([BusinessEntityID], [AddressID], [AddressTypeID], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [AddressID], [AddressTypeID], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.Person.[BusinessEntityAddress] p
            WHERE p.BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );

            -- HumanResources.Employee
            INSERT INTO HumanResources.Employee
                ([BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], 
                [Gender], [HireDate], [SalariedFlag], [VacationHours], [SickLeaveHours], [CurrentFlag], [rowguid], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], 
                [Gender], [HireDate], [SalariedFlag], [VacationHours], [SickLeaveHours], [CurrentFlag], [rowguid], [ModifiedDate]
            FROM AdventureWorks2019.HumanResources.Employee
            WHERE BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            ); 

            -- HumanResources.EmployeePayHistory
            INSERT INTO HumanResources.EmployeePayHistory
                ([BusinessEntityID], [RateChangeDate], [Rate], [PayFrequency], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [RateChangeDate], [Rate], [PayFrequency], [ModifiedDate]                
            FROM AdventureWorks2019.HumanResources.EmployeePayHistory
            WHERE BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );

            -- HumanResources.EmployeeDepartmentHistory
            INSERT INTO HumanResources.EmployeeDepartmentHistory
                ([BusinessEntityID], [DepartmentID], [ShiftID], [StartDate], [EndDate], [ModifiedDate])
            SELECT 
                [BusinessEntityID], [DepartmentID], [ShiftID], [StartDate], [EndDate], [ModifiedDate]                
            FROM AdventureWorks2019.HumanResources.EmployeeDepartmentHistory
            WHERE BusinessEntityID IN 
            (
                SELECT BusinessEntityID 
                FROM AdventureWorks2019.HumanResources.Employee
                WHERE OrganizationLevel < 2 OR OrganizationLevel IS NULL
            );
    
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
GO
