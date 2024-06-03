SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[GetDebitNotePurchaseDetailedReporteffdateothers]  --exec   GetDebitDetailedReportEffdateothers '2022-01-01','2024-03-30',140,'any','25-10-2023'    
(                    
@fromDate DATE=NULL,             -- exec   [GetDebitNotePurchaseDetailedReporteffdateothers] '2022-01-01','2024-03-30',96,'taxableAmount','60000.00'       
@toDate DATE=NULL,    
@tenantId INT=NULL,          
@type NVARCHAR(MAX)=NULL,          
@text NVARCHAR(MAX)=NULL               
)     
as    
begin    
  
if (@type is null)  
begin  
set @type = 'any'  
end  
    
if(@type <> 'any')          
begin          
if @text is null        
begin        
set @text = case when @type ='zeroRated' then 'Z'        
     when @type = 'outofScope' then 'O'        
     when @type = 'exempt' then 'E'      
     when @type = 'exports' then 'Debit Note - Export'      
     else 'S' end        
end        
        
select * into #filterddebitdata from (          
select 
--(case when (VI.irnno is null or VI.irnno = '') then InvoiceNumber else VI.irnno end) as IRNNo,         
InvoiceNumber  as Invoicenumber,
 CASE
    WHEN b.Type = 'Supplier' THEN b.RegistrationName
    ELSE BuyerName
END as VendorName,
 format(effdate,'dd-MM-yyyy') as  InvoiceDate,
 billingreferenceid  as ReferenceNo,            
purchasecategory as Purchasecategory,            
isnull(sum(case when (trim(VatCategoryCode)='S'             
and trim(BuyerCountryCode) like 'SA%') Then isnull(LineNetAmount,0) else 0 end) ,0)          
 as TaxableAmount,  
 vatrate             
 as vatrate,        
sum(VATLineAmount)  as  VatAmount,            
sum(LineAmountInclusiveVAT) as  TotalAmount ,
         
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'            
and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,            
isnull(sum(case when (VatCategoryCode='Z'             
) Then isnull(LineNetAmount ,0) else 0 end ),0)            
    --and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)            
 as ZeroRated,          
isnull(sum(case when (VatCategoryCode='E'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exempt,            
isnull(sum(case when (VatCategoryCode='O'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,            
isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='0' and BuyerCountryCode not like 'SA%')         
Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportVATCustoms,        
isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='1' and BuyerCountryCode not like 'SA%')         
Then isnull(LineNetAmount ,0) else 0 end ),0) as VATDeffered,        
isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='1') Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportsatRCM,            
sum(isnull(customspaid,0))             
 as CustomsPaid,            
sum(isnull(excisetaxpaid,0))             
 as ExciseTaxPaid,            
sum(isnull(OtherChargespaid,0))            
 as OtherChargesPaid  ,
 sum((isnull(VATLineAmount ,0))+(isnull(CustomsPaid ,0))+(isnull(ExciseTaxPaid ,0))+(isnull(OtherChargesPaid ,0))) as ChargesIncludingVAT            
           
from VI_importstandardfiles_Processed VI
left join PurchaseDebitNoteParty b with (nolock) on vi.IRNNo = b.IRNNo    and Isnull(b.tenantid,0)=isnull(@tenantId,0)  
and b.Type = 'Supplier' where       
CAST(effdate AS DATE)>=@fromDate and CAST(effdate AS DATE)<=@toDate      
and invoicetype like 'DN Purchase%'  and VI.TenantId=@tenantId          
group by VI.IRNNo,effdate,BillingReferenceId,InvoiceNumber,VatRate ,PurchaseCategory,RCMApplicable,VATDeffered,BuyerName, RegistrationName ,Type ) debit WHERE        
 (          
        CASE          
           WHEN @type = 'invoicenumber' THEN CAST(Invoicenumber AS nvarchar(max))         
            WHEN @type = 'invoiceDate' THEN CAST(InvoiceDate AS nvarchar(max))          
            WHEN @type = 'taxableAmount' THEN CAST(TaxableAmount AS nvarchar(max))          
            WHEN @type = 'vatrate' THEN CAST(vatrate AS nvarchar(max))          
            WHEN @type = 'vatAmount' THEN CAST(vatAmount AS nvarchar(max))          
            WHEN @type = 'totalAmount' THEN CAST(totalAmount AS nvarchar(max))                
   WHEN @type = 'ReferenceNo' THEN CAST(ReferenceNo AS nvarchar(max))     
   --         ELSE NULL          
        END          
    ) LIKE @text+'%';          
        
 select 
 Invoicenumber as invoice_number,
 InvoiceDate as [Debit_Note_Date],
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,  
 Vatrate as vat_rate,  
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,
   format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,
 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,   
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope                
 from #filterddebitdata   
 GROUP BY 
    Invoicenumber, 
    InvoiceDate, 
    Vatrate  
ORDER BY 
    CASE 
        WHEN ISNUMERIC(Invoicenumber + '.0e0') = 1 THEN CAST(Invoicenumber AS NUMERIC(30, 2)) 
        ELSE NULL 
    END;
 
        
IF OBJECT_ID('tempdb..#filterddebitdata') IS NOT NULL DROP TABLE #filterddebitdata        
        
end          
        
else if(@type = 'any' and @text is not null)          
        
begin          
select * from (select 
--(case when (VI.irnno is null or VI.irnno = '') then InvoiceNumber else VI.irnno end) as IRNNo,         
InvoiceNumber  as Invoicenumber,
-- CASE
--    WHEN b.Type = 'Supplier' THEN b.RegistrationName
--    ELSE BuyerName
--END as VendorName,
 format(effdate,'dd-MM-yyyy') as  InvoiceDate,
-- billingreferenceid  as ReferenceNo,            
--purchasecategory as Purchasecategory,            
isnull(sum(case when (trim(VatCategoryCode)='S'             
and trim(BuyerCountryCode) like 'SA%') Then isnull(LineNetAmount,0) else 0 end) ,0)          
 as TaxableAmount,  
 vatrate             
 as vatrate,        
sum(VATLineAmount)  as  VatAmount,            
sum(LineAmountInclusiveVAT) as  TotalAmount ,
         
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'            
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,            
isnull(sum(case when (VatCategoryCode='Z'             
) Then isnull(LineNetAmount ,0) else 0 end ),0)            
    --and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)            
 as ZeroRated,          
isnull(sum(case when (VatCategoryCode='E'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exempt,            
isnull(sum(case when (VatCategoryCode='O'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope            
--isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='0' and BuyerCountryCode not like 'SA%')         
--Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportVATCustoms,        
--isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='1' and BuyerCountryCode not like 'SA%')         
--Then isnull(LineNetAmount ,0) else 0 end ),0) as VATDeffered,        
--isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='1') Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportsatRCM,            
--sum(isnull(customspaid,0))             
-- as CustomsPaid,            
--sum(isnull(excisetaxpaid,0))             
-- as ExciseTaxPaid,            
--sum(isnull(OtherChargespaid,0))            
-- as OtherChargesPaid  ,
-- sum((isnull(VATLineAmount ,0))+(isnull(CustomsPaid ,0))+(isnull(ExciseTaxPaid ,0))+(isnull(OtherChargesPaid ,0))) as ChargesIncludingVAT            
           
from VI_importstandardfiles_Processed VI
left join PurchaseDebitNoteParty b with (nolock) on vi.IRNNo = b.IRNNo    and Isnull(b.tenantid,0)=isnull(@tenantId,0)  
and b.Type = 'Supplier' where       
CAST(effdate AS DATE)>=@fromDate and CAST(effdate AS DATE)<=@toDate      
and invoicetype like 'DN Purchase%'  and VI.TenantId=@tenantId          
group by VI.IRNNo,effdate,BillingReferenceId,InvoiceNumber,VatRate ,PurchaseCategory,RCMApplicable,VATDeffered,BuyerName, RegistrationName ,Type ) debit WHERE         
  CAST(invoicenumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
        OR CONVERT(NVARCHAR(MAX), InvoiceDate, 121) LIKE '%' + @text + '%'          
        OR CAST(TaxableAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(vatrate AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(vatAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(totalAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(zeroRated AS NVARCHAR(MAX)) LIKE '%' + @text + '%'                    
        OR CAST(exempt AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(outofScope AS NVARCHAR(MAX)) LIKE '%' + @text + '%'    ;           

      
                 
end    
  
else if(@type='any' and @text is null )          
begin          
select * into #filterddebitdataany from (select 
--(case when (VI.irnno is null or VI.irnno = '') then InvoiceNumber else VI.irnno end) as IRNNo,         
InvoiceNumber  as Invoicenumber,
 CASE
    WHEN b.Type = 'Supplier' THEN b.RegistrationName
    ELSE BuyerName
END as VendorName,
 format(effdate,'dd-MM-yyyy') as  InvoiceDate,
 billingreferenceid  as ReferenceNo,            
purchasecategory as Purchasecategory,            
isnull(sum(case when (trim(VatCategoryCode)='S'             
and trim(BuyerCountryCode) like 'SA%') Then isnull(LineNetAmount,0) else 0 end) ,0)          
 as TaxableAmount,  
 vatrate             
 as vatrate,        
sum(VATLineAmount)  as  VatAmount,            
sum(LineAmountInclusiveVAT) as  TotalAmount ,
         
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'            
and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,            
isnull(sum(case when (VatCategoryCode='Z'             
) Then isnull(LineNetAmount ,0) else 0 end ),0)            
    --and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)            
 as ZeroRated,          
isnull(sum(case when (VatCategoryCode='E'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exempt,            
isnull(sum(case when (VatCategoryCode='O'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,            
isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='0' and BuyerCountryCode not like 'SA%')         
Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportVATCustoms,        
isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='1' and BuyerCountryCode not like 'SA%')         
Then isnull(LineNetAmount ,0) else 0 end ),0) as VATDeffered,        
isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='1') Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportsatRCM,            
sum(isnull(customspaid,0))             
 as CustomsPaid,            
sum(isnull(excisetaxpaid,0))             
 as ExciseTaxPaid,            
sum(isnull(OtherChargespaid,0))            
 as OtherChargesPaid  ,
 sum((isnull(VATLineAmount ,0))+(isnull(CustomsPaid ,0))+(isnull(ExciseTaxPaid ,0))+(isnull(OtherChargesPaid ,0))) as ChargesIncludingVAT            
           
from VI_importstandardfiles_Processed VI
left join PurchaseDebitNoteParty b with (nolock) on vi.IRNNo = b.IRNNo    and Isnull(b.tenantid,0)=isnull(@tenantId,0)  
and b.Type = 'Supplier' where       
CAST(effdate AS DATE)>=@fromDate and CAST(effdate AS DATE)<=@toDate      
and invoicetype like 'DN Purchase%'  and VI.TenantId=@tenantId          
group by VI.IRNNo,effdate,BillingReferenceId,InvoiceNumber,VatRate ,PurchaseCategory,RCMApplicable,VATDeffered,BuyerName, RegistrationName ,Type ) debit 
  select 
 Invoicenumber as invoice_number,
 InvoiceDate as [Debit_Note_Date],
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,  
 Vatrate as vat_rate,  
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,
   format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,
 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,   
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope 
 --format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as Govt_Taxable_Amt
 from #filterddebitdataany  
 group by Invoicenumber,InvoiceDate,Vatrate
 order by Invoicenumber
        
IF OBJECT_ID('tempdb..#filterddebitdataany') IS NOT NULL DROP TABLE #filterddebitdataany   
end       
    
end
GO
