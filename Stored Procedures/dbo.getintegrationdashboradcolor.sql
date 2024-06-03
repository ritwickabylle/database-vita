SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[getintegrationdashboradcolor]        --exec getintegrationdashboradcolor '2023-01-01','2023-02-28',45,'Sales' 
@fromdate date,          
@todate date,          
@tenantid int=Null,          
@type nvarchar(max)          
as          
begin       
if(@type='Sales')          
begin    
select 'blue' as 'Invoice Reference Number',    
'blue' as 'Customer Name',    
'blue'  as 'Issue Date',    
'blue'  as 'Input Data',    
'green' 'IRN No',    
'green' as 'Invoice Date',    
'green' as 'Status',    
'green' as 'Download',    
'yellow' as 'Sent To ZATCA',    
'yellow' as 'ZATCA Status',    
dbo.get_errormessage_v2(ie.uniqueIdentifier,@tenantId)  error  from ImportBatchData ib            
left join logs_xml lg on ib.UniqueIdentifier=lg.uuid      
left join (select * from SalesInvoice where TenantId=@tenantid) sl on sl.InvoiceNumber=ib.InvoiceNumber 
inner join(select * from  SalesInvoiceParty where Type like '%Buyer%' and tenantid=@tenantid)sp on sp.IRNNo=sl.IRNNo    
inner join (select distinct uniqueIdentifier,Status from importstandardfiles_ErrorLists where tenantid=@tenantid group by uniqueIdentifier,Status)  ie on ib.UniqueIdentifier=ie.uniqueIdentifier    
where ib.issuedate>= cast(@fromdate as date) and ib.issuedate <= cast(@todate as date) and ib.InvoiceType like '%Sales%' and ib.TenantId=@tenantid  order by sl.InvoiceNumber    
end    

if(@type='Credit')          
begin    
select 'blue' as 'Invoice Reference Number',    
'blue' as 'Billing Reference Id',    
'blue' as 'Customer Name',    
'blue'  as 'Issue Date',    
'blue'  as 'Input Data',    
'green' 'IRN No',    
'green' as 'Invoice Date',    
'green' as 'Status',    
'green' as 'Download',    
'yellow' as 'Sent To ZATCA',    
'yellow' as 'ZATCA Status',    
dbo.get_errormessage_v2(ie.uniqueIdentifier,@tenantid) as  error  from ImportBatchData ib            
left join logs_xml lg on ib.UniqueIdentifier=lg.uuid      
left join (select * from CreditNote where TenantId=@tenantid) cn on cn.InvoiceNumber=ib.InvoiceNumber 
inner join(select * from  CreditNoteParty where Type like '%Buyer%' and tenantid=@tenantid)cp on cp.IRNNo=cn.IRNNo    
inner join (select distinct uniqueIdentifier,Status from importstandardfiles_ErrorLists where tenantid=@tenantid group by uniqueIdentifier,Status)  ie on ib.UniqueIdentifier=ie.uniqueIdentifier    
where ib.issuedate>= cast(@fromdate as date) and ib.issuedate <= cast(@todate as date) and ib.InvoiceType like '%Credit%' and ib.TenantId=@tenantid and cp.Type like '%Buyer%'  order by cn.InvoiceNumber    
end    

  if(@type='Debit')          
begin    
select 'blue' as 'Invoice Reference Number',    
'blue' as 'Billing Reference Id',    
'blue' as 'Customer Name',    
'blue'  as 'Issue Date',    
'blue'  as 'Input Data',    
'green' 'IRN No',    
'green' as 'Invoice Date',    
'green' as 'Status',    
'green' as 'Download',    
'yellow' as 'Sent To ZATCA',    
'yellow' as 'ZATCA Status',    
dbo.get_errormessage_v2(ie.uniqueIdentifier,@tenantid) as  error  from ImportBatchData ib            
left join logs_xml lg on ib.UniqueIdentifier=lg.uuid     
left join (select * from DebitNote where TenantId=@tenantid) dn on dn.InvoiceNumber=ib.InvoiceNumber 
inner join(select * from  DebitNoteParty where Type like '%Buyer%' and tenantid=@tenantid)dp on dp.IRNNo=dn.IRNNo    
inner join (select distinct uniqueIdentifier,Status from importstandardfiles_ErrorLists where tenantid=@tenantid group by uniqueIdentifier,Status)  ie on ib.UniqueIdentifier=ie.uniqueIdentifier     
WHERE ib.issuedate>= cast(@fromdate as date) and ib.issuedate <= cast(@todate as date) and ib.InvoiceType like '%Debit%' and ib.TenantId=@tenantid and dp.Type like '%Buyer%'  order by dn.InvoiceNumber   
end    

end
GO
