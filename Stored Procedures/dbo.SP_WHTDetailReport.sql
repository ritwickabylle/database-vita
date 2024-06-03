SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE         PROCEDURE [dbo].[SP_WHTDetailReport](     -- exec SP_WHTDetailReport '2023-01-01','2023-12-31',171      
@FromDate datetime,        
@ToDate datetime,      
@tenantId int=null,    
@code nvarchar(3)='0')        
as        
begin        
declare @WhtDetailReport as table        
(SLNO int identity(1,1),        
Typeofpayments nvarchar(100),        
NameofPayee nvarchar(100),        
country nvarchar(150),        
paymentdate datetime,        
totalamountPaid decimal(18,2),        
taxrate decimal(18,2),        
withholdingtaxamount decimal(18,2)  ,      
StandardRate decimal(18,2),      
DTTrate nvarchar(6),      
AffiliationStatus nvarchar(30) ,      
Obtainedrequireddocuments nvarchar(30)  ,    
PaymentDescription nvarchar(150),    
PlaceofService nvarchar(25) , 
CountryName nvarchar(max),
BatchId int,  
UniqueIdentifier uniqueIdentifier,  
Comments  nvarchar(150)  
    
)        
    
     
    
--select * from VI_ImportMasterFiles_Processed       
--insert into @WhtDetailReport (TypeofPayments,NameofPayee,country,paymentdate,totalamountPaid,taxrate,withholdingtaxamount)         
--values ('TypeofPayment','NameofthePayee','SA',GETDATE(),1000,15,100);        
    
--select * from VI_importstandardfiles_Processed where  tenantid=33 order by batchid desc    
     
 if @code = '0'    
  begin    
   insert into @WhtDetailReport (TypeofPayments,NameofPayee,country,paymentdate,totalamountPaid, taxrate,withholdingtaxamount,StandardRate,DTTrate,AffiliationStatus,Obtainedrequireddocuments,PaymentDescription ,PlaceofService,CountryName,BatchId,UniqueIdentifier,Comments)           
   select v.Natureofservices,v.BuyerName,v.BuyerCountryCode,v.issuedate,round(v.LineAmountInclusiveVAT,2),p.effrate,        
   round(v.LineAmountInclusiveVAT*p.effrate/100,2),p.lawrate,case when p.RateSlno not in (12,13) then 'N/A' else cast(p.StandardRate as nvarchar(5)) end,AffiliationStatus ,VATDeffered,v.ItemName,v.PlaceofSupply,v.VatExemptionReasonCode,v.BatchId,v.UniqueIdentifier,v.ReasonForCN  
        
   from VI_importstandardfiles_Processed v         
   inner join vi_paymentWHTrate p on v.UniqueIdentifier = p.uniqueidentifier       
   where v.TenantId=@tenantId and v.IssueDate >= @fromdate and v.IssueDate<= @todate and v.InvoiceType like 'WHT%'  order by natureofservices,v.ItemName ,buyername,issuedate        
   end    
else    
   begin    
      insert into @WhtDetailReport (TypeofPayments,NameofPayee,country,paymentdate,totalamountPaid,taxrate,withholdingtaxamount,StandardRate,DTTrate,AffiliationStatus,Obtainedrequireddocuments,PaymentDescription ,PlaceofService,CountryName ,BatchId,UniqueIdentifier,Comments)           
   select v.Natureofservices,v.BuyerName,v.BuyerCountryCode,v.issuedate,round(v.LineAmountInclusiveVAT,2),p.effrate,        
   round(v.LineAmountInclusiveVAT*p.effrate/100,2),p.lawrate,case when p.RateSlno not in (12,13) then 'N/A' else cast(p.StandardRate as nvarchar(5)) end,AffiliationStatus ,VATDeffered,v.ItemName,v.PlaceofSupply,v.VatExemptionReasonCode, v.BatchId,v.UniqueIdentifier,v.ReasonForCN 
          
   from VI_importstandardfiles_Processed v         
   inner join vi_paymentWHTrate p on v.UniqueIdentifier = p.uniqueidentifier       
   inner join NatureofServices n on v.NatureofServices = n.name    
   where v.TenantId=@tenantId and v.IssueDate >= @fromdate and v.IssueDate<= @todate and v.InvoiceType like 'WHT%'  and n.code = @code order by natureofservices,v.itemname,buyername,issuedate        
    end    

--  select SLNO,Typeofpayments,PaymentDescription,NameofPayee,country,FORMAT(paymentdate,'dd-MM-yyyy') as paymentdate,totalamountPaid,      
--  taxrate,withholdingtaxamount,StandardRate,DTTrate,AffiliationStatus,case when (Obtainedrequireddocuments =1) then 'Yes' else 'No' end as Obtainedrequireddocuments,    
-- PlaceofService,BatchId,UniqueIdentifier,Comments   from @WhtDetailReport        
    
 select SLNO,Typeofpayments as'Type of Payment',isnull(PaymentDescription,'') as 'Payment Description',NameofPayee as 'Name of Payee',country as 'Country',
-- case when dttrate = 'N/A' then countryname else '* '+ countryname + ' *' end as 'Country Name',FORMAT(paymentdate,'dd-MM-yyyy') as 'Payment Date',  format(cast(totalamountPaid as decimal(20,2)),'#,0.00') AS 'Total Amount Paid',      
 case when Country in (select distinct alphacode from WHTDTTRates) then  '* '+ countryname + ' *' else countryname end as 'Country Name',FORMAT(paymentdate,'dd-MM-yyyy') as 'Payment Date',  format(cast(totalamountPaid as decimal(20,2)),'#,0.00') AS 'Total Amount Paid',        
  format(cast(taxrate as decimal(20,2)),'#,0.00') as 'Tax Rate', format(cast(withholdingtaxamount as decimal(20,2)),'#,0.00') AS 'WithHolding Taxamount',AffiliationStatus as 'Affiliation Status',case when (Obtainedrequireddocuments =1) then 'Yes' else 'No' end as 'Obtained Required Documents',    
  PlaceofService 'Place of Service', isnull(Comments,'') from @WhtDetailReport        

--select * from WHTDTTRates     
--  select * from VI_PaymentWHTRate       
end
GO
