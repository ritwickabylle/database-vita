SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[GetStatsDashboardData]    --GetStatsDashboardData '2023-02-02','2023-02-03',45  
(@fromDate datetime,       
@toDate datetime,    
@tenantId int=null)        
                  
as    
begin   
  
declare 
@sales decimal(18,2),  
@credit decimal(18,2),  
@debit decimal(18,2),  
@salesvat decimal(18,2),  
@creditvat decimal(18,2),  
@debitvat decimal(18,2)  
  
set @sales=(select isnull(sum(LineNetAmount),0.00) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Sales%')  
  
set @salesvat=(select isnull(sum(VATLineAmount),0.00)  from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Sales%')  
  
set @credit=(select isnull(sum(LineNetAmount),0.00) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Credit%')  
  
set @creditvat=(select isnull(sum(VATLineAmount),0.00) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Credit%')  
  
set @debit=(select isnull(sum(LineNetAmount),0.00)  from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Debit%')  
  
set @debitvat=(select isnull(sum(VATLineAmount),0.00)  from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Debit%')  

declare  @statsdata as table
(
 slno int,
  amount float,  
   vatAmount float,  
   totalAmount float,  
   count int,  
   type nvarchar(max) 
)
  
-----------------------------------------------------------------------------------------------------------------------------------------------  
insert into @statsdata
select 1,isnull(sum(LineNetAmount),0.00) as amount,  
isnull(sum(VATLineAmount),0.00) as vatAmount,  
isnull(sum(LineNetAmount),0.00)+isnull(sum(VATLineAmount),0.00) as totalAmount,  
(select count(1) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Sales%' and InvoiceLineIdentifier=1) as count,  
'Sales' as type from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Sales%'  
    
--union 
insert into @statsdata
select 2,cast('-'+cast(isnull(sum(LineNetAmount),0.00) as nvarchar) as float) as amount,  
cast('-'+cast(isnull(sum(VATLineAmount),0.00) as nvarchar)as float) as vatAmount,  
cast('-'+cast(isnull(sum(LineNetAmount),0.00)+isnull(sum(VATLineAmount),0.00) as nvarchar) as float) as totalAmount,  
(select count(1) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Credit%'  and InvoiceLineIdentifier=1) as count,  
'Credit' as type from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Credit%'  
  
--union
insert into @statsdata
select 3,isnull(sum(LineNetAmount),0.00) as amount,  
isnull(sum(VATLineAmount),0.00) as vatAmount,  
isnull(sum(LineNetAmount),0.00)+isnull(sum(VATLineAmount),0.00) as totalAmount,  
(select count(1) from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Debit%'  and InvoiceLineIdentifier=1) as count,  
'Debit' as type from VI_importstandardfiles_Processed    
where TenantId=@tenantId and   
cast(IssueDate as date)>=@fromDate and cast(IssueDate as date)<=@toDate   
and InvoiceType like 'Debit%'  
  
 -- union   
  insert into @statsdata  
  select 4, 
  (isnull(t1.amount,0)+isnull(t3.amount,0)+isnull(t2.amount,0)) as amount,
  (isnull(t1.vatamount,0)+isnull(t3.vatamount,0)+isnull(t2.vatamount,0)) as vatamount,
  (isnull(t1.totalamount,0)+isnull(t3.totalamount,0)+isnull(t2.totalamount,0)) as totalAmount,
  (isnull(t1.count,0)+isnull(t2.count,0)+isnull(t3.count,0)) as count,
  'Total' as type
  from @statsdata t1 cross join @statsdata t2 cross join @statsdata t3 where t1.slno=1 and t2.slno = 2 and t3.slno=3

  
  
  --sum(isnull((amount),0.00)) as amount,  
  --sum(isnull((vatamount),0.00)) as vatAmount,  
  --sum(isnull(totalamount,0.00)) as totalAmount,  
  --sum(isnull(count,0)),'Total' from @statsdata 


select * from @statsdata order by slno
 end
GO
