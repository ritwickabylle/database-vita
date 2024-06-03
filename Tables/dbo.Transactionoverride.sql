CREATE TABLE [dbo].[Transactionoverride]
(
[uniqueidentifier] [uniqueidentifier] NULL,
[tenantid] [int] NULL,
[batchid] [int] NULL,
[errortype] [bigint] NULL,
[creationtime] [datetime2] NULL,
[errormsg] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
