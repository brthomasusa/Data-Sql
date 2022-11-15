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



