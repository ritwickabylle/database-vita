SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    procedure [dbo].[ViewInvoice]  --ViewInvoice 2331,140,'draft'    
@irrno nvarchar(max)='',    
@tenantid int=127,    
@type nvarchar(max)=''    
as    
begin    
declare @yourvendor nvarchar(max)  


    
 if(@type ='sales')    
 begin  
 
  update SalesInvoiceItem
 SET Description = dbo.udf_RemoveHTMLTagsFromString(Description) where IRNNo = @irrno and TenantId = @tenantid


select     
format(s.IssueDate,'dd-MM-yyyy') as IssueDate,    
b.VATID as VAT,    
b.CustomerId as CustomerId,    
c.ContactNumber as ContactNumber,    
c.Email as Email,    
concat(sa.BuildingNo,' ',sa.Street,' ',sa.AdditionalStreet,' ',sa.Neighbourhood,' ',sa.city,' ',sa.State) as CusAdd1,    
concat(sa.AdditionalStreet,',',sa.Neighbourhood) as CusAdd2,    
concat(sa.city,',',sa.State) as CusAdd3,    
concat(sa.CountryCode,',',sa.PostalCode) as CusAdd4,    
c.Name as BilltoAttn,    
isnull(b.OtherDocumentTypeId,b.OtherID) as BuyerType,    
s.AdditionalData2 as AdditionalData,    
s.AdditionalData1 as exchange,    
b.AdditionalData1 as shipment,    
'' as error,    
(select  yourvendor from openjson(s.AdditionalData2) with    
(  yourvendor nvarchar(200) '$."we_are_your_vendor#"'        
)) as youvendor    
,s.AccountName    
,s.AccountNumber    
,s.BankName    
,s.SwiftCode,    
s.IBAN    
, *    
from salesinvoice s  WITH (NOLOCK)    
  INNER JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,max(Vatrate) as VatRate    
  FROM SalesInvoiceItem   WITH (NOLOCK)    
  GROUP BY IRNNo,TenantId) i ON s.IRNNo = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
    
     
    
  left JOIN (SELECT SUM(UnitPrice) AS UnitPrice,IRNNo,TenantId    
  FROM SalesInvoiceItem   WITH (NOLOCK) where isOtherCharges = 1                      
  GROUP BY IRNNo,TenantId) ii ON s.IRNNo = ii.IRNNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
  INNER JOIN IRNMaster m WITH (NOLOCK) ON s.IRNNo = m.IRNNo   AND ISNULL(m.tenantid,0)=ISNULL(@tenantid,0)     
  INNER JOIN SalesInvoiceParty b WITH (NOLOCK) ON s.IRNNo = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantid,0)                        
  AND b.Type = 'Buyer' AND ISNULL(b.Language,'EN')='EN'     
    INNER JOIN SalesInvoiceAddress sa WITH (NOLOCK) ON s.IRNNo = sa.IRNNo   AND ISNULL(sa.tenantid,0)=ISNULL(@tenantid,0)                        
  AND sa.Type = 'Buyer' AND ISNULL(sa.Language,'EN')='EN'    
  inner join SalesInvoiceContactPerson c with (nolock) on s.IRNNo = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantid,0)                        
  and c.Type = 'Buyer'  AND ISNULL(b.Language,'EN')='EN'    
where i.IRNNo=@irrno and i.TenantId=@tenantid    
    
end    
    
else if(@type='credit')    
 begin 
 
  update SalesInvoiceItem
 SET Description = dbo.udf_RemoveHTMLTagsFromString(Description) where IRNNo = @irrno and TenantId = @tenantid
    
select     
format(s.IssueDate,'dd-MM-yyyy') as IssueDate,    
b.VATID as VAT,    
b.CustomerId as CustomerId,    
c.ContactNumber as ContactNumber,    
c.Email as Email,    
concat(sa.BuildingNo,' ',sa.Street,' ',sa.AdditionalStreet,' ',sa.Neighbourhood,' ',sa.city,' ',sa.State) as CusAdd1,    
concat(sa.AdditionalStreet,',',sa.Neighbourhood) as CusAdd2,    
concat(sa.city,',',sa.State) as CusAdd3,    
concat(sa.CountryCode,',',sa.PostalCode) as CusAdd4,    
c.Name as BilltoAttn,    
isnull(b.OtherDocumentTypeId,b.OtherID) as BuyerType,    
s.AdditionalData2 as AdditionalData,    
s.AdditionalData1 as exchange,    
b.AdditionalData1 as shipment,    
'' as error,    
(select  yourvendor from openjson(s.AdditionalData2) with    
(  yourvendor nvarchar(200) '$."we_are_your_vendor#"'        
)) as youvendor    
,s.AccountNumber    
,s.BankName    
,s.SwiftCode,    
s.IBAN    
, *    
from CreditNote s  WITH (NOLOCK)    
  INNER JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,max(Vatrate) as VatRate    
  FROM CreditNoteItem   WITH (NOLOCK)    
  GROUP BY IRNNo,TenantId) i ON s.IRNNo = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
    
     
    
  left JOIN (SELECT SUM(UnitPrice) AS UnitPrice,IRNNo,TenantId    
  FROM CreditNoteItem   WITH (NOLOCK) where isOtherCharges = 1                      
  GROUP BY IRNNo,TenantId) ii ON s.IRNNo = ii.IRNNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
  INNER JOIN IRNMaster m WITH (NOLOCK) ON s.IRNNo = m.IRNNo   AND ISNULL(m.tenantid,0)=ISNULL(@tenantid,0)     
  INNER JOIN CreditNoteParty b WITH (NOLOCK) ON s.IRNNo = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantid,0)                        
  AND b.Type = 'Buyer' AND ISNULL(b.Language,'EN')='EN'     
    INNER JOIN CreditNoteAddress sa WITH (NOLOCK) ON s.IRNNo = sa.IRNNo   AND ISNULL(sa.tenantid,0)=ISNULL(@tenantid,0)                        
  AND sa.Type = 'Buyer' AND ISNULL(sa.Language,'EN')='EN'    
  inner join CreditNoteContactPerson c with (nolock) on s.IRNNo = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantid,0)                        
  and c.Type = 'Buyer'  AND ISNULL(b.Language,'EN')='EN'    
where i.IRNNo=@irrno and i.TenantId=@tenantid    
end    
else if(@type='debit')    
 begin 
 
   update CreditNoteItem
 SET Description = dbo.udf_RemoveHTMLTagsFromString(Description) where IRNNo = @irrno and TenantId = @tenantid
    
select     
format(s.IssueDate,'dd-MM-yyyy') as IssueDate,    
b.VATID as VAT,    
b.CustomerId as CustomerId,    
c.ContactNumber as ContactNumber,    
c.Email as Email,    
concat(sa.BuildingNo,' ',sa.Street,' ',sa.AdditionalStreet,' ',sa.Neighbourhood,' ',sa.city,' ',sa.State) as CusAdd1,    
concat(sa.AdditionalStreet,',',sa.Neighbourhood) as CusAdd2,    
concat(sa.city,',',sa.State) as CusAdd3,    
concat(sa.CountryCode,',',sa.PostalCode) as CusAdd4,    
c.Name as BilltoAttn,    
isnull(b.OtherDocumentTypeId,b.OtherID) as BuyerType,    
s.AdditionalData2 as AdditionalData,    
s.AdditionalData1 as exchange,    
b.AdditionalData1 as shipment,    
'' as error,    
(select  yourvendor from openjson(s.AdditionalData2) with    
(  yourvendor nvarchar(200) '$."we_are_your_vendor#"'        
)) as youvendor    
, *    
from DebitNote s  WITH (NOLOCK)    
  INNER JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,max(Vatrate) as VatRate    
  FROM DebitNoteItem   WITH (NOLOCK)    
  GROUP BY IRNNo,TenantId) i ON s.IRNNo = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
  left JOIN (SELECT SUM(UnitPrice) AS UnitPrice,IRNNo,TenantId    
  FROM DebitNoteItem   WITH (NOLOCK) where isOtherCharges = 1                      
  GROUP BY IRNNo,TenantId) ii ON s.IRNNo = ii.IRNNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
  INNER JOIN IRNMaster m WITH (NOLOCK) ON s.IRNNo = m.IRNNo   AND ISNULL(m.tenantid,0)=ISNULL(@tenantid,0)     
  INNER JOIN DebitNoteParty b WITH (NOLOCK) ON s.IRNNo = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantid,0)                        
  AND b.Type = 'Buyer' AND ISNULL(b.Language,'EN')='EN'     
    INNER JOIN DebitNoteAddress sa WITH (NOLOCK) ON s.IRNNo = sa.IRNNo   AND ISNULL(sa.tenantid,0)=ISNULL(@tenantid,0)                        
  AND sa.Type = 'Buyer' AND ISNULL(sa.Language,'EN')='EN'    
  inner join DebitNoteContactPerson c with (nolock) on s.IRNNo = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantid,0)                        
  and c.Type = 'Buyer'  AND ISNULL(b.Language,'EN')='EN'    
where i.IRNNo=@irrno and i.TenantId=@tenantid    
end    
     
 else    
 begin
   update DraftItem
 SET Description = dbo.udf_RemoveHTMLTagsFromString(Description) where IRNNo = @irrno and TenantId = @tenantid

select     
format(s.IssueDate,'dd-MM-yyyy') as IssueDate,    
b.VATID as VAT,    
b.CustomerId as CustomerId,    
c.ContactNumber as ContactNumber,    
c.Email as Email,    
concat(sa.BuildingNo,' ',sa.Street,' ',sa.AdditionalStreet,' ',sa.Neighbourhood,' ',sa.city,' ',sa.State) as CusAdd1,    
concat(sa.AdditionalStreet,',',sa.Neighbourhood) as CusAdd2,    
concat(sa.city,',',sa.State) as CusAdd3,    
concat(sa.CountryCode,',',sa.PostalCode) as CusAdd4,    
c.Name as BilltoAttn,    
isnull(b.OtherDocumentTypeId,b.OtherID) as BuyerType,    
s.AdditionalData2 as AdditionalData,    
s.AdditionalData1 as exchange,    
b.AdditionalData1 as shipment,    
s.Error as error,    
(select  yourvendor from openjson(s.AdditionalData2) with    
(  yourvendor nvarchar(200) '$."we_are_your_vendor#"'        
)) as youvendor    
,s.AccountNumber    
,s.BankName    
,s.SwiftCode,    
s.IBAN    
,s.id as IRNNo
,*    
from Draft s  WITH (NOLOCK)    
  INNER JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,max(Vatrate) as VatRate    
  FROM DraftItem   WITH (NOLOCK)    
  GROUP BY IRNNo,TenantId) i ON s.id = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
  left JOIN (SELECT SUM(UnitPrice) AS UnitPrice,IRNNo,TenantId    
  FROM DraftItem   WITH (NOLOCK) where isOtherCharges = 1                      
  GROUP BY IRNNo,TenantId) ii ON s.id = ii.IRNNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)    
  --INNER JOIN IRNMaster m WITH (NOLOCK) ON s.IRNNo = m.IRNNo   AND ISNULL(m.tenantid,0)=ISNULL(@tenantid,0)     
  INNER JOIN DraftParty b WITH (NOLOCK) ON s.id = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantid,0)                        
  AND b.Type = 'Buyer' AND ISNULL(b.Language,'EN')='EN'     
    INNER JOIN DraftAddress sa WITH (NOLOCK) ON s.id = sa.IRNNo   AND ISNULL(sa.tenantid,0)=ISNULL(@tenantid,0)                        
  AND sa.Type = 'Buyer' AND ISNULL(sa.Language,'EN')='EN'    
  inner join DraftContactPerson c with (nolock) on s.id = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantid,0)                        
  and c.Type = 'Buyer'  AND ISNULL(b.Language,'EN')='EN'    
where s.Id=@irrno and i.TenantId=@tenantid    
    
end    
    
end
GO
