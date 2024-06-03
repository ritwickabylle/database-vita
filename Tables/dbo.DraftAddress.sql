CREATE TABLE [dbo].[DraftAddress]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalStreet] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuildingNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Neighbourhood] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DraftAddress] ADD CONSTRAINT [PK_DraftAddress] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DraftAddress_TenantId] ON [dbo].[DraftAddress] ([TenantId]) ON [PRIMARY]
GO
