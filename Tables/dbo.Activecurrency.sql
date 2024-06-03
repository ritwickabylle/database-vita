CREATE TABLE [dbo].[Activecurrency]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[Entity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Currency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlphabeticCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumericCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinorUnit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Activecurrency] ADD CONSTRAINT [PK_Activecurrency] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Activecurrency_TenantId] ON [dbo].[Activecurrency] ([TenantId]) ON [PRIMARY]
GO
