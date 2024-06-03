CREATE TABLE [dbo].[RulesEngineLog]
(
[TableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordId] [int] NULL,
[isSuccess] [int] NULL,
[batchId] [int] NULL,
[errorCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[refBatchId] [int] NULL,
[Field] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__RulesEngi__Field__541767F8] DEFAULT (NULL)
) ON [PRIMARY]
GO
