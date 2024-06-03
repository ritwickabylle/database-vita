SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create            procedure [dbo].[PurchaseTransDateValidationwithinTaxableRange]           --exec PurchaseTransDateValidationwithinTaxableRange 31,'2022-09-01','2022-09-30'      
(                
@batchno numeric,  
@fmdate date,  
@todate date,
@validstat int
  
)                
as                
begin                
  
Declare @VATReturnFillingFrequency varchar  
Declare @filingFrequency numeric  
  
--set @VATReturnFillingFrequency = (Select VATReturnFillingFrequency from TenantBasicDetails where tenantid = (select tenantid from batchdata where batchid = @batchno))  
  
--set @filingFrequency  = case when @VATReturnFillingFrequency=null or trim(upper(@VATReturnFillingFrequency)) = 'MONTHLY' then 1 else 3 end    
  
update VI_importstandardfiles_Processed set effdate = IssueDate  where issuedate > OrignalSupplyDate    
and OrignalSupplyDate  < @fmdate and BatchId = @batchno and InvoiceType like 'Purchase%'  
  
end
GO
