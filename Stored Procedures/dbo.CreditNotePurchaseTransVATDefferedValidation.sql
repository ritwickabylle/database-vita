SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[CreditNotePurchaseTransVATDefferedValidation]   
(  
 @batchno int,  
 @tenantid int,  
 @validstat int  
)  
as  
begin  
begin                      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(565)                    
end      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
            
select tenantid,@batchno,uniqueidentifier,'0','Invalid VAT deffered',565,0,getdate() from  ##salesImportBatchDataTemp  
where upper(InvoiceType) like 'CN PURCHASE%' AND upper(InvoiceType) like '%IMPORT%' and upper(PurchaseCategory) like 'GOOD%' and upper(BuyerCountryCode) not like 'SA%' 
and VATDeffered=1 and VatCategoryCode not like 'S' and BatchId=@batchno and TenantId=@tenantid
end
GO
