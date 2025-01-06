SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [HumanResources].[vEmployeeListItems] 
AS 
    SELECT 
        e.[BusinessEntityID]
        ,p.LastName
        ,p.FirstName
        ,p.MiddleName
        ,e.[JobTitle]
        ,d.[Name] AS Department
        ,s.[Name] AS Shift
        ,HumanResources.GetManagerFullName(HumanResources.Get_Manager_ID(e.BusinessEntityID)) AS ManagerName,            
        CASE
            WHEN e.CurrentFlag = 0 THEN 'Inactive'
            WHEN e.CurrentFlag = 1 THEN 'Active'     
        END AS EmploymentStatus            
    FROM [HumanResources].[Employee] e
    INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = e.[BusinessEntityID]                 
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh ON e.[BusinessEntityID] = edh.[BusinessEntityID]     
    INNER JOIN [HumanResources].[Department] d ON edh.[DepartmentID] = d.[DepartmentID]            
    INNER JOIN [HumanResources].[Shift] s ON edh.[ShiftID] = s.[ShiftID]
    WHERE edh.EndDate IS NULL;
GO
