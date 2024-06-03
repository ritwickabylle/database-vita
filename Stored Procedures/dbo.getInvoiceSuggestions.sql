SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[getInvoiceSuggestions]  --getInvoiceSuggestions null,9300000014,127  
(    
@irrno bigint=null,    
@refNo nvarchar(100)=null,  
@tenantId int    
)    
as    
begin   
if( @irrno is not null)  
begin  
select IRNNo as IRNNo,format(IssueDate,'dd-MM-yyyy') as IssueDate from SalesInvoice    
where IRNNo LIKE concat('%',@irrno,'%') and TenantId=@tenantId   
end  
else  
begin  
select BillingReferenceId as InvoiceNumber,format(IssueDate,'dd-MM-yyyy') as IssueDate from SalesInvoice    
where BillingReferenceId LIKE concat('%',@refNo,'%') and TenantId=@tenantId  
end  
end
GO
