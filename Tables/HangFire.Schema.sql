CREATE TABLE [HangFire].[Schema]
(
[Version] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [HangFire].[Schema] ADD CONSTRAINT [PK_HangFire_Schema] PRIMARY KEY CLUSTERED ([Version]) ON [PRIMARY]
GO
