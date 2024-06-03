SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[CheckIfRefNumExists]  
(  
@refnum nvarchar(200) ,  
@tenantid int  
)  
as  
begin  
select count(*) as count from SalesInvoice with(nolock) where BillingReferenceId=@refnum and tenantid=@tenantid  
end
GO
