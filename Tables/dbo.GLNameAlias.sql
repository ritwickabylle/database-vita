CREATE TABLE [dbo].[GLNameAlias]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Uniqueidentifier] [uniqueidentifier] NULL,
[tenantid] [int] NULL,
[GLCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLNameAlias] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Taxcode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinStartDate] [datetime] NULL,
[FinEndDate] [datetime] NULL,
[CreationTime] [datetime] NULL,
[CreatorUserId] [int] NULL,
[LastModificationTime] [datetime] NULL,
[LastModifiedUserId] [int] NULL,
[IsDeleted] [bit] NULL,
[DeletedUserId] [int] NULL,
[DeletionTime] [datetime] NULL,
[IsActive] [bit] NULL
) ON [PRIMARY]
GO
