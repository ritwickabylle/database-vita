CREATE TABLE [HangFire].[Counter]
(
[Key] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [int] NOT NULL,
[ExpireAt] [datetime] NULL,
[Id] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [HangFire].[Counter] ADD CONSTRAINT [PK_HangFire_Counter] PRIMARY KEY CLUSTERED ([Key], [Id]) ON [PRIMARY]
GO
