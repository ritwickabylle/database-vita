SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================        
-- Author:      <Author, , Name>        
-- Create Date: <Create Date, , >        
-- Description: <Description, , >        
-- =============================================        
CREATE      PROCEDURE [dbo].[InsertBatchUploadDefaultValues]      --            EXEC [InsertBatchUploadDefaultValues] 42,141       
(        
    -- Add the parameters for the stored procedure here        
@BatchId int ,  
@Tenant int=148  
)        
AS        
BEGIN        
    -- SET NOCOUNT ON added to prevent extra result sets from        
    -- interfering with SELECT statements.        
Declare @Desc nvarchar(20) = ''        
declare @type as nvarchar(25)=''        
declare @catg as nvarchar(25)=''        
declare @tenantid as int        
declare @tenentVatId nvarchar(20) = null;          
  
   Insert into Logs( [json],[date],[batchid])        
   Values('Default SP started', GetDate(),@batchId)  
        
 set @type = (select top 1 type from BatchData where BatchId = @BatchId)         
 set @tenantid = (select top 1 tenantId from BatchData where BatchId = @BatchId)    
 set @tenantid = @Tenant  
 print(@tenantid);  
    set @tenentVatId = (select top 1  t.VATID from TenantBasicDetails t  where tenantid = @tenantid) -- on i.TenantId=t.tenantid where i.BatchId=@BatchNo)            
        
 -- below 4 queries are temporary till the country alias derived defaults logic is written by dev team        
        
  update importbatchdata set PaymentTerms  = (select top 1 AlphaCode from countryalias where         
  aliasname = importbatchdata.buyercountrycode) where batchid = @batchid    -- 16-dec-2023        
  update importbatchdata set paymentterms = BuyerCountryCode where paymentterms is null and batchid= @batchid -- 16-dec-2023        
  update importbatchdata set BuyerCountryCode = PaymentTerms where batchid= @batchid    -- 16-dec-2023        
  update importbatchdata set PaymentTerms = null where batchid = @batchid       -- 16-dec-2023        
        
  ------------------        
        
 if exists (select top 1 id from ImportBatchData where BatchId = @batchid and TenantId=@tenantid and upper(trim(TransType)) = 'SALES')      
 begin        
 SET @Desc = 'Sales';     
    update ImportBatchData set VatCategoryCode =' ' where batchid = @batchid 
   and vatrate in (0) 
   and ( VatCategoryCode='' OR VatCategoryCode is null )              --04-03-24 
   and upper(trim(TransType)) ='SALES'  -- this has to be done dynamically 

 

  update importbatchdata set InvoiceCurrencyCode = 'SAR' where batchid = @batchid and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='') and upper(trim(TransType)) ='SALES'       
  update importbatchdata set InvoiceCurrencyCode = 'SAR' where batchid = @batchid and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='') and upper(trim(TransType)) ='SALES'         
  update ImportBatchData set InvoiceLineIdentifier = 1 where batchid = @batchid and (InvoiceLineIdentifier is null or InvoiceLineIdentifier =0 ) and upper(trim(TransType)) ='SALES'         
  --update ImportBatchData set TransType  = 'Sales' where batchid = @batchid and (TransType  is null or transtype = '')        
  update ImportBatchData set Quantity =1 where batchid = @batchid and (Quantity =0 or Quantity is null)  and upper(trim(TransType)) ='SALES'      
  update ImportBatchData set GrossPrice = LineNetAmount where batchid = @batchid and (GrossPrice =0 or GrossPrice is null)  and upper(trim(TransType)) ='SALES'      
     update ImportBatchData set NetPrice  = LineNetAmount where  batchid = @batchid and (NetPrice  =0 or netprice is null)  and upper(trim(TransType)) ='SALES'      
  update ImportBatchData set Discount = 0 where batchid = @batchid and (Discount =0 or Discount  is null)  and upper(trim(TransType)) ='SALES'      
     update ImportBatchData set LineAmountInclusiveVAT = LineNetAmount + VATLineAmount where batchid = @batchid and TenantId=@tenantid and ISNULL(LineAmountInclusiveVAT,0)=0 and upper(trim(TransType)) ='SALES'       
  update ImportBatchData set OrgType = 'PRIVATE' where batchid = @batchid and (orgtype is null or orgtype = '')  and upper(trim(TransType)) ='SALES'      
  update ImportBatchData set VatRate = 15 where vatrate = 0.15 and batchid = @batchid and upper(trim(TransType)) ='SALES'   -- this has to be done dynamically        
  update ImportBatchData set VatRate = 5 where vatrate = 0.05 and batchid = @batchid and upper(trim(TransType)) ='SALES'   -- this has to be done dynamically        
  update ImportBatchData set VatCategoryCode ='S' where batchid = @batchid and vatrate in (15,5)     
  and BuyerCountryCode like 'SA%' and upper(trim(TransType)) ='SALES' and (VatCategoryCode = '' or VatCategoryCode is null)  -- this has to be done dynamically        
         
  -- update query for out of scope        
  -- update query for exempt        
  update ImportBatchData set invoicetype='Sales Invoice - Out of Scope' where  VatCategoryCode = 'O'    and     
  (@tenantid is not null and BuyerVatCode = @tenentVatId ) and batchid = @batchid  and upper(trim(TransType)) ='SALES'    -- 16-dec-2023        
    
    update ImportBatchData set invoicetype='Sales Invoice - Export', VatCategoryCode ='Z' where batchid = @batchid and vatrate in (0) and (VatCategoryCode ='' or VatCategoryCode is null or VatCategoryCode = 'Z') and BuyerCountryCode not like 'SA%' and upper(trim(TransType)) ='SALES'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Sales Invoice - Simplified' where BuyerCountryCode like 'SA%' and (InvoiceType not like '%Nom%' or InvoiceType not like '%NOM%') and LineAmountInclusiveVAT <= 1000 and batchid = @batchid  and upper(trim(TransType)
  
    
) ='SALES'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Sales Invoice - Nominal' where BuyerCountryCode like 'SA%' and vatrate = 0 and (InvoiceType is null or invoicetype ='') and batchid = @batchid and upper(trim(TransType)) ='SALES'  -- this has to be done dynamically        
        
--  update ImportBatchData set invoicetype='Sales Invoice - Simplified' where BuyerCountryCode like 'SA%'         
--  and (BuyerVatCode is null or BuyerVatCode = '')  and batchid = @batchid   -- -15-dec-2023  (Disabled as per JN feedback)        
        
  update ImportBatchData set invoicetype='Sales Invoice - Standard' where (invoicetype like '%Standard%' or         
         (invoicetype ='Sales Invoice -' and BuyerCountryCode like 'SA%')) and batchid = @batchid and upper(trim(TransType)) ='SALES'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Sales Invoice - Nominal' where invoicetype like '%Nominal%' and batchid = @batchid  and upper(trim(TransType)) ='SALES'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Sales Invoice - Simplified' where invoicetype like '%Simplified%' and batchid = @batchid  and upper(trim(TransType)) ='SALES'   -- this has to be done dynamically        
--  update ImportBatchData set invoicetype='Sales Invoice - Export' where BuyerCountryCode not like 'SA%' and batchid = @batchid     -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Sales Invoice - Export' where (invoicetype like '%Export%'         
  or (invoicetype ='Sales Invoice -' and BuyerCountryCode not like 'SA%')) and batchid = @batchid  and upper(trim(TransType)) ='SALES'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Sales Invoice - Third Party' where invoicetype like '%Third Party%' and batchid = @batchid  and upper(trim(TransType)) ='SALES'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Sales Invoice - Self Billed' where invoicetype like '%Self Billed%' and batchid = @batchid and upper(trim(TransType)) ='SALES'    -- this has to be done dynamically        
        
  update ImportBatchData set invoicetype='Sales Invoice - Out of Scope' , VatCategoryCode = 'O' where         
  (@tenantid is not null and BuyerVatCode = @tenentVatId ) and batchid = @batchid  and upper(trim(TransType)) ='SALES'    -- 16-dec-2023        
        
 end        
 if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'CREDIT')       
 begin        
 SET @Desc = 'CREDIT';        

   update ImportBatchData set VatCategoryCode =' ' where batchid = @batchid 
   and vatrate in (0) 
   and ( VatCategoryCode='' OR VatCategoryCode is null )              --04-03-24 
   and upper(trim(TransType)) ='CREDIT'  -- this has to be done dynamically 

 update importbatchdata set TotalTaxableAmount = abs(TotalTaxableAmount), GrossPrice = abs(GrossPrice),         
    netprice = abs(netprice), vatlineamount = abs(vatlineamount), lineamountinclusivevat = abs(lineamountinclusivevat), linenetamount = abs(linenetamount) where batchid = @batchid and upper(trim(TransType)) ='CREDIT'       
  update importbatchdata set InvoiceCurrencyCode = 'SAR' where batchid = @batchid and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='')  and upper(trim(TransType)) ='CREDIT'         
  --update ImportBatchData set TransType  = 'Sales' where batchid = @batchid and (TransType  is null or transtype = '')        
  update importbatchdata set orignalsupplydate = supplydate where orignalsupplydate is null and BillingReferenceId is not null and  batchid = @batchid  and upper(trim(TransType)) ='CREDIT'       
  update ImportBatchData set InvoiceLineIdentifier = 1 where batchid = @batchid and (InvoiceLineIdentifier is null or InvoiceLineIdentifier =0 )  and upper(trim(TransType)) ='CREDIT'         
  update ImportBatchData set Quantity =1 where batchid = @batchid and (Quantity =0 or Quantity is null)  and upper(trim(TransType)) ='CREDIT'       
  update ImportBatchData set GrossPrice = LineNetAmount where batchid = @batchid and (GrossPrice =0 or GrossPrice is null)  and upper(trim(TransType)) ='CREDIT'       
     update ImportBatchData set NetPrice  = LineNetAmount where  batchid = @batchid and (NetPrice  =0 or netprice is null)  and upper(trim(TransType)) ='CREDIT'       
  update ImportBatchData set Discount = 0 where batchid = @batchid and (Discount =0 or Discount  is null)  and upper(trim(TransType)) ='CREDIT'       
     update ImportBatchData set LineAmountInclusiveVAT = LineNetAmount + VATLineAmount where batchid = @batchid and ISNULL(LineAmountInclusiveVAT,0)=0 and upper(trim(TransType)) ='CREDIT'        
  update ImportBatchData set OrgType = 'PRIVATE' where batchid = @batchid and (orgtype is null or orgtype = '')  and upper(trim(TransType)) ='CREDIT'       
  update ImportBatchData set VatRate = 15 where vatrate = 0.15 and batchid = @batchid and upper(trim(TransType)) ='CREDIT'    -- this has to be done dynamically        
  update ImportBatchData set VatRate = 5 where vatrate = 0.05 and batchid = @batchid and upper(trim(TransType)) ='CREDIT'    -- this has to be done dynamically        
  update ImportBatchData set VatCategoryCode ='S' where batchid = @batchid and vatrate in (15,5) and BuyerCountryCode like 'SA%' and upper(trim(TransType)) ='CREDIT'  
  -- 16-dec-2023 this has to be done dynamically        
  update ImportBatchData set VatCategoryCode ='Z',invoicetype='Credit Note - Export' 
  where batchid = @batchid and vatrate in (0) and BuyerCountryCode not like 'SA%' and upper(trim(TransType)) ='CREDIT'  -- this has to be donedynamically  
  

  update ImportBatchData set invoicetype='Credit Note - Simplified' where BuyerCountryCode like 'SA%' and LineAmountInclusiveVAT <= 1000 and batchid = @batchid and upper(trim(TransType)) ='CREDIT'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Standard' where invoicetype = 'Credit Note - ' and BuyerCountryCode like 'SA%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Standard' where invoicetype like '%Standard%' and BuyerCountryCode like 'SA%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Nominal' where invoicetype like '%Nominal%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT'     -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Simplified' where invoicetype like '%Simplified%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT'     -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Export' where (invoicetype like '%Export%'         
  or (invoicetype ='Credit Note -' and BuyerCountryCode not like 'SA%')) and batchid = @batchid and upper(trim(TransType)) ='CREDIT'     -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Third Party' where invoicetype like '%Third Party%' and batchid = @batchid  and upper(trim(TransType)) ='CREDIT'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Self Billed' where invoicetype like '%Self Billed%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT'     -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Credit Note - Standard' , VatCategoryCode = 'O' where         
  (@tenentVatId  is not null and BuyerVatCode = @tenentVatId ) and batchid = @batchid  and upper(trim(TransType)) ='CREDIT'    -- 16-dec-2023        
        
 end        
 if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'DEBIT')        
 Begin        
 SET @Desc = 'DEBIT';        
 
     update ImportBatchData set VatCategoryCode =' ' where batchid = @batchid 
   and vatrate in (0) 
   and ( VatCategoryCode='' OR VatCategoryCode is null )              --04-03-24 
   and upper(trim(TransType)) ='DEBIT'  -- this has to be done dynamically 
  update importbatchdata set InvoiceCurrencyCode = 'SAR' where batchid = @batchid and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='')  and upper(trim(TransType)) ='DEBIT'         
  --update ImportBatchData set TransType  = 'Sales' where batchid = @batchid and (TransType  is null or transtype = '')        
  update ImportBatchData set InvoiceLineIdentifier = 1 where batchid = @batchid and (InvoiceLineIdentifier is null or InvoiceLineIdentifier =0 ) and upper(trim(TransType)) ='DEBIT'         
  update ImportBatchData set Quantity =1 where batchid = @batchid and (Quantity =0 or Quantity is null)  and upper(trim(TransType)) ='DEBIT'      
  update ImportBatchData set GrossPrice = LineNetAmount where batchid = @batchid and (GrossPrice =0 or GrossPrice is null)  and upper(trim(TransType)) ='DEBIT'      
     update ImportBatchData set NetPrice  = LineNetAmount where  batchid = @batchid and (NetPrice  =0 or netprice is null)  and upper(trim(TransType)) ='DEBIT'      
  update ImportBatchData set Discount = 0 where batchid = @batchid and (Discount =0 or Discount  is null)  and upper(trim(TransType)) ='DEBIT'      
     update ImportBatchData set LineAmountInclusiveVAT = LineNetAmount + VATLineAmount where batchid = @batchid and ISNULL(LineAmountInclusiveVAT,0)=0  and upper(trim(TransType)) ='DEBIT'      
  update ImportBatchData set OrgType = 'PRIVATE' where batchid = @batchid and (orgtype is null or orgtype = '')  and upper(trim(TransType)) ='DEBIT'      
  update ImportBatchData set VatRate = 15 where vatrate = 0.15 and batchid = @batchid  and upper(trim(TransType)) ='DEBIT'  -- this has to be done dynamically        
  update ImportBatchData set VatRate = 5 where vatrate = 0.05 and batchid = @batchid and upper(trim(TransType)) ='DEBIT'   -- this has to be done dynamically        
  update ImportBatchData set VatCategoryCode ='S' where batchid = @batchid and vatrate in (15,5) and BuyerCountryCode like 'SA%' and upper(trim(TransType)) ='DEBIT'  -- this has to be done dynamically        
  -- update query for out of scope        
  -- update query for exempt        
    update ImportBatchData set VatCategoryCode ='Z',invoicetype='Debit Note - Export' where batchid = @batchid and vatrate in (0) and VatCategoryCode is null  and BuyerCountryCode not like 'SA%' and upper(trim(TransType)) ='DEBIT' -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Simplified' where BuyerCountryCode like 'SA%' and LineAmountInclusiveVAT <= 1000 and batchid = @batchid and upper(trim(TransType)) ='DEBIT'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Standard' where invoicetype = 'Debit Note - ' and BuyerCountryCode like 'SA%' and batchid = @batchid  and upper(trim(TransType)) ='DEBIT'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Standard' where invoicetype like '%Standard%' and BuyerCountryCode like 'SA%' and batchid = @batchid and upper(trim(TransType)) ='DEBIT'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Nominal' where invoicetype like '%Nominal%' and batchid = @batchid  and upper(trim(TransType)) ='DEBIT'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Simplified' where invoicetype like '%Simplified%' and batchid = @batchid  and upper(trim(TransType)) ='DEBIT'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Export' where (invoicetype like '%Export%'         
  or (invoicetype ='Debit Note -' and BuyerCountryCode not like 'SA%')) and batchid = @batchid and upper(trim(TransType)) ='DEBIT'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Third Party' where invoicetype like '%Third Party%' and batchid = @batchid and upper(trim(TransType)) ='DEBIT'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Debit Note - Self Billed' where invoicetype like '%Self Billed%' and batchid = @batchid and upper(trim(TransType)) ='DEBIT'    -- this has to be done dynamically        
  update importbatchdata set OrignalSupplyDate = supplydate where OrignalSupplyDate is null and BillingReferenceId is not null and  batchid = @batchid  and upper(trim(TransType)) ='DEBIT'      
  update importbatchdata set SupplyDate  = IssueDate where SupplyDate is null and batchid = @batchid  and upper(trim(TransType)) ='DEBIT'      
  update ImportBatchData set invoicetype='Debit Note - Standard' , VatCategoryCode = 'O' where         
  (@tenentVatId  is not null and BuyerVatCode = @tenentVatId ) and batchid = @batchid and upper(trim(TransType)) ='DEBIT'    -- 16-dec-2023        
        
        
 end        
 if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'PURCHASE')        
 Begin        
        
   set @catg = (select isnull(businesscategory,'') from TenantBasicDetails where tenantid = @tenantid)        
        
 SET @Desc = 'PURCHASE';  
 
	update importbatchdata set orignalsupplydate = issuedate where orignalsupplydate is null and batchid = @batchid and upper(trim(TransType)) ='UNCLASSIFIED' 
 
   update ImportBatchData set VatCategoryCode =' ' where batchid = @batchid 
   and vatrate in (0) 
   and ( VatCategoryCode='' OR VatCategoryCode is null )              --04-03-24 
   and upper(trim(TransType)) ='PURCHASE'  -- this has to be done dynamically 

 update importbatchdata set buyercountrycode = 'SA' where (buyercountrycode is null or buyercountrycode = '') and batchid = @batchid  and upper(trim(TransType)) ='PURCHASE'        
 update importbatchdata set TotalTaxableAmount = abs(TotalTaxableAmount), GrossPrice = abs(GrossPrice),         
    netprice = abs(netprice), vatlineamount = abs(vatlineamount), lineamountinclusivevat = abs(lineamountinclusivevat), linenetamount = abs(linenetamount) where batchid = @batchid  and upper(trim(TransType)) ='PURCHASE'      
  update ImportBatchData set invoicetype='Purchase Entry-STANDARD' where invoicetype = 'Purchase Entry- ' and BuyerCountryCode like 'SA%' and batchid = @batchid and upper(trim(TransType)) ='PURCHASE'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Purchase Entry-STANDARD' where invoicetype like '%STANDARD%' and BuyerCountryCode like 'SA%' and batchid = @batchid  and upper(trim(TransType)) ='PURCHASE' -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Purchase Entry-IMPORTS' where (invoicetype like '%IMPORT%'         
  or (invoicetype ='Purchase Entry-' and BuyerCountryCode not like 'SA%') OR BuyerCountryCode NOT LIKE 'SA%') and batchid = @batchid and upper(trim(TransType)) ='PURCHASE'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Purchase Entry-Third Party' where invoicetype like '%Third Party%' and batchid = @batchid and upper(trim(TransType)) ='PURCHASE'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='Purchase Entry-Self Billed' where invoicetype like '%Self Billed%' and batchid = @batchid and upper(trim(TransType)) ='PURCHASE'    -- this has to be done dynamically        
   --update ImportBatchData set VatCategoryCode ='Z' where batchid = @batchid and vatrate in (0) and (VatCategoryCode ='' or VatCategoryCode is null) and upper(trim(TransType)) ='PURCHASE'  -- this has to be done dynamically        
  update importbatchdata set Isapportionment = 0 where batchid = @batchid and (Isapportionment is null or Isapportionment = 'FALSE')  and upper(trim(TransType)) ='PURCHASE'        
  --update ImportBatchData set TransType  = 'Purchases' where batchid = @batchid and (TransType  is null or transtype = '')        
  update importbatchdata set VATDeffered = 0 where batchid = @batchid and (VATDeffered is null or VATDeffered = 'False')  and upper(trim(TransType)) ='PURCHASE'       
  update importbatchdata set AffiliationStatus  = 'Y' where batchid = @batchid and (AffiliationStatus  is null)   and upper(trim(TransType)) ='PURCHASE'      
  update importbatchdata set InvoiceCurrencyCode = 'SAR' where batchid = @batchid and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='')  and upper(trim(TransType)) ='PURCHASE'        
    update importbatchdata set orignalsupplydate = issuedate where orignalsupplydate is null and batchid = @batchid and upper(trim(TransType)) ='PURCHASE'        
  update ImportBatchData set InvoiceLineIdentifier = 1 where batchid = @batchid and (InvoiceLineIdentifier is null or InvoiceLineIdentifier =0 )  and upper(trim(TransType)) ='PURCHASE'        
  update ImportBatchData set Quantity =1 where batchid = @batchid and (Quantity =0 or Quantity is null)  and upper(trim(TransType)) ='PURCHASE'      
  update ImportBatchData set GrossPrice = LineNetAmount where batchid = @batchid and (GrossPrice =0 or GrossPrice is null)  and upper(trim(TransType)) ='PURCHASE'      
     update ImportBatchData set NetPrice  = LineNetAmount where  batchid = @batchid and (NetPrice  =0 or netprice is null)  and upper(trim(TransType)) ='PURCHASE'      
  update ImportBatchData set Discount = 0 where batchid = @batchid and (Discount =0 or Discount  is null)  and upper(trim(TransType)) ='PURCHASE'      
     update ImportBatchData set LineAmountInclusiveVAT = LineNetAmount + VATLineAmount where batchid = @batchid and ISNULL(LineAmountInclusiveVAT,0)=0  and upper(trim(TransType)) ='PURCHASE'      
  update ImportBatchData set TotalTaxableAmount  = Linenetamount + isnull(CustomsPaid,0) + isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0)  where batchid = @batchid  and upper(trim(TransType)) ='PURCHASE'      
  update ImportBatchData set OrgType = 'PRIVATE' where batchid = @batchid and (orgtype is null or orgtype = '') and upper(trim(TransType)) ='PURCHASE'       
  update ImportBatchData set VatRate = 15 where vatrate = 0.15 and batchid = @batchid  and upper(trim(TransType)) ='PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set VatRate = 5 where vatrate = 0.05 and batchid = @batchid  and upper(trim(TransType)) ='PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set VatCategoryCode ='S' where batchid = @batchid and vatrate in (15,5) and BuyerCountryCode like 'SA%'  and upper(trim(TransType)) ='PURCHASE' -- this has to be done dynamically        
        
  update ImportBatchData set invoicetype='Purchase Entry - Out of Scope' , VatCategoryCode = 'O' where         
  (@tenentVatId  is not null and BuyerVatCode = @tenentVatId ) and batchid = @batchid and upper(trim(TransType)) ='PURCHASE'    -- 16-dec-2023        
        
--   update ImportBatchData set VatCategoryCode ='Z' where batchid = @batchid 
--   and vatrate in (0) 
  -- and ( VatCategoryCode='' OR VatCategoryCode is null )              --04-03-24 
--  and upper(trim(TransType)) ='PURCHASE'  -- this has to be done dynamically        
        
  if upper(@catg) in ('GOODS','Services','Overhead')         
  begin          
 print(@tenantid);  
   update ImportBatchData set PurchaseCategory =( select isnull(businesscategory,'') from TenantBasicDetails where tenantid = @tenantid     )    
  where (PurchaseCategory is null or PurchaseCategory='')         
  and TenantId = @tenantid   
  
  end        
 end        
        
        
 if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'CREDIT-PURCHASE')            
 Begin        
        
   set @catg = (select isnull(businesscategory,'') from TenantBasicDetails where tenantid = @tenantid);        
        
 SET @Desc = 'CREDIT-PURCHASE';   
  
   update ImportBatchData set VatCategoryCode =' ' where batchid = @batchid 
   and vatrate in (0) 
   and ( VatCategoryCode='' OR VatCategoryCode is null )              --04-03-24 
   and upper(trim(TransType)) ='CREDIT-PURCHASE'  -- this has to be done dynamically 
 update importbatchdata set orignalsupplydate = issuedate where orignalsupplydate is null and batchid = @batchid and upper(trim(TransType)) ='UNCLASSIFIED'

   update importbatchdata set buyercountrycode = 'SA' where (buyercountrycode is null or buyercountrycode = '') and batchid = @batchid  and upper(trim(TransType)) ='CREDIT-PURCHASE'        
 update importbatchdata set TotalTaxableAmount = abs(TotalTaxableAmount), GrossPrice = abs(GrossPrice),         
    netprice = abs(netprice), vatlineamount = abs(vatlineamount), lineamountinclusivevat = abs(lineamountinclusivevat), linenetamount = abs(linenetamount) where batchid = @batchid  and upper(trim(TransType)) ='CREDIT-PURCHASE'      
  --update ImportBatchData set TransType  = 'Purchases' where batchid = @batchid and (TransType  is null or transtype = '')        
  update importbatchdata set Isapportionment = 0 where batchid = @batchid and (Isapportionment is null ) and upper(trim(TransType)) ='CREDIT-PURCHASE'         
  update importbatchdata set VATDeffered = 0 where batchid = @batchid and (VATDeffered is null) and upper(trim(TransType)) ='CREDIT-PURCHASE'        
  update importbatchdata set AffiliationStatus  = 0 where batchid = @batchid and (AffiliationStatus  is null) and upper(trim(TransType)) ='CREDIT-PURCHASE'        
  update importbatchdata set InvoiceCurrencyCode = 'SAR' where batchid = @batchid and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='') and upper(trim(TransType)) ='CREDIT-PURCHASE'         
  update importbatchdata set orignalsupplydate = issuedate where orignalsupplydate is null and batchid = @batchid and upper(trim(TransType)) ='CREDIT-PURCHASE'       
  update ImportBatchData set InvoiceLineIdentifier = 1 where batchid = @batchid and (InvoiceLineIdentifier is null or InvoiceLineIdentifier =0 )  and upper(trim(TransType)) ='CREDIT-PURCHASE'        
  update ImportBatchData set Quantity =1 where batchid = @batchid and (Quantity =0 or Quantity is null) and upper(trim(TransType)) ='CREDIT-PURCHASE'       
  update ImportBatchData set GrossPrice = LineNetAmount where batchid = @batchid and (GrossPrice =0 or GrossPrice is null)  and upper(trim(TransType)) ='CREDIT-PURCHASE'      
     update ImportBatchData set NetPrice  = LineNetAmount where  batchid = @batchid and (NetPrice  =0 or netprice is null) and upper(trim(TransType)) ='CREDIT-PURCHASE'       
  update ImportBatchData set Discount = 0 where batchid = @batchid and (Discount =0 or Discount  is null)  and upper(trim(TransType)) ='CREDIT-PURCHASE'      
     update ImportBatchData set LineAmountInclusiveVAT = LineNetAmount + VATLineAmount where batchid = @batchid and ISNULL(LineAmountInclusiveVAT,0)=0  and upper(trim(TransType)) ='CREDIT-PURCHASE'      
  update ImportBatchData set TotalTaxableAmount  = LineNetAmount  + isnull(CustomsPaid,0) + isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0)  where batchid = @batchid  and upper(trim(TransType)) ='CREDIT-PURCHASE'      
  update ImportBatchData set OrgType = 'PRIVATE' where batchid = @batchid and (orgtype is null or orgtype = '')  and upper(trim(TransType)) ='CREDIT-PURCHASE'      
  update ImportBatchData set VatRate = 15 where vatrate = 0.15 and batchid = @batchid  and upper(trim(TransType)) ='CREDIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set VatRate = 5 where vatrate = 0.05 and batchid = @batchid  and upper(trim(TransType)) ='CREDIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set VatCategoryCode ='S' where batchid = @batchid and vatrate in (15,5) and BuyerCountryCode like 'SA%' and upper(trim(TransType)) ='CREDIT-PURCHASE' -- this has to be done dynamically        
  -- update query for out of scope        
  -- update query for exempt        
   --update ImportBatchData set VatCategoryCode ='Z' where batchid = @batchid and vatrate in (0) and (VatCategoryCode ='' or VatCategoryCode is null) and upper(trim(TransType)) ='CREDIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='CN Purchase-STANDARD' where invoicetype = 'CN Purchase- ' and BuyerCountryCode like 'SA%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT-PURCHASE'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='CN Purchase-STANDARD' where invoicetype like '%STANDARD%' and BuyerCountryCode like 'SA%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='CN Purchase-IMPORTS' where (invoicetype like '%IMPORT%'         
  or (invoicetype ='CN Purchase-' and BuyerCountryCode not like 'SA%') or BuyerCountryCode not like 'SA%') and batchid = @batchid  and upper(trim(TransType)) ='CREDIT-PURCHASE'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='CN Purchase-Third Party' where invoicetype like '%Third Party%' and batchid = @batchid and upper(trim(TransType)) ='CREDIT-PURCHASE'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='CN Purchase-Self Billed' where invoicetype like '%Self Billed%' and batchid = @batchid  and upper(trim(TransType)) ='CREDIT-PURCHASE'   -- this has to be done dynamically        
        
  if upper(@catg) in ('GOODS','Services','Overhead')         
  begin          
   update ImportBatchData set PurchaseCategory = @catg         
  where (PurchaseCategory is null or PurchaseCategory='')         
  and batchid = @batchid         
  end        
        
 end        
 if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'DEBIT-PURCHASE')         
 Begin        
 SET @Desc = 'DEBIT-PURCHASE';   
   update ImportBatchData set VatCategoryCode =' ' where batchid = @batchid 
   and vatrate in (0) 
   and ( VatCategoryCode='' OR VatCategoryCode is null )              --04-03-24 
   and upper(trim(TransType)) ='DEBIT-PURCHASE'  -- this has to be done dynamically 
   set @catg = (select isnull(businesscategory,'') from TenantBasicDetails where tenantid = @tenantid);        
      
  -- this update statement added on 21-jan-2024     
  
  update importbatchdata set orignalsupplydate = issuedate where orignalsupplydate is null and batchid = @batchid and upper(trim(TransType)) ='UNCLASSIFIED'

  update importbatchdata set TotalTaxableAmount = abs(TotalTaxableAmount), GrossPrice = abs(GrossPrice),         
    netprice = abs(netprice), vatlineamount = abs(vatlineamount), lineamountinclusivevat = abs(lineamountinclusivevat), linenetamount = abs(linenetamount) where batchid = @batchid  and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  -- update end 21-jan-2024      
      
  --update ImportBatchData set TransType  = 'Purchases' where batchid = @batchid and (TransType  is null or transtype = '')        
  update importbatchdata set buyercountrycode = 'SA' where (buyercountrycode is null or buyercountrycode = '') and batchid = @batchid   and upper(trim(TransType)) ='DEBIT-PURCHASE'       
        
  update importbatchdata set Isapportionment = 0 where batchid = @batchid and (Isapportionment is null )  and upper(trim(TransType)) ='DEBIT-PURCHASE'        
  update importbatchdata set VATDeffered = 0 where batchid = @batchid and (VATDeffered is null)   and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  update importbatchdata set AffiliationStatus  = 0 where batchid = @batchid and (AffiliationStatus  is null)   and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  update importbatchdata set InvoiceCurrencyCode = 'SAR' where batchid = @batchid and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='')    and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  update ImportBatchData set InvoiceLineIdentifier = 1 where batchid = @batchid and (InvoiceLineIdentifier is null or InvoiceLineIdentifier =0 ) and upper(trim(TransType)) ='DEBIT-PURCHASE'         
  update ImportBatchData set Quantity =1 where batchid = @batchid and (Quantity =0 or Quantity is null)  and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  update ImportBatchData set GrossPrice = LineNetAmount where batchid = @batchid and (GrossPrice =0 or GrossPrice is null)  and upper(trim(TransType)) ='DEBIT-PURCHASE'      
     update ImportBatchData set NetPrice  = LineNetAmount where  batchid = @batchid and (NetPrice  =0 or netprice is null) and upper(trim(TransType)) ='DEBIT-PURCHASE'       
  update ImportBatchData set Discount = 0 where batchid = @batchid and (Discount =0 or Discount  is null)  and upper(trim(TransType)) ='DEBIT-PURCHASE'      
     update ImportBatchData set LineAmountInclusiveVAT = LineNetAmount + VATLineAmount where batchid = @batchid and ISNULL(LineAmountInclusiveVAT,0)=0  and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  update ImportBatchData set TotalTaxableAmount  = LineNetAmount  + isnull(CustomsPaid,0) + isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0)  where batchid = @batchid  and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  update ImportBatchData set OrgType = 'PRIVATE' where batchid = @batchid and (orgtype is null or orgtype = '')  and upper(trim(TransType)) ='DEBIT-PURCHASE'      
  update ImportBatchData set VatRate = 15 where vatrate = 0.15 and batchid = @batchid and upper(trim(TransType)) ='DEBIT-PURCHASE'    -- this has to be done dynamically        
  update ImportBatchData set VatRate = 5 where vatrate = 0.05 and batchid = @batchid  and upper(trim(TransType)) ='DEBIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set VatCategoryCode ='S' where batchid = @batchid and vatrate in (15,5) and BuyerCountryCode like 'SA%' and upper(trim(TransType)) ='DEBIT-PURCHASE'  -- this has to be done dynamically        
  -- update query for out of scope        
  -- update query for exempt    
    update importbatchdata set orignalsupplydate = issuedate where orignalsupplydate is null and batchid = @batchid and upper(trim(TransType)) ='DEBIT-PURCHASE'
   --update ImportBatchData set VatCategoryCode ='Z' where batchid = @batchid and vatrate in (0) and ( VatCategoryCode ='' or  VatCategoryCode is null) and upper(trim(TransType)) ='DEBIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='DN Purchase-STANDARD' where invoicetype = 'DN Purchase- ' and BuyerCountryCode like 'SA%' and batchid = @batchid  and upper(trim(TransType)) ='DEBIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='DN Purchase-STANDARD' where invoicetype like '%STANDARD%' and BuyerCountryCode like 'SA%' and batchid = @batchid and upper(trim(TransType)) ='DEBIT-PURCHASE'  -- this has to be done dynamically        
  update ImportBatchData set invoicetype='DN Purchase-IMPORTS' where (invoicetype like '%IMPORT%'         
  or (invoicetype ='DN Purchase-' and BuyerCountryCode not like 'SA%') or BuyerCountryCode not like 'SA%') and batchid = @batchid and upper(trim(TransType)) ='DEBIT-PURCHASE'    -- this has to be done dynamically        
  update ImportBatchData set invoicetype='DN Purchase-Third Party' where invoicetype like '%Third Party%' and batchid = @batchid  and upper(trim(TransType)) ='DEBIT-PURCHASE'   -- this has to be done dynamically        
  update ImportBatchData set invoicetype='DN Purchase-Self Billed' where invoicetype like '%Self Billed%' and batchid = @batchid and upper(trim(TransType)) ='DEBIT-PURCHASE'    -- this has to be done dynamically        
        
  if upper(@catg) in ('GOODS','Services','Overhead')         
  begin          
   update ImportBatchData set PurchaseCategory = @catg         
  where (PurchaseCategory is null or PurchaseCategory='')         
  and batchid = @batchid         
  end        
 end        
 if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'PAYMENT')          
 Begin        
 SET @Desc = 'PAYMENT';        
        
  update ImportBatchData set OrgType = 'PRIVATE' where batchid = @batchid and (orgtype is null or orgtype = '') and upper(trim(TransType)) ='PAYMENT'       
  update ImportBatchData set InvoiceType='Overhead' where BatchId=@BatchId and (InvoiceType is null or InvoiceType ='')  and upper(trim(TransType)) ='PAYMENT'       
  update ImportBatchData set  PaymentMeans='Payment' where BatchId=@BatchId and (PaymentMeans is null or PaymentMeans='') and upper(trim(TransType)) ='PAYMENT'        
  update ImportBatchData set AffiliationStatus='Non-affiliate' where BatchId=@BatchId and (AffiliationStatus is null or AffiliationStatus='')  and upper(trim(TransType)) ='PAYMENT'       
  update ImportBatchData set VATDeffered=0 where BatchId=@BatchId and (VATDeffered is null or VATDeffered='')  and upper(trim(TransType)) ='PAYMENT'       
  update ImportBatchData  set LineNetAmount=0.00 where BatchId=@BatchId and (LineNetAmount is null or LineNetAmount=0.00)  and upper(trim(TransType)) ='PAYMENT'       
  update ImportBatchData set VATRate=0.00 where BatchId=@BatchId and (VATRate is null or VATRate=0.00)  and upper(trim(TransType)) ='PAYMENT' 
  --For the functionality of nature of service
  update ImportBatchData set NatureofServices =(select top 1 natureofservice from HeadOfPayment where name = ImportBatchData.ItemName) where batchid=@batchid and ItemName is not null        
  update ImportBatchData set LedgerHeader = ImportBatchData.ItemName where batchid=@batchid and ItemName is not null 
        
 end        
    SET NOCOUNT ON        
 Insert into Logs( [json]        
      ,[date]        
      ,[batchid])        
   Values('InsertBatchUploadDefaultValues Called '+@Desc, GetDate(),@BatchId)        
        
END
GO
