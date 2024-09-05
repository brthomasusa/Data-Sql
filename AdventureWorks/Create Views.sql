use AdventureWorks_Test
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [HumanResources].[vEmployee] 
AS 
SELECT 
    e.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]  
    ,pp.[PhoneNumber]
    ,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode]
    ,cr.[Name] AS [CountryRegionName] 
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = e.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Person].[PersonPhone] pp
    ON pp.BusinessEntityID = p.[BusinessEntityID]
    LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
    ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]
    LEFT OUTER JOIN [Person].[EmailAddress] ea
    ON p.[BusinessEntityID] = ea.[BusinessEntityID];
GO

---
CREATE OR ALTER VIEW [HumanResources].[vEmployeeDepartment] 
AS 
SELECT 
    e.[BusinessEntityID] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,e.[JobTitle]
    ,d.[Name] AS [Department] 
    ,d.[GroupName] 
    ,edh.[StartDate] 
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh 
    ON e.[BusinessEntityID] = edh.[BusinessEntityID] 
    INNER JOIN [HumanResources].[Department] d 
    ON edh.[DepartmentID] = d.[DepartmentID] 
WHERE edh.EndDate IS NULL
GO

---
CREATE OR ALTER VIEW [HumanResources].[vEmployeeDepartmentHistory] 
AS 
SELECT 
    e.[BusinessEntityID] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,s.[Name] AS [Shift]
    ,d.[Name] AS [Department] 
    ,d.[GroupName] 
    ,edh.[StartDate] 
    ,edh.[EndDate]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh 
    ON e.[BusinessEntityID] = edh.[BusinessEntityID] 
    INNER JOIN [HumanResources].[Department] d 
    ON edh.[DepartmentID] = d.[DepartmentID] 
    INNER JOIN [HumanResources].[Shift] s
    ON s.[ShiftID] = edh.[ShiftID];
GO

---
CREATE OR ALTER VIEW [HumanResources].[vEmployeeV2] 
AS 
SELECT 
    e.[BusinessEntityID],
	CASE
		WHEN p.NameStyle = 0 THEN 'Western'
		WHEN p.NameStyle = 1 THEN 'Eastern'     
	END AS NameStyle    
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]  
    ,pp.[PhoneNumber]
    ,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress],
	CASE
		WHEN p.EmailPromotion = 0 THEN 'Does not wish to receive email promotions.'
		WHEN p.EmailPromotion = 1 THEN 'Wishes to receive email promotions from AdventureWorks only.'     
		WHEN p.EmailPromotion = 2 THEN 'Wishes to receive email promotions from AdventureWorks and selected partners.'
	END AS EmailPromotion
    ,e.NationalIDNumber
    ,e.LoginID    
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode]
    ,cr.[Name] AS [CountryRegionName]
    ,e.BirthDate
    ,e.MaritalStatus
    ,e.Gender
    ,e.HireDate
    ,e.SalariedFlag AS Salaried
    ,e.VacationHours
    ,e.SickLeaveHours
    ,e.CurrentFlag AS Active 
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = e.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Person].[PersonPhone] pp
    ON pp.BusinessEntityID = p.[BusinessEntityID]
    LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
    ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]
    LEFT OUTER JOIN [Person].[EmailAddress] ea
    ON p.[BusinessEntityID] = ea.[BusinessEntityID];
GO
-----

CREATE OR ALTER VIEW HumanResources.vEmployeeListItems 
AS 
SELECT 
    e.[BusinessEntityID]           
    ,p.[LastName]
    ,p.[FirstName]
    ,p.[MiddleName] 
    ,e.[JobTitle]
    ,d.[Name] AS [Department]
    ,s.[Name] AS [Shift]
    ,pp.[PhoneNumber] 
    ,ea.[EmailAddress]
    ,e.CurrentFlag AS Active
    ,CONCAT(p.FirstName,' ',COALESCE(p.MiddleName,''),' ',p.LastName) as FullName 
    ,HumanResources.Get_Manager_ID(e.BusinessEntityID) AS ManagerID
    ,HumanResources.GetNumberOfEmployeesManaged(e.BusinessEntityID) AS EmployeesManaged 
    ,HumanResources.GetManagerFullName(HumanResources.Get_Manager_ID(e.BusinessEntityID)) AS ManagerName                       
FROM [HumanResources].[Employee] e
INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = e.[BusinessEntityID]
LEFT OUTER JOIN [Person].[PersonPhone] pp ON pp.BusinessEntityID = p.[BusinessEntityID]	
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh ON e.[BusinessEntityID] = edh.[BusinessEntityID]     
INNER JOIN [HumanResources].[Department] d ON edh.[DepartmentID] = d.[DepartmentID]
INNER JOIN [HumanResources].[Shift] s ON edh.[ShiftID] = s.[ShiftID]        
LEFT OUTER JOIN [Person].[EmailAddress] ea ON p.[BusinessEntityID] = ea.[BusinessEntityID]
WHERE edh.EndDate IS NULL
GO

-----
if OBJECT_ID('HumanResources.uspUpdateEmployeeOrgNode') is not NULL
    DROP PROC HumanResources.uspUpdateEmployeeOrgNode
GO

CREATE OR ALTER PROC HumanResources.uspUpdateEmployeeOrgNode(@mgrid int, @empid int)
AS
BEGIN
    DECLARE @mOrgNode HIERARCHYID, @childNode HIERARCHYID
    SELECT @mOrgNode = OrganizationNode FROM HumanResources.Employee WHERE BusinessEntityID = @mgrid
    
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
    
    BEGIN TRANSACTION
        SELECT @childNode = MAX(OrganizationNode) FROM HumanResources.Employee WHERE OrganizationNode.GetAncestor(1) = @mOrgNode;
                
        UPDATE HumanResources.Employee SET OrganizationNode = @mOrgNode.GetDescendant(@childNode, null)
        WHERE BusinessEntityID = @empid
    COMMIT
END;
GO

---
IF OBJECT_ID('HumanResources.vGetManagers', 'view') IS NOT NULL
    DROP VIEW HumanResources.vGetManagers;
GO

CREATE OR ALTER VIEW HumanResources.vGetManagers
WITH SCHEMABINDING
AS 
SELECT
    managers.BusinessEntityID, 
    managers.OrganizationNode,  
    managers.OrganizationNode.ToString() AS Text_OrgNode,
    history.DepartmentID,
    dept.Name AS DepartmentName,
    managers.JobTitle,
    people.FirstName,
    people.MiddleName,
    people.LastName,
    CONCAT(people.FirstName,' ',COALESCE(people.MiddleName,''),' ',people.LastName) as ManagerFullName
FROM
    (
        SELECT
            BusinessEntityID, NationalIDNumber, LoginID, 
            OrganizationNode, OrganizationLevel, JobTitle, 
            BirthDate, MaritalStatus, Gender, HireDate,
            SalariedFlag, VacationHours, SickLeaveHours, 
            CurrentFlag, rowguid, ModifiedDate,
            CASE 
                when (select top 1 B.OrganizationNode                
        FROM HumanResources.Employee B
        WHERE OrganizationNode.GetAncestor(1) = HumanResources.Employee.OrganizationNode) is null then 
                CAST (0 as BIT)
            ELSE 
                CAST (1 as BIT)
        END AS IsManager
    FROM
        HumanResources.Employee
) as managers
INNER JOIN HumanResources.EmployeeDepartmentHistory history ON managers.BusinessEntityID = history.BusinessEntityID
INNER JOIN HumanResources.Department dept ON history.DepartmentID = dept.DepartmentID
INNER JOIN Person.Person people ON managers.BusinessEntityID = people.BusinessEntityID
WHERE managers.IsManager = 1 AND history.EndDate is NULL
GO
---

IF OBJECT_ID('HumanResources.vGetManagersBasicInfo', 'view') IS NOT NULL
    DROP VIEW HumanResources.vGetManagersBasicInfo;
GO

CREATE OR ALTER VIEW HumanResources.vGetManagersBasicInfo
WITH SCHEMABINDING
AS 
SELECT
    managers.BusinessEntityID, 
    history.DepartmentID,
    dept.Name AS DepartmentName,
    people.FirstName,
    people.MiddleName,
    people.LastName
FROM
    (
        SELECT
            BusinessEntityID, 
            CASE 
                when (select top 1 B.OrganizationNode                
        FROM HumanResources.Employee B
        WHERE OrganizationNode.GetAncestor(1) = HumanResources.Employee.OrganizationNode) is null then 
                CAST (0 as BIT)
            ELSE 
                CAST (1 as BIT)
        END AS IsManager
    FROM
        HumanResources.Employee
) as managers
INNER JOIN HumanResources.EmployeeDepartmentHistory history ON managers.BusinessEntityID = history.BusinessEntityID
INNER JOIN HumanResources.Department dept ON history.DepartmentID = dept.DepartmentID
INNER JOIN Person.Person people ON managers.BusinessEntityID = people.BusinessEntityID
WHERE managers.IsManager = 1 AND history.EndDate is NULL
GO

---
CREATE OR ALTER PROC HumanResources.GetEmployeeWithDetails(@businessEntityID int)
AS
BEGIN
    SELECT 
        p.BusinessEntityID, p.PersonType, p.NameStyle, p.Title, p.FirstName, p.MiddleName, p.LastName,
        p.Suffix, p.EmailPromotion, 
        HumanResources.Get_Manager_ID(@businessEntityID) AS ManagerID,
        HumanResources.GetNumberOfEmployeesManaged(@businessEntityID) AS EmployeesManaged,
        e.NationalIDNumber, e.LoginID, e.JobTitle, e.BirthDate, e.MaritalStatus, e.Gender,
        e.HireDate, e.SalariedFlag, e.VacationHours, e.SickLeaveHours, e.CurrentFlag,
        ea.EmailAddressID, ea.EmailAddress, ph.PhoneNumberTypeID, ph.PhoneNumber,
        a.AddressID, a.AddressLine1, a.AddressLine2, a.City, a.StateProvinceID, a.PostalCode 
    FROM Person.Person p
    INNER JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
    INNER JOIN Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID
    INNER JOIN Person.PersonPhone ph ON p.BusinessEntityID = ph.BusinessEntityID
    INNER JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
    INNER JOIN Person.Address a ON bea.AddressID = a.AddressID
    WHERE p.BusinessEntityID = @businessEntityID;
END
GO

---
if OBJECT_ID('HumanResources.Get_Manager_ID') is not NULL
    DROP FUNCTION HumanResources.Get_Manager_ID
GO

CREATE FUNCTION HumanResources.Get_Manager_ID
(
    @employeeID int
)
RETURNS int AS
BEGIN
    DECLARE @rootID AS int;
    DECLARE @managerID AS int;

    SELECT @rootID = BusinessEntityID FROM HumanResources.Employee WHERE OrganizationNode = HIERARCHYID::GetRoot();
    
    -- Caller is seeking CEO's manager id which would be the CEO's id
    IF @rootID = @employeeID 
        RETURN @rootID;
    
    -- This will get the manager id of all other employees
    SELECT @managerID = BusinessEntityID FROM HumanResources.Employee WHERE OrganizationNode IN         
        (
            SELECT 
                OrganizationNode.GetAncestor(1)
            FROM HumanResources.Employee
            WHERE BusinessEntityID = @employeeID
        )

    RETURN @managerID;
END
GO

---
if OBJECT_ID('HumanResources.GetNumberOfEmployeesManaged') is not NULL
    DROP FUNCTION HumanResources.GetNumberOfEmployeesManaged
GO

CREATE FUNCTION HumanResources.GetNumberOfEmployeesManaged
(
    @employeeID int
)
RETURNS int AS
BEGIN
    DECLARE @employeeNode AS HIERARCHYID;
    DECLARE @employeesManaged AS int
    SELECT @employeeNode = OrganizationNode FROM HumanResources.Employee WHERE BusinessEntityID = @employeeID;

    SELECT @employeesManaged = COUNT(BusinessEntityID) FROM HumanResources.Employee WHERE OrganizationNode.GetAncestor(1) = @employeeNode;
    RETURN @employeesManaged;
END
GO

---
USE AdventureWorks_Test
GO

if OBJECT_ID('HumanResources.GetManagerFullName') is not NULL
    DROP FUNCTION HumanResources.GetManagerFullName
GO

CREATE FUNCTION HumanResources.GetManagerFullName
(
    @managerID int
)
RETURNS NVARCHAR(50) AS
BEGIN
    DECLARE @managerFullName AS NVARCHAR(50);

    SELECT @managerFullName = CONCAT(p.FirstName,' ',COALESCE(p.MiddleName,''),' ',p.LastName) 
    FROM Person.Person p
    WHERE p.BusinessEntityID = @managerID

    RETURN @managerFullName;
END
GO

---
USE AdventureWorks_Test
GO
if OBJECT_ID('HumanResources.udfGetEmployeeDetails') is not NULL
    DROP FUNCTION HumanResources.udfGetEmployeeDetails
GO

CREATE FUNCTION HumanResources.udfGetEmployeeDetails (@employeeID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        e.[BusinessEntityID],
        CASE
            WHEN p.NameStyle = 0 THEN 'Western'
            WHEN p.NameStyle = 1 THEN 'Eastern'     
        END AS NameStyle    
        ,p.[Title]
        ,p.[FirstName]
        ,p.[MiddleName]
        ,p.[LastName]
        ,p.[Suffix]
        ,e.[JobTitle]  
        ,pp.[PhoneNumber]
        ,pnt.[Name] AS [PhoneNumberType]
        ,ea.[EmailAddress],
        CASE
            WHEN p.EmailPromotion = 0 THEN 'Does not wish to receive email promotions.'
            WHEN p.EmailPromotion = 1 THEN 'Wishes to receive email promotions from AdventureWorks only.'     
            WHEN p.EmailPromotion = 2 THEN 'Wishes to receive email promotions from AdventureWorks and selected partners.'
        END AS EmailPromotion
        ,e.NationalIDNumber
        ,e.LoginID
        ,a.[AddressLine1]
        ,a.[AddressLine2]
        ,a.[City]
        ,sp.[Name] AS [StateProvinceName] 
        ,a.[PostalCode]
        ,cr.[Name] AS [CountryRegionName]
        ,e.BirthDate
        ,e.MaritalStatus
        ,e.Gender
        ,e.HireDate
        ,e.SalariedFlag AS Salaried
        ,e.VacationHours
        ,e.SickLeaveHours
        ,(SELECT TOP 1 Rate FROM HumanResources.EmployeePayHistory WHERE BusinessEntityID = @employeeID ORDER BY Rate DESC) AS Rate
        ,(
            SELECT TOP 1 
                CASE
                    WHEN PayFrequency = 1 THEN 'Monthly'
                    WHEN PayFrequency = 2 THEN 'Biweekly'     
                END AS PayFrequency     
            FROM HumanResources.EmployeePayHistory 
            WHERE BusinessEntityID = @employeeID 
            ORDER BY Rate DESC
        ) AS PayFrequency
        ,e.CurrentFlag AS Active
        ,HumanResources.GetManagerFullName(HumanResources.Get_Manager_ID(@employeeID)) AS ManagerName
        ,d.[Name] AS Department
        ,s.[Name] AS Shift
        ,CONCAT(a.[AddressLine1],' ',COALESCE(a.[AddressLine2],''),' ',a.[City], ' ',sp.[Name], ' ',a.[PostalCode], ' ', cr.[Name]) as Address
    FROM [HumanResources].[Employee] e
    INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = e.[BusinessEntityID]        
    INNER JOIN [Person].[BusinessEntityAddress] bea ON bea.[BusinessEntityID] = e.[BusinessEntityID]         
    INNER JOIN [Person].[Address] a ON a.[AddressID] = bea.[AddressID]        
    INNER JOIN [Person].[StateProvince] sp ON sp.[StateProvinceID] = a.[StateProvinceID]        
    INNER JOIN [Person].[CountryRegion] cr ON cr.[CountryRegionCode] = sp.[CountryRegionCode] 
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh ON e.[BusinessEntityID] = edh.[BusinessEntityID]     
    INNER JOIN [HumanResources].[Department] d ON edh.[DepartmentID] = d.[DepartmentID]            
    INNER JOIN [HumanResources].[Shift] s ON edh.[ShiftID] = s.[ShiftID]
    LEFT OUTER JOIN [Person].[PersonPhone] pp ON pp.BusinessEntityID = p.[BusinessEntityID]        
    LEFT OUTER JOIN [Person].[PhoneNumberType] pnt ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]        
    LEFT OUTER JOIN [Person].[EmailAddress] ea ON p.[BusinessEntityID] = ea.[BusinessEntityID]
    WHERE e.BusinessEntityID = @employeeID AND edh.EndDate IS NULL
);
GO


if OBJECT_ID('HumanResources.tvfGetEmployeeCommand') is not NULL
    DROP FUNCTION HumanResources.tvfGetEmployeeCommand
GO

CREATE FUNCTION HumanResources.tvfGetEmployeeCommand
(@employeeID AS INT)
RETURNS TABLE
AS
RETURN
(SELECT 
    e.[BusinessEntityID]
    ,p.[NameStyle]  
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]  
    ,pp.[PhoneNumber]
    ,pp.[PhoneNumberTypeID]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,e.[NationalIDNumber]
    ,e.[LoginID]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,sp.[StateProvinceID] 
    ,a.[PostalCode]
    ,cr.[CountryRegionCode]
    ,e.[BirthDate]
    ,e.[MaritalStatus]
    ,e.[Gender]
    ,e.[HireDate]
    ,e.SalariedFlag AS Salaried
    ,e.[VacationHours]
    ,e.[SickLeaveHours]
    ,(SELECT TOP 1 Rate FROM HumanResources.EmployeePayHistory WHERE BusinessEntityID = @employeeID ORDER BY Rate DESC) AS PayRate
    ,(SELECT TOP 1 PayFrequency FROM HumanResources.EmployeePayHistory WHERE BusinessEntityID = @employeeID ORDER BY Rate DESC) AS PayFrequency
    ,e.CurrentFlag AS Active
    ,HumanResources.Get_Manager_ID(@employeeID) AS ManagerID
    ,edh.DepartmentID
    ,edh.ShiftID
FROM [HumanResources].[Employee] e
INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = e.[BusinessEntityID]        
INNER JOIN [Person].[BusinessEntityAddress] bea ON bea.[BusinessEntityID] = e.[BusinessEntityID]         
INNER JOIN [Person].[Address] a ON a.[AddressID] = bea.[AddressID]        
INNER JOIN [Person].[StateProvince] sp ON sp.[StateProvinceID] = a.[StateProvinceID]        
INNER JOIN [Person].[CountryRegion] cr ON cr.[CountryRegionCode] = sp.[CountryRegionCode] 
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh ON e.[BusinessEntityID] = edh.[BusinessEntityID]     
INNER JOIN [HumanResources].[Department] d ON edh.[DepartmentID] = d.[DepartmentID]            
LEFT OUTER JOIN [Person].[PersonPhone] pp ON pp.BusinessEntityID = p.[BusinessEntityID]        
LEFT OUTER JOIN [Person].[PhoneNumberType] pnt ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]        
LEFT OUTER JOIN [Person].[EmailAddress] ea ON p.[BusinessEntityID] = ea.[BusinessEntityID]
WHERE e.BusinessEntityID = @employeeID AND edh.EndDate IS NULL)
GO