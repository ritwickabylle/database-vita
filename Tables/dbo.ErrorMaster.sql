CREATE TABLE [dbo].[ErrorMaster]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ErrorCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[successMessage] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[failureMessage] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
