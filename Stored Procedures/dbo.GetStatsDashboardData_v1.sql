SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[GetStatsDashboardData_v1]    --GetStatsDashboardData '2022-07-01','2022-12-31',19  
(@fromDate datetime,       
@toDate datetime,    
@tenantId int=null)        
                  
as    
begin   
  
declare @sales decimal(18,2),  
@credit decimal(18,2),  
@debit decimal(18,2),  
@salesvat decimal(18,2),  
@creditvat decimal(18,2),  
@debitvat decimal(18,2)  
  
set @sales=(select isnull(sum(LineNetAmount),0.00) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Sales%')  
  
set @salesvat=(select isnull(sum(VATLineAmount),0.00)  from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Sales%')  
  
set @credit=(select isnull(sum(LineNetAmount),0.00) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Credit%')  
  
set @creditvat=(select isnull(sum(VATLineAmount),0.00) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Credit%')  
  
set @debit=(select isnull(sum(LineNetAmount),0.00)  from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Debit%')  
  
set @debitvat=(select isnull(sum(VATLineAmount),0.00)  from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Debit%')  
  
-----------------------------------------------------------------------------------------------------------------------------------------------  
select isnull(sum(LineNetAmount),0.00) as amount,  
isnull(sum(VATLineAmount),0.00) as vatAmount,  
isnull(sum(LineNetAmount),0.00)+isnull(sum(VATLineAmount),0.00) as totalAmount,  
(select count(1) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Sales%') as count,  
'Sales' as type from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Sales%'  
    
union   
select isnull(sum(LineNetAmount),0.00) as amount,  
isnull(sum(VATLineAmount),0.00) as vatAmount,  
isnull(sum(LineNetAmount),0.00)+isnull(sum(VATLineAmount),0.00) as totalAmount,  
(select count(1) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Credit%') as count,  
'Credit' as type from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Credit%'  
  
union  
select isnull(sum(LineNetAmount),0.00) as amount,  
isnull(sum(VATLineAmount),0.00) as vatAmount,  
isnull(sum(LineNetAmount),0.00)+isnull(sum(VATLineAmount),0.00) as totalAmount,  
(select count(1) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Debit%') as count,  
'Debit' as type from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and InvoiceType like 'Debit%'  
  
  union   
    
  select isnull((@sales+@debit-@credit),0.00) as amount,  
  isnull((@salesvat+@debitvat-@creditvat),0.00) as vatAmount,  
  isnull((@sales+@debit-@credit),0.00)+isnull((@salesvat+@debitvat-@creditvat),0.00) as totalAmount,  
  (select isnull(count(1),0) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and (InvoiceType like 'Sales%' or InvoiceType like 'Debit%' or InvoiceType like 'Credit%')) as count,  
  'Total' as type from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
IssueDate>=@fromDate and IssueDate<=@toDate   
and (InvoiceType like 'Sales%' or InvoiceType like 'Debit%' or InvoiceType like 'Credit%')  
end
GO
