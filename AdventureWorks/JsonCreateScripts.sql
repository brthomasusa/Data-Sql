
-- HumanResources.Department
SELECT 
    *
FROM AdventureWorks_Dev.HumanResources.Department;

-- HumanResources.Shift
SELECT 
    *
FROM AdventureWorks_Dev.HumanResources.Shift;

-- HumanResources.Employee
SELECT 
    BusinessEntityID, NationalIDNumber, LoginID, OrganizationNode, OrganizationLevel,
    JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag, VacationHours,
    SickLeaveHours, CurrentFlag, rowguid, ModifiedDate
FROM AdventureWorks_Dev.HumanResources.Employee
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- HumanResources.EmployeePayHistory
SELECT 
    *
FROM AdventureWorks_Dev.HumanResources.EmployeePayHistory
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- HumanResources.EmployeeDepartmentHistory
SELECT 
    *
FROM AdventureWorks_Dev.HumanResources.EmployeeDepartmentHistory
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- Person.BusinessEntity
SELECT 
    *
FROM AdventureWorks_Dev.Person.BusinessEntity
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- Person.Person
SELECT 
    *
FROM AdventureWorks_Dev.Person.Person
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- Person.Address
SELECT 
    addr.AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, addr.rowguid, addr.ModifiedDate
FROM AdventureWorks_Dev.Person.Address addr
JOIN AdventureWorks_Dev.Person.BusinessEntityAddress biz ON addr.AddressID = biz.AddressID
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- Person.BusinessEntityContact Employees don't have contacts
SELECT 
    *
FROM AdventureWorks_Dev.Person.BusinessEntityContact
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- Person.BusinessEntityAddress
SELECT 
    *
FROM AdventureWorks_Dev.Person.BusinessEntityAddress
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- Person.EmailAddress
SELECT 
    *
FROM AdventureWorks_Dev.Person.EmailAddress
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

-- Person.PersonPhone
SELECT 
    BusinessEntityID, PhoneNumber, PhoneNumberTypeID, ModifiedDate AS LastModifiedDate 
FROM AdventureWorks_Dev.Person.PersonPhone
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee WHERE OrganizationLevel IN (1,2));

