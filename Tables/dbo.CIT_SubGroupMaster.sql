CREATE TABLE [dbo].[CIT_SubGroupMaster]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[tenantid] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NULL,
[SubGroup] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[MainGroup] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISBS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_SubGroupMaster] ADD CONSTRAINT [PK__CIT_SubG__3214EC0744DA934E] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
