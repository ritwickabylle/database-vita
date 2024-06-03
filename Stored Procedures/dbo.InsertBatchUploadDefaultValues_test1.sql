SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE   PROCEDURE [dbo].[InsertBatchUploadDefaultValues_test1]
(
    -- Add the parameters for the stored procedure here
@BatchId int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
Declare @Desc nvarchar(20) = ''
declare @type as nvarchar(25)=''
declare @catg as nvarchar(25)=''
declare @tenantid as int

	--set @type = (select type from BatchData where BatchId = @BatchId) 
	set @tenantid = (select type from BatchData where BatchId = @BatchId) 


	Insert into Logs( [json]
      ,[date]
      ,[batchid])
	  Values('InsertBatchUploadDefaultValues Called ', GetDate(),@BatchId)

END
GO
