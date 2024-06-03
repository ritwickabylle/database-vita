CREATE TABLE [dbo].[AbpBackgroundJobs]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[IsAbandoned] [bit] NOT NULL,
[JobArgs] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobType] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastTryTime] [datetime2] NULL,
[NextTryTime] [datetime2] NOT NULL,
[Priority] [tinyint] NOT NULL,
[TryCount] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpBackgroundJobs] ADD CONSTRAINT [PK_AbpBackgroundJobs] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpBackgroundJobs_IsAbandoned_NextTryTime] ON [dbo].[AbpBackgroundJobs] ([IsAbandoned], [NextTryTime]) ON [PRIMARY]
GO
