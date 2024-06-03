CREATE TABLE [dbo].[BatchMasterData]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[BatchId] [bigint] NOT NULL,
[FileName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalRecords] [int] NOT NULL,
[SuccessRecords] [int] NULL,
[FailedRecords] [int] NULL,
[Status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilePath] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataPath] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[fromDate] [datetime2] NULL,
[toDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BatchMasterData] ADD CONSTRAINT [PK_BatchMasterData] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
