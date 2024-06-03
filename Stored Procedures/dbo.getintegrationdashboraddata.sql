SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE         procedure [dbo].[getintegrationdashboraddata]         --exec [getintegrationdashboraddata] '2023-05-01','2023-05-28',49,'Sales'   
@fromdate date,            
@todate date,            
@tenantid int=Null,            
@type nvarchar(max)            
as            
begin            
if(@type='Sales')          
begin          
select    
sl.InvoiceNumber as 'Invoice Reference Number',    
sp.RegistrationName as 'Customer Name',    
format(IB.IssueDate,'dd-MM-yyyy')  as 'Issue Date',    
case when (ie.Status=1) then 'Pass' else 'Fail' end as 'Input Data',    
case when (ie.Status=1) then (sl.IRNNo) else ' ' end as 'IRN No',    
case when (ie.Status=1) then format(IB.CreationTime,'dd-MM-yyyy') else ' ' end as 'Invoice Date',    
case when (ie.Status=1) then 'Pass' else ' ' end as Status,    
case when (ie.Status=1) then CAST(ir.UniqueIdentifier AS nvarchar(max)) else 'null' end as 'Download',    
case when (ie.Status=1) then format(IB.CreationTime,'dd-MM-yyyy') else ' ' end as 'Sent To ZATCA', 
case when (ie.Status=1) then lg.totalAmount else null end as 'Amount',    
case when (ie.Status=1) then
Case when
(lg.totalAmount<1000 and len(isnull(lg.errors,'')) = 0  )
then  isNull(lg.reportInvoiceResponse,' ')  
when (lg.totalAmount>1000 and len(isnull(lg.errors,'')) = 0  ) then isNull(lg.clearanceResponse,' ') 
else isnull(lg.complianceInvoiceResponse,' ') end  
else ' ' end 
 as 'ZATCA Status'      
from ImportBatchData ib            
left join logs_xml lg on ib.UniqueIdentifier=lg.uuid      
left join (select * from SalesInvoice where TenantId=@tenantid) sl on sl.InvoiceNumber=ib.InvoiceNumber 
inner join (select * from IRNMaster where TransactionType like '%Sales%' and TenantId =@tenantid) ir on ir.IRNNo=sl.IRNNo      
inner join(select * from  SalesInvoiceParty where Type like '%Buyer%' and tenantid=@tenantid)sp on sp.IRNNo=sl.IRNNo    
inner join (select distinct uniqueIdentifier,Status from importstandardfiles_ErrorLists where tenantid=@tenantid group by Batchid,id,uniqueIdentifier,Status) ie on ib.UniqueIdentifier=ie.uniqueIdentifier    
where ib.issuedate>= cast(@fromdate as date) and ib.issuedate <= cast(@todate as date)  and ib.InvoiceType like '%Sales%' and ib.TenantId=@tenantid    order by sl.InvoiceNumber 
end          

 

if(@type='Credit')          
begin          
select cn.InvoiceNumber as 'Invoice Reference Number',    
cp.RegistrationName as 'Customer Name',    
isnull(cn.BillingReferenceId,'') as 'Billing Reference Id',    
format(IB.IssueDate,'dd-MM-yyyy') as 'Issue Date',    
case when (ie.Status=1) then 'Pass' else 'Fail' end as 'Input Data',    
case when (ie.Status=1) then (cn.IRNNo) else ' ' end as 'IRN No',    
--case when len(cn.IRNNo)=0 then 1 else isnull(cn.IRNNo,0)end as 'IRN No',    
case when (ie.Status=1) then 'Pass' else ' ' end as Status,    
case when (ie.Status=1) then format(IB.CreationTime,'dd-MM-yyyy') else ' ' end as  'Invoice Date',    
case when (ie.Status=1) then CAST(ir.UniqueIdentifier AS nvarchar(max)) else 'null' end  as 'Download',    
case when (ie.Status=1) then format(IB.CreationTime,'dd-MM-yyyy') else ' ' end  as 'Sent To ZATCA' , 
case when (ie.Status=1) then lg.totalAmount else null end as 'Amount',    
case when (ie.Status=1) then
Case when
(lg.totalAmount<1000 and len(isnull(lg.errors,'')) = 0  )
then  isNull(lg.reportInvoiceResponse,' ') 
when (lg.totalAmount>1000 and len(isnull(lg.errors,'')) = 0  ) then isNull(lg.clearanceResponse,' ') 
else isnull(lg.complianceInvoiceResponse,' ') end  
else ' ' end as 'ZATCA Status'  
from ImportBatchData ib            
left join logs_xml lg on ib.UniqueIdentifier=lg.uuid      
left join (select * from CreditNote where TenantId=@tenantid) cn on cn.InvoiceNumber=ib.InvoiceNumber 
inner join (select * from IRNMaster where TransactionType like '%Credit%' and TenantId =@tenantid) ir on ir.IRNNo=cn.IRNNo      
inner join(select * from  CreditNoteParty where Type like '%Buyer%' and tenantid=@tenantid)cp on cp.IRNNo=cn.IRNNo    
inner join (select distinct uniqueIdentifier,Status from importstandardfiles_ErrorLists where tenantid=@tenantid group by uniqueIdentifier,Status)  ie on ib.UniqueIdentifier=ie.uniqueIdentifier    
where ib.issuedate>= cast(@fromdate as date) and ib.issuedate <= cast(@todate as date) and ib.InvoiceType like '%Credit%' and ib.TenantId=@tenantid   order by cn.InvoiceNumber 
end       
if(@type='Debit')          
begin          
select dn.InvoiceNumber as 'Invoice Reference Number',    
dp.RegistrationName as 'Customer Name',    
dn.BillingReferenceId as 'Billing Reference Id',    
format(IB.IssueDate,'dd-MM-yyyy') as 'Issue Date',    
case when (ie.Status=1) then 'Pass' else 'Fail' end as 'Input Data',    
case when (ie.Status=1) then dn.IRNNo else ' ' end as 'IRN No',    
case when (ie.Status=1) then format(IB.CreationTime,'dd-MM-yyyy') else ' ' end as 'Invoice Date',    
case when (ie.Status=1) then 'Pass' else ' ' end as Status,    
case when (ie.Status=1) then CAST(ir.UniqueIdentifier AS nvarchar(max)) else 'null' end as 'Download',    
case when (ie.Status=1) then format(IB.CreationTime,'dd-MM-yyyy') else ' ' end as 'Sent To ZATCA' ,  
case when (ie.Status=1) then lg.totalAmount else null end as 'Amount',    
case when (ie.Status=1) then
Case when
(lg.totalAmount<1000 and len(isnull(lg.errors,'')) = 0  )
then  isNull(lg.reportInvoiceResponse,' ') 
when (lg.totalAmount>1000 and len(isnull(lg.errors,'')) = 0  ) then isNull(lg.clearanceResponse,' ') 
else isnull(lg.complianceInvoiceResponse,' ') end  
else ' ' end as 'ZATCA Status'  from ImportBatchData ib            
left join logs_xml lg on ib.UniqueIdentifier=lg.uuid     
left join (select * from DebitNote where TenantId=@tenantid) dn on dn.InvoiceNumber=ib.InvoiceNumber 
inner join(select * from  DebitNoteParty where Type like '%Buyer%' and tenantid=@tenantid)dp on dp.IRNNo=dn.IRNNo    
inner join (select * from IRNMaster where TransactionType like '%Debit%' and TenantId =@tenantid) ir on ir.IRNNo=dn.IRNNo      
inner join (select distinct uniqueIdentifier,Status from importstandardfiles_ErrorLists where tenantid=@tenantid group by uniqueIdentifier,Status)  ie on ib.UniqueIdentifier=ie.uniqueIdentifier     
WHERE ib.issuedate>= cast(@fromdate as date) and ib.issuedate <= cast(@todate as date) and ib.InvoiceType like '%Debit%' and ib.TenantId=@tenantid   order by dn.InvoiceNumber       
end       
end
GO
