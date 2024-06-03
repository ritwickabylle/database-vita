CREATE TABLE [dbo].[importmaster_ErrorLists]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[Batchid] [int] NOT NULL,
[uniqueIdentifier] [uniqueidentifier] NOT NULL,
[Status] [bit] NOT NULL,
[ErrorType] [bigint] NOT NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[importmaster_ErrorLists] ADD CONSTRAINT [pk_importmaster_ErrorLists] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
