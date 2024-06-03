CREATE TABLE [dbo].[CIT_MainGroupMaster]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[tenantid] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NULL,
[MainGroup] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISBS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[CreationTime] [datetime2] NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_MainGroupMaster] ADD CONSTRAINT [PK__CIT_Main__3214EC076B765550] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
