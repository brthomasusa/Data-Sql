-- Store Proc HumanResources.spGetEmployeeDetails
CREATE OR ALTER PROCEDURE [HumanResources].[spGetEmployeeListIemsByLastName] 
	@searchCriteria NVARCHAR(30),
	@skip int,
	@take int
AS 
SET NOCOUNT ON
BEGIN 
    SELECT 
		BusinessEntityID           
		,LastName
		,FirstName
		,MiddleName
		,JobTitle
		,Department 
		,JobTitle
		,Department
		,Shift
		,ManagerName 
		,EmploymentStatus                      
	FROM HumanResources.vEmployeeListItems
	WHERE LastName LIKE '%'+IsNull(@searchCriteria,LastName)+'%'  --CONCAT('%',@searchCriteria,'%')
    ORDER BY LastName, FirstName, MiddleName     
	OFFSET @skip ROWS FETCH NEXT @take ROWS ONLY;
END
GO

-- HumanResources.vEmployeeListItemsWithDeptShiftOrgInfo
CREATE OR ALTER VIEW HumanResources.vEmployeeListItemsWithDeptShiftOrgInfo 
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
    ,d.DepartmentID
    ,s.ShiftID
    ,e.OrganizationLevel                       
FROM [HumanResources].[Employee] e
INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = e.[BusinessEntityID]
LEFT OUTER JOIN [Person].[PersonPhone] pp ON pp.BusinessEntityID = p.[BusinessEntityID]	
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh ON e.[BusinessEntityID] = edh.[BusinessEntityID]     
INNER JOIN [HumanResources].[Department] d ON edh.[DepartmentID] = d.[DepartmentID]
INNER JOIN [HumanResources].[Shift] s ON edh.[ShiftID] = s.[ShiftID]        
LEFT OUTER JOIN [Person].[EmailAddress] ea ON p.[BusinessEntityID] = ea.[BusinessEntityID]
WHERE edh.EndDate IS NULL
GO

-- HumanResources.spGetEmployeeListIemsByDepartment
CREATE OR ALTER PROCEDURE [HumanResources].[spGetEmployeeListIemsByDepartment] 
	@departmentId int,
    @lastName NVARCHAR (30),
	@skip int,
	@take int
AS 
SET NOCOUNT ON
BEGIN 
    SELECT 
        BusinessEntityID AS EmployeeID
        ,LastName
        ,FirstName
        ,MiddleName
        ,JobTitle
        ,Department
        ,GroupName
        ,Shift
        ,PhoneNumber
        ,EmailAddress,
        CASE
            WHEN Active = 0 THEN 'Inactive'
            WHEN Active = 1 THEN 'Active'     
        END AS EmploymentStatus
        ,FullName
        ,EmployeesManaged
        ,ManagerName 	 
    FROM HumanResources.vEmployeeListItemsWithDeptShiftOrgInfo
    WHERE DepartmentID = @departmentId AND LastName LIKE CONCAT(@lastName,'%')   --LIKE '%'+IsNull(@lastName, LastName)+'%'
    ORDER BY OrganizationLevel, LastName, FirstName, MiddleName   
	OFFSET @skip ROWS FETCH NEXT @take ROWS ONLY;
END
GO 


-- Store Proc HumanResources.spGetEmployeeDetails
CREATE OR ALTER PROCEDURE [HumanResources].[spGetEmployeeDetails] @EmployeeID INT
AS 
SET NOCOUNT ON
BEGIN
    SELECT 
        e.[BusinessEntityID],
        CASE
            WHEN p.NameStyle = 0 THEN 'Western'
            WHEN p.NameStyle = 1 THEN 'Eastern'     
        END AS NameStyle    
        ,p.[Title]
        ,CONCAT(p.FirstName,' ',COALESCE(p.MiddleName,''),' ',p.LastName) AS EmployeeName
        ,p.[Suffix]
        ,e.[JobTitle]  
        ,pp.[PhoneNumber]
        ,ea.[EmailAddress],
        CASE
            WHEN p.EmailPromotion = 0 THEN 'Does not wish to receive email promotions.'
            WHEN p.EmailPromotion = 1 THEN 'Wishes to receive email promotions from AdventureWorks only.'     
            WHEN p.EmailPromotion = 2 THEN 'Wishes to receive email promotions from AdventureWorks and selected partners.'
        END AS EmailPromotion
        ,e.NationalIDNumber
        ,e.LoginID
        ,e.BirthDate
        ,e.MaritalStatus
        ,e.Gender
        ,e.HireDate,
        CASE
            WHEN e.SalariedFlag = 0 THEN 'Hourly - Not Exempt'
            WHEN e.SalariedFlag = 1 THEN 'Salaried - Exempt'     
        END AS JobClassification        
        ,e.VacationHours
        ,e.SickLeaveHours
        ,(SELECT TOP 1 Rate FROM HumanResources.EmployeePayHistory WHERE BusinessEntityID = @employeeID ORDER BY Rate DESC) AS PayRate
        ,(
            SELECT TOP 1 
                CASE
                    WHEN PayFrequency = 1 THEN 'Monthly'
                    WHEN PayFrequency = 2 THEN 'Biweekly'     
                END AS PayFrequency     
            FROM HumanResources.EmployeePayHistory 
            WHERE BusinessEntityID = @employeeID 
            ORDER BY Rate DESC
        ) AS PayFrequency,
        CASE
            WHEN e.CurrentFlag = 0 THEN 'Inactive'
            WHEN e.CurrentFlag = 1 THEN 'Active'     
        END AS EmploymentStatus        
        ,HumanResources.GetManagerFullName(HumanResources.Get_Manager_ID(@employeeID)) AS ManagerName
        ,d.[Name] AS Department
        ,s.[Name] AS Shift
        ,CONCAT(a.[AddressLine1],' ',COALESCE(a.[AddressLine2],''),' ',a.[City], ' ',sp.[Name], ' ',a.[PostalCode], ' ', cr.[Name]) as FullAddress
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
    WHERE e.BusinessEntityID = @employeeID AND edh.EndDate IS NULL;
END
GO


-- Function HumanResources.Get_Manager_ID
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

-- Function HumanResources.GetNumberOfEmployeesManaged
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

-- Function HumanResources.GetManagerFullName
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

-- HumanResources.vDepartmentHistoryViewModel
CREATE OR ALTER VIEW [HumanResources].[vDepartmentHistoryViewModel] 
AS 
SELECT
    BusinessEntityID
    ,d.Name AS Department
    ,s.Name AS Shift
    ,StartDate
    ,EndDate             
FROM HumanResources.EmployeeDepartmentHistory edh
INNER JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
INNER JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID; 
GO

-- HumanResources.vPayHistoryViewModel
CREATE OR ALTER VIEW [HumanResources].[vPayHistoryViewModel] 
AS 
SELECT
    BusinessEntityID
    ,RateChangeDate
    ,Rate AS PayRate
FROM HumanResources.EmployeePayHistory
GO
