CREATE TABLE [dbo].[CITScheduleBatchData]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NULL,
[BatchNo] [int] NULL,
[ScheduleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadedOn] [datetime] NULL,
[UploadedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalRecord] [int] NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
