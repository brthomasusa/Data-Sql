USE [AdventureWorks_Test]
GO

-- Used to reset the database before each test run
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
            DBCC CHECKIDENT ("Agents.StateProvince", RESEED, 0);
            DBCC CHECKIDENT ("Agents.SalesTerritory", RESEED, 0);
            DBCC CHECKIDENT ("Agents.EmailAddress", RESEED, 0);
            DBCC CHECKIDENT ("Agents.EconomicAgents", RESEED, 0);
            DBCC CHECKIDENT ("Agents.AddressType", RESEED, 0);
            DBCC CHECKIDENT ("Agents.ContactType", RESEED, 0);
            DBCC CHECKIDENT ("Agents.AddressType", RESEED, 0);

            -- Agents.AddressType

            -- Agents.ContactType

            -- Agents.PhoneNumberType

            -- Agents.CountryRegion

            -- Agents.Shift

            -- Agents.Department

            -- Agents.EconomicAgents

            -- Agents.SalesTerritory

            -- Agents.StateProvince

            -- Agents.Person

            -- Agents.AgentContact

            -- Agents.EmailAddress

            -- Agents.[Password]

            -- Agents.PersonPhone

            -- Agents.Address

            -- Agents.EconomicAgentsAddress

            -- Agents.Employee

            -- Agents.EmployeePayHistory

            -- Agents.EmployeeDepartmentHistory

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            INSERT INTO Agents.EconomicAgents
                (AgentId)
            SELECT 
                BusinessEntityID
            FROM HumanResources.Employee;





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

select 'abc';