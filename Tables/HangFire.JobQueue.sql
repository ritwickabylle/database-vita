CREATE TABLE [HangFire].[JobQueue]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[JobId] [bigint] NOT NULL,
[Queue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FetchedAt] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [HangFire].[JobQueue] ADD CONSTRAINT [PK_HangFire_JobQueue] PRIMARY KEY CLUSTERED ([Queue], [Id]) ON [PRIMARY]
GO
