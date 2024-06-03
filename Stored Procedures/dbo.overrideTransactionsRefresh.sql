SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
CREATE              PROCEDURE [dbo].[overrideTransactionsRefresh]      -- exec overrideTransactionsRefresh null,152         
          
@uuid uniqueidentifier='43603F15-F032-4A1F-BBD8-178284E01B62',          
@batchno int=8100          
          
AS                 
--delete from Transactionoverride           
declare @Transtype nvarchar(100),          
@tenantid int          
   
 set @tenantid=(select distinct tenantid from importbatchdata where batchid=@batchno)  
                
begin          
       
if @uuid is not null           
   begin          
     set @Transtype = (select invoicetype from ImportBatchData where UniqueIdentifier = @uuid)         
    
  if left(@transtype,5)= 'Sales'         
  begin        
        
     update ImportBatchData set invoicetype = 'Sales Invoice - Standard' , VatCategoryCode = 'S'         
  where batchid = @batchno and vatCategoryCode = 'O' and UniqueIdentifier in (select UniqueIdentifier         
  from importstandardfiles_ErrorLists  where uniqueIdentifier  = @uuid and errortype in (123,463))        
        
  end        
  if left(@transtype,8) = 'Purchase'         
  begin        
        
     update ImportBatchData set invoicetype = 'Purchase Entry - Standard' , VatCategoryCode = 'S'         
  where batchid = @batchno and vatCategoryCode = 'O' and UniqueIdentifier in (select UniqueIdentifier         
  from importstandardfiles_ErrorLists  where uniqueIdentifier  = @uuid and errortype in (630,161)) 
  
     update ImportBatchData set invoicetype = 'Purchase Entry - IMPORTS' , VATDeffered=1      
  where batchid = @batchno   and UniqueIdentifier in (select UniqueIdentifier         
  from importstandardfiles_ErrorLists  where uniqueIdentifier  = @uuid and errortype in (739))  
        
  end        
   
   

              
  
     --insert into logs(batchid,date,json) values(@batchno,getdate(),'uuid')          
     delete from importstandardfiles_Errorlists where uniqueIdentifier= @uuid and errortype in (select code from ErrorType where ErrorGroupId = 3)          
        
          
  end          
          
if @batchno is not null and @uuid is null          
   begin        
  -- if override option is done for error number 123         
  
     set @Transtype = (select top 1 invoicetype from ImportBatchData where batchid = @batchno)     
      
    if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'SALES')          
  begin        
  
     update ImportBatchData set invoicetype = 'Sales Invoice - Standard' , VatCategoryCode = 'S'         
  where batchid = @batchno and vatCategoryCode = 'O' and UniqueIdentifier in (select UniqueIdentifier         
  from importstandardfiles_ErrorLists  where batchid = @batchno and errortype = 123)  and upper(trim(TransType)) = 'SALES'    
        
  end        
     if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'PURCHASE' )             
  begin        
  
     update ImportBatchData set invoicetype = 'Purchase Entry - Standard' , VatCategoryCode = 'S'         
  where batchid = @batchno and vatCategoryCode = 'O' and UniqueIdentifier in (select UniqueIdentifier         
  from importstandardfiles_ErrorLists  where batchid = @batchno and errortype in (630,161)) and upper(trim(TransType)) = 'PURCHASE'         
        
  end       
    
  
            
     delete from importstandardfiles_Errorlists where Batchid = @batchno and errortype in (select code from ErrorType where ErrorGroupId = 3)          
   
--  set @Transtype = (select top 1 invoicetype from ImportBatchData where batchid = 8088)          
  end          
           
end          
        
 print(@batchno);  
 print(@tenantid);  
 if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'SALES')          
begin          
  insert into logs(batchid,date,json) values(@batchno,getdate(),'Override(Sales)')             
  exec SalesTransValidation @batchno,1 ,@tenantid      
end          
 if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'CREDIT')          
begin          
  insert into logs(batchid,date,json) values(@batchno,getdate(),'Override(Credit)')             
          
  exec CreditNoteTransValidation @batchno,1,@tenantid         
end          
 if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'PURCHASE')          
begin          
  --insert into logs(batchid,date,json) values(@batchno,getdate(),'Override(Purchase)')          
  exec PurchaseTransValidation  @batchno,1 ,@tenantid        
end          
 if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'CREDIT-PURCHASE')          
begin    
  
  exec CreditNotePurchaseTransValidation  @batchno,1,@tenantid     
  
end          
 if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'DEBIT-PURCHASE')          
begin          
  exec DebitNotePurchaseTransValidation  @batchno ,1 ,@tenantid        
end          
 if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'DEBIT')          
begin          
  insert into logs(batchid,date,json) values(@batchno,getdate(),'Override(Debit)')             
      
  exec DebitNoteTransValidation   @batchno ,1  ,@tenantid     
end          
 if exists (select top 1 id from ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'PAYMENT')        
begin          
  exec PaymentTransValidation   @batchno ,1,@tenantid        
end    
  
    
--select * from logs order by id desc
GO
