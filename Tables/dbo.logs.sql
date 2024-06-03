CREATE TABLE [dbo].[logs]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[json] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[date] [datetime] NULL,
[batchid] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[logs] ADD CONSTRAINT [PK__logs__3213E83F15E6916C] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
