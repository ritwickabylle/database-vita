SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[GetIrnForFileUpload]   
@batchid int=2385,   
@tenantId int = 127   
AS   
BEGIN   
select CAST(S.Id AS INT) as IRNNo,  
h.TransTypeDescription  
FROM Draft s  
inner join FileUpload_TransactionHeader h on s.UniqueIdentifier=h.UniqueIdentifier  
where h.batchId=@batchid and h.tenantid=@tenantId  
END
GO
