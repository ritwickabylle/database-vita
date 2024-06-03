SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[PurchaseTransVATDefferedValidation]       
(      
 @batchno int,      
 @tenantid int,      
 @validstat int      
)      
as      
begin      
begin                          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(558)                        
end          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
                
select tenantid,@batchno,uniqueidentifier,'0','Invalid VAT deffered',558,0,getdate() from  ##salesImportBatchDataTemp      
where upper(InvoiceType) like 'PURCHASE%' AND upper(InvoiceType) like '%IMPORT%' and upper(PurchaseCategory) like 'GOOD%' and upper(BuyerCountryCode) not like 'SA%' and VATDeffered=1 and VatCategoryCode not in ('S','E','Z','O')    
and BatchId=@batchno and TenantId=@tenantid  
end
GO
