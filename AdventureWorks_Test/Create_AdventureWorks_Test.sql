USE [AdventureWorks_Test]
GO

-- Schemas
CREATE SCHEMA Agents
GO
CREATE SCHEMA Events
GO
CREATE SCHEMA Resources
GO

-- User-defined types
CREATE TYPE [dbo].[Name] FROM [nvarchar](50) NULL
GO

CREATE TYPE [dbo].[NameStyle] FROM [bit] NOT NULL
GO

CREATE TYPE [dbo].[Flag] FROM [bit] NOT NULL
GO

CREATE TYPE [dbo].[AccountNumber] FROM [nvarchar](15) NULL
GO

CREATE TYPE [dbo].[OrderNumber] FROM [nvarchar](25) NULL
GO

CREATE TYPE [dbo].[Phone] FROM [nvarchar](25) NULL
GO

-- Agents.EconomicAgents
CREATE TABLE [Agents].[EconomicAgents](
	[AgentID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EconomicAgents_AgentID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[EconomicAgents] ADD  CONSTRAINT [DF_EconomicAgents_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[EconomicAgents] ADD  CONSTRAINT [DF_EconomicAgents_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-- Agents.Person
CREATE TABLE [Agents].[Person](
	[AgentID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [dbo].[NameStyle] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [dbo].[Name] NOT NULL,
	[MiddleName] [dbo].[Name] NULL,
	[LastName] [dbo].[Name] NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Person_AgentID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

ALTER TABLE [Agents].[Person] ADD  CONSTRAINT [DF_Person_NameStyle]  DEFAULT ((0)) FOR [NameStyle]
GO

ALTER TABLE [Agents].[Person] ADD  CONSTRAINT [DF_Person_EmailPromotion]  DEFAULT ((0)) FOR [EmailPromotion]
GO

ALTER TABLE [Agents].[Person] ADD  CONSTRAINT [DF_Person_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[Person] ADD  CONSTRAINT [DF_Person_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_EconomicAgents_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[EconomicAgents] ([AgentID])
GO

ALTER TABLE [Agents].[Person] CHECK CONSTRAINT [FK_Person_EconomicAgents_AgentID]
GO

ALTER TABLE [Agents].[Person]  WITH CHECK ADD  CONSTRAINT [CK_Person_EmailPromotion] CHECK  (([EmailPromotion]>=(0) AND [EmailPromotion]<=(2)))
GO

ALTER TABLE [Agents].[Person] CHECK CONSTRAINT [CK_Person_EmailPromotion]
GO

ALTER TABLE [Agents].[Person]  WITH CHECK ADD  CONSTRAINT [CK_Person_PersonType] CHECK  (([PersonType] IS NULL OR (upper([PersonType])='GC' OR upper([PersonType])='SP' OR upper([PersonType])='EM' OR upper([PersonType])='IN' OR upper([PersonType])='VC' OR upper([PersonType])='SC')))
GO

ALTER TABLE [Agents].[Person] CHECK CONSTRAINT [CK_Person_PersonType]
GO

-- Agents.ContactType
CREATE TABLE [Agents].[ContactType](
	[ContactTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ContactType_ContactTypeID] PRIMARY KEY CLUSTERED 
(
	[ContactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[ContactType] ADD  CONSTRAINT [DF_ContactType_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-- Agents.AgentContact
CREATE TABLE [Agents].[AgentContact](
	[AgentID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[ContactTypeID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AgentContact_AgentID_PersonID_ContactTypeID] PRIMARY KEY CLUSTERED 
    (
        [AgentID] ASC,
        [PersonID] ASC,
        [ContactTypeID] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[AgentContact] ADD  CONSTRAINT [DF_AgentContact_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[AgentContact] ADD  CONSTRAINT [DF_AgentContact_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[AgentContact]  WITH CHECK ADD  CONSTRAINT [FK_AgentContact_EconomicAgents_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[EconomicAgents] ([AgentID])
GO

ALTER TABLE [Agents].[AgentContact] CHECK CONSTRAINT [FK_AgentContact_EconomicAgents_AgentID]
GO

ALTER TABLE [Agents].[AgentContact]  WITH CHECK ADD  CONSTRAINT [FK_AgentContact_ContactType_ContactTypeID] FOREIGN KEY([ContactTypeID])
REFERENCES [Agents].[ContactType] ([ContactTypeID])
GO

ALTER TABLE [Agents].[AgentContact] CHECK CONSTRAINT [FK_AgentContact_ContactType_ContactTypeID]
GO

ALTER TABLE [Agents].[AgentContact]  WITH CHECK ADD  CONSTRAINT [FK_AgentContact_Person_PersonID] FOREIGN KEY([PersonID])
REFERENCES [Agents].[Person] ([AgentID])
GO

ALTER TABLE [Agents].[AgentContact] CHECK CONSTRAINT [FK_AgentContact_Person_PersonID]
GO

-- Agents.EmailAddress
CREATE TABLE [Agents].[EmailAddress](
	[AgentID] [int] NOT NULL,
	[EmailAddressID] [int] IDENTITY(1,1) NOT NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EmailAddress_AgentID_EmailAddressID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[EmailAddressID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[EmailAddress] ADD  CONSTRAINT [DF_EmailAddress_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[EmailAddress] ADD  CONSTRAINT [DF_EmailAddress_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[EmailAddress]  WITH CHECK ADD  CONSTRAINT [FK_EmailAddress_Agents_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[Person] ([AgentID])
GO

ALTER TABLE [Agents].[EmailAddress] CHECK CONSTRAINT [FK_EmailAddress_Agents_AgentID]
GO

-- Agents.CountryRegion
CREATE TABLE [Agents].[CountryRegion](
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CountryRegion_CountryRegionCode] PRIMARY KEY CLUSTERED 
(
	[CountryRegionCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[CountryRegion] ADD  CONSTRAINT [DF_CountryRegion_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-- Agents.SalesTerritory
CREATE TABLE [Agents].[SalesTerritory](
	[TerritoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Group] [nvarchar](50) NOT NULL,
	[SalesYTD] [money] NOT NULL,
	[SalesLastYear] [money] NOT NULL,
	[CostYTD] [money] NOT NULL,
	[CostLastYear] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesTerritory_TerritoryID] PRIMARY KEY CLUSTERED 
(
	[TerritoryID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[SalesTerritory] ADD  CONSTRAINT [DF_SalesTerritory_SalesYTD]  DEFAULT ((0.00)) FOR [SalesYTD]
GO

ALTER TABLE [Agents].[SalesTerritory] ADD  CONSTRAINT [DF_SalesTerritory_SalesLastYear]  DEFAULT ((0.00)) FOR [SalesLastYear]
GO

ALTER TABLE [Agents].[SalesTerritory] ADD  CONSTRAINT [DF_SalesTerritory_CostYTD]  DEFAULT ((0.00)) FOR [CostYTD]
GO

ALTER TABLE [Agents].[SalesTerritory] ADD  CONSTRAINT [DF_SalesTerritory_CostLastYear]  DEFAULT ((0.00)) FOR [CostLastYear]
GO

ALTER TABLE [Agents].[SalesTerritory] ADD  CONSTRAINT [DF_SalesTerritory_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[SalesTerritory] ADD  CONSTRAINT [DF_SalesTerritory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[SalesTerritory]  WITH CHECK ADD  CONSTRAINT [FK_SalesTerritory_CountryRegion_CountryRegionCode] FOREIGN KEY([CountryRegionCode])
REFERENCES [Agents].[CountryRegion] ([CountryRegionCode])
GO

ALTER TABLE [Agents].[SalesTerritory] CHECK CONSTRAINT [FK_SalesTerritory_CountryRegion_CountryRegionCode]
GO

ALTER TABLE [Agents].[SalesTerritory]  WITH CHECK ADD  CONSTRAINT [CK_SalesTerritory_CostLastYear] CHECK  (([CostLastYear]>=(0.00)))
GO

ALTER TABLE [Agents].[SalesTerritory] CHECK CONSTRAINT [CK_SalesTerritory_CostLastYear]
GO

ALTER TABLE [Agents].[SalesTerritory]  WITH CHECK ADD  CONSTRAINT [CK_SalesTerritory_CostYTD] CHECK  (([CostYTD]>=(0.00)))
GO

ALTER TABLE [Agents].[SalesTerritory] CHECK CONSTRAINT [CK_SalesTerritory_CostYTD]
GO

ALTER TABLE [Agents].[SalesTerritory]  WITH CHECK ADD  CONSTRAINT [CK_SalesTerritory_SalesLastYear] CHECK  (([SalesLastYear]>=(0.00)))
GO

ALTER TABLE [Agents].[SalesTerritory] CHECK CONSTRAINT [CK_SalesTerritory_SalesLastYear]
GO

ALTER TABLE [Agents].[SalesTerritory]  WITH CHECK ADD  CONSTRAINT [CK_SalesTerritory_SalesYTD] CHECK  (([SalesYTD]>=(0.00)))
GO

ALTER TABLE [Agents].[SalesTerritory] CHECK CONSTRAINT [CK_SalesTerritory_SalesYTD]
GO

--Agents.StateProvince

CREATE TABLE [Agents].[StateProvince](
	[StateProvinceID] [int] IDENTITY(1,1) NOT NULL,
	[StateProvinceCode] [nchar](3) NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[IsOnlyStateProvinceFlag] [dbo].[Flag] NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[TerritoryID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_StateProvince_StateProvinceID] PRIMARY KEY CLUSTERED 
(
	[StateProvinceID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[StateProvince] ADD  CONSTRAINT [DF_StateProvince_IsOnlyStateProvinceFlag]  DEFAULT ((1)) FOR [IsOnlyStateProvinceFlag]
GO

ALTER TABLE [Agents].[StateProvince] ADD  CONSTRAINT [DF_StateProvince_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[StateProvince] ADD  CONSTRAINT [DF_StateProvince_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[StateProvince]  WITH CHECK ADD  CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode] FOREIGN KEY([CountryRegionCode])
REFERENCES [Agents].[CountryRegion] ([CountryRegionCode])
GO

ALTER TABLE [Agents].[StateProvince] CHECK CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode]
GO

ALTER TABLE [Agents].[StateProvince]  WITH CHECK ADD  CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID] FOREIGN KEY([TerritoryID])
REFERENCES [Agents].[SalesTerritory] ([TerritoryID])
GO

ALTER TABLE [Agents].[StateProvince] CHECK CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID]
GO

-- Agents.AddressType
CREATE TABLE [Agents].[AddressType](
	[AddressTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AddressType_AddressTypeID] PRIMARY KEY CLUSTERED 
(
	[AddressTypeID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[AddressType] ADD  CONSTRAINT [DF_AddressType_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[AddressType] ADD  CONSTRAINT [DF_AddressType_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-- Agents.Address

CREATE TABLE [Agents].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[SpatialLocation] [geography] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Agents].[Address] ADD  CONSTRAINT [DF_Address_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[Address] ADD  CONSTRAINT [DF_Address_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_StateProvince_StateProvinceID] FOREIGN KEY([StateProvinceID])
REFERENCES [Agents].[StateProvince] ([StateProvinceID])
GO

ALTER TABLE [Agents].[Address] CHECK CONSTRAINT [FK_Address_StateProvince_StateProvinceID]
GO

-- Agents.EconomicAgentsAddress
CREATE TABLE [Agents].[EconomicAgentsAddress](
	[AgentID] [int] NOT NULL,
	[AddressID] [int] NOT NULL,
	[AddressTypeID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EconomicAgentsAddress_AgentID_AddressID_AddressTypeID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[AddressID] ASC,
	[AddressTypeID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[EconomicAgentsAddress] ADD  CONSTRAINT [DF_EconomicAgentsAddress_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[EconomicAgentsAddress] ADD  CONSTRAINT [DF_EconomicAgentsAddress_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[EconomicAgentsAddress]  WITH CHECK ADD  CONSTRAINT [FK_EconomicAgentsAddress_Address_AddressID] FOREIGN KEY([AddressID])
REFERENCES [Agents].[Address] ([AddressID])
GO

ALTER TABLE [Agents].[EconomicAgentsAddress] CHECK CONSTRAINT [FK_EconomicAgentsAddress_Address_AddressID]
GO

ALTER TABLE [Agents].[EconomicAgentsAddress]  WITH CHECK ADD  CONSTRAINT [FK_EconomicAgentsAddres_AddressType_AddressTypeID] FOREIGN KEY([AddressTypeID])
REFERENCES [Agents].[AddressType] ([AddressTypeID])
GO

ALTER TABLE [Agents].[EconomicAgentsAddress] CHECK CONSTRAINT [FK_EconomicAgentsAddres_AddressType_AddressTypeID]
GO

ALTER TABLE [Agents].[EconomicAgentsAddress]  WITH CHECK ADD  CONSTRAINT [FK_EconomicAgentsAddress_EconomicAgent_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[EconomicAgents] ([AgentID])
GO

ALTER TABLE [Agents].[EconomicAgentsAddress] CHECK CONSTRAINT [FK_EconomicAgentsAddress_EconomicAgent_AgentID]
GO

-- Agents.Shift
CREATE TABLE [Agents].[Shift](
	[ShiftID] [tinyint] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Shift_ShiftID] PRIMARY KEY CLUSTERED 
(
	[ShiftID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[Shift] ADD  CONSTRAINT [DF_Shift_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-- Agents.Department
CREATE TABLE [Agents].[Department](
	[DepartmentID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[GroupName] [dbo].[Name] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Department_DepartmentID] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[Department] ADD  CONSTRAINT [DF_Department_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-- Agents.Employee

CREATE TABLE [Agents].[Employee](
	[AgentID] [int] NOT NULL,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [hierarchyid] NULL,
	[OrganizationLevel]  AS ([OrganizationNode].[GetLevel]()),
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[SalariedFlag] [dbo].[Flag] NOT NULL,
	[VacationHours] [smallint] NOT NULL,
	[SickLeaveHours] [smallint] NOT NULL,
	[CurrentFlag] [dbo].[Flag] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Employee_AgentID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[Employee] ADD  CONSTRAINT [DF_Employee_SalariedFlag]  DEFAULT ((1)) FOR [SalariedFlag]
GO

ALTER TABLE [Agents].[Employee] ADD  CONSTRAINT [DF_Employee_VacationHours]  DEFAULT ((0)) FOR [VacationHours]
GO

ALTER TABLE [Agents].[Employee] ADD  CONSTRAINT [DF_Employee_SickLeaveHours]  DEFAULT ((0)) FOR [SickLeaveHours]
GO

ALTER TABLE [Agents].[Employee] ADD  CONSTRAINT [DF_Employee_CurrentFlag]  DEFAULT ((1)) FOR [CurrentFlag]
GO

ALTER TABLE [Agents].[Employee] ADD  CONSTRAINT [DF_Employee_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[Employee] ADD  CONSTRAINT [DF_Employee_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Person_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[Person] ([AgentID])
GO

ALTER TABLE [Agents].[Employee] CHECK CONSTRAINT [FK_Employee_Person_AgentID]
GO

ALTER TABLE [Agents].[Employee]  WITH CHECK ADD  CONSTRAINT [CK_Employee_BirthDate] CHECK  (([BirthDate]>='1930-01-01' AND [BirthDate]<=dateadd(year,(-18),getdate())))
GO

ALTER TABLE [Agents].[Employee] CHECK CONSTRAINT [CK_Employee_BirthDate]
GO

ALTER TABLE [Agents].[Employee]  WITH CHECK ADD  CONSTRAINT [CK_Employee_Gender] CHECK  ((upper([Gender])='F' OR upper([Gender])='M'))
GO

ALTER TABLE [Agents].[Employee] CHECK CONSTRAINT [CK_Employee_Gender]
GO

ALTER TABLE [Agents].[Employee]  WITH CHECK ADD  CONSTRAINT [CK_Employee_HireDate] CHECK  (([HireDate]>='1996-07-01' AND [HireDate]<=dateadd(day,(1),getdate())))
GO

ALTER TABLE [Agents].[Employee] CHECK CONSTRAINT [CK_Employee_HireDate]
GO

ALTER TABLE [Agents].[Employee]  WITH CHECK ADD  CONSTRAINT [CK_Employee_MaritalStatus] CHECK  ((upper([MaritalStatus])='S' OR upper([MaritalStatus])='M'))
GO

ALTER TABLE [Agents].[Employee] CHECK CONSTRAINT [CK_Employee_MaritalStatus]
GO

ALTER TABLE [Agents].[Employee]  WITH CHECK ADD  CONSTRAINT [CK_Employee_SickLeaveHours] CHECK  (([SickLeaveHours]>=(0) AND [SickLeaveHours]<=(120)))
GO

ALTER TABLE [Agents].[Employee] CHECK CONSTRAINT [CK_Employee_SickLeaveHours]
GO

ALTER TABLE [Agents].[Employee]  WITH CHECK ADD  CONSTRAINT [CK_Employee_VacationHours] CHECK  (([VacationHours]>=(-40) AND [VacationHours]<=(240)))
GO

ALTER TABLE [Agents].[Employee] CHECK CONSTRAINT [CK_Employee_VacationHours]
GO

-- Agents.EmployeePayHistory

CREATE TABLE [Agents].[EmployeePayHistory](
	[AgentID] [int] NOT NULL,
	[RateChangeDate] [datetime] NOT NULL,
	[Rate] [money] NOT NULL,
	[PayFrequency] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EmployeePayHistory_AgentID_RateChangeDate] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[RateChangeDate] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[EmployeePayHistory] ADD  CONSTRAINT [DF_EmployeePayHistory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[EmployeePayHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayHistory_Employee_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[Employee] ([AgentID])
GO

ALTER TABLE [Agents].[EmployeePayHistory] CHECK CONSTRAINT [FK_EmployeePayHistory_Employee_AgentID]
GO

ALTER TABLE [Agents].[EmployeePayHistory]  WITH CHECK ADD  CONSTRAINT [CK_EmployeePayHistory_PayFrequency] CHECK  (([PayFrequency]=(2) OR [PayFrequency]=(1)))
GO

ALTER TABLE [Agents].[EmployeePayHistory] CHECK CONSTRAINT [CK_EmployeePayHistory_PayFrequency]
GO

ALTER TABLE [Agents].[EmployeePayHistory]  WITH CHECK ADD  CONSTRAINT [CK_EmployeePayHistory_Rate] CHECK  (([Rate]>=(6.50) AND [Rate]<=(200.00)))
GO

ALTER TABLE [Agents].[EmployeePayHistory] CHECK CONSTRAINT [CK_EmployeePayHistory_Rate]
GO

-- Agents.EmployeeDepartmentHistory

CREATE TABLE [Agents].[EmployeeDepartmentHistory](
	[AgentID] [int] NOT NULL,
	[DepartmentID] [smallint] NOT NULL,
	[ShiftID] [tinyint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EmployeeDepartmentHistory_AgentID_StartDate_DepartmentID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[StartDate] ASC,
	[DepartmentID] ASC,
	[ShiftID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory] ADD  CONSTRAINT [DF_EmployeeDepartmentHistory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID] FOREIGN KEY([DepartmentID])
REFERENCES [Agents].[Department] ([DepartmentID])
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory] CHECK CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID]
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[Employee] ([AgentID])
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory] CHECK CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_AgentID]
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID] FOREIGN KEY([ShiftID])
REFERENCES [Agents].[Shift] ([ShiftID])
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory] CHECK CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID]
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory]  WITH CHECK ADD  CONSTRAINT [CK_EmployeeDepartmentHistory_EndDate] CHECK  (([EndDate]>=[StartDate] OR [EndDate] IS NULL))
GO

ALTER TABLE [Agents].[EmployeeDepartmentHistory] CHECK CONSTRAINT [CK_EmployeeDepartmentHistory_EndDate]
GO

-- Agents.Password

CREATE TABLE [Agents].[Password](
	[AgentID] [int] NOT NULL,
	[PasswordHash] [varchar](128) NOT NULL,
	[PasswordSalt] [varchar](10) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Password_AgentID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[Password] ADD  CONSTRAINT [DF_Password_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE [Agents].[Password] ADD  CONSTRAINT [DF_Password_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[Password]  WITH CHECK ADD  CONSTRAINT [FK_Password_Person_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[Person] ([AgentID])
GO

ALTER TABLE [Agents].[Password] CHECK CONSTRAINT [FK_Password_Person_AgentID]
GO

-- Agents.PhoneNumberType
CREATE TABLE [Agents].[PhoneNumberType](
	[PhoneNumberTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PhoneNumberType_PhoneNumberTypeID] PRIMARY KEY CLUSTERED 
(
	[PhoneNumberTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[PhoneNumberType] ADD  CONSTRAINT [DF_PhoneNumberType_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-- Agents.PersonPhone

CREATE TABLE [Agents].[PersonPhone](
	[AgentID] [int] NOT NULL,
	[PhoneNumber] [dbo].[Phone] NOT NULL,
	[PhoneNumberTypeID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PersonPhone_AgentID_PhoneNumber_PhoneNumberTypeID] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[PhoneNumber] ASC,
	[PhoneNumberTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Agents].[PersonPhone] ADD  CONSTRAINT [DF_PersonPhone_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [Agents].[PersonPhone]  WITH CHECK ADD  CONSTRAINT [FK_PersonPhone_Person_AgentID] FOREIGN KEY([AgentID])
REFERENCES [Agents].[Person] ([AgentID])
GO

ALTER TABLE [Agents].[PersonPhone] CHECK CONSTRAINT [FK_PersonPhone_Person_AgentID]
GO

ALTER TABLE [Agents].[PersonPhone]  WITH CHECK ADD  CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID] FOREIGN KEY([PhoneNumberTypeID])
REFERENCES [Agents].[PhoneNumberType] ([PhoneNumberTypeID])
GO

ALTER TABLE [Agents].[PersonPhone] CHECK CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID]
GO

-- 



















