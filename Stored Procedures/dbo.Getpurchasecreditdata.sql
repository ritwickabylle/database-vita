SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
CREATE           PROCEDURE [dbo].[Getpurchasecreditdata]                
@fromDate Datetime,                
@toDate Datetime,            
@tenantId int =null           
AS        
SET NOCOUNT ON        
        
select                 
  s.Id as InvoiceId,                 
  format(s.IssueDate,'dd-MM-yyyy') as InvoiceDate,              
  s.BillingReferenceId as ReferenceNumber,              
  i.LineAmountInclusiveVAT as Amount,                 
  b.RegistrationName as CustomerName,                 
  c.ContactNumber as ContactNo,              
  s.UniqueIdentifier              
from                 
  PurchaseCreditNote s with (nolock)        
  inner join (select sum(LineAmountInclusiveVAT) as LineAmountInclusiveVAT,IRNNo,TenantId               
  from PurchaseCreditNoteItem with (nolock)              
  group by IRNNo,TenantId) i on s.id = i.IRNNo and Isnull(i.tenantid,0)=isnull(@tenantId,0) and Isnull(s.tenantid,0)=isnull(@tenantId,0)              
  inner join IRNMaster m with (nolock) on s.id = m.IRNNo and Isnull(m.tenantid,0)=isnull(@tenantId,0)            
  inner join PurchaseCreditNotePartiy b with (nolock) on s.id = b.IRNNo and Isnull(b.tenantid,0)=isnull(@tenantId,0)                
  and b.Type = 'Supplier'                 
  inner join PurchaseCreditNoteContactPerson c with (nolock) on s.id = c.IRNNo  and Isnull(c.tenantid,0)=isnull(@tenantId,0)               
  and c.Type = 'Supplier'                 
  where CAST(s.IssueDate AS DATE)>=CAST(@fromDate as date) and CAST(s.IssueDate AS DATE)<=CAST(@toDate as date)                   
  order by s.CreationTime desc
GO
