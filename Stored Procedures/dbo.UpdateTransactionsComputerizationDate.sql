SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[UpdateTransactionsComputerizationDate]    
(    
@tenantid int = 159,    
@tcDate nvarchar(100) = '2024-09-09'
)    
as    
begin    
   update TenantBasicDetails set TransactionsComputerizationDate = @tcDate where TenantId=@tenantid    
      
end
GO
