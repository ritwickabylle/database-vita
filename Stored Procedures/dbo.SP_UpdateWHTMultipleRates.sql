SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
create           procedure [dbo].[SP_UpdateWHTMultipleRates]         
(        
@batchno numeric,    
@uuid nvarchar(max),
@rate numeric(6,2),
@comment nvarchar(max)
)        
as        
begin        

-- select * into VI_PaymentWHTRateMR from VI_PaymentWHTRate where 1=2         

--		 select * from VI_PaymentWHTRate 

delete from VI_PaymentWHTRateMR where  batchid = @batchno and UniqueIdentifier  = @uuid       
        
INSERT INTO [VI_PaymentWHTRateMR]        
           ([UniqueIdentifier]
		   ,StandardRate
           ,[BatchId]        
           ,[RateSlno]        
           ,[LawRate]        
           ,[EffRate]        
           ,[ServiceName]        
           )             
                   
     select   
	        [UniqueIdentifier]
		   ,StandardRate
           ,[BatchId]        
           ,[RateSlno]        
           ,[LawRate]        
           ,[EffRate]        
           ,[ServiceName]
     from VI_PaymentWHTRate where Batchid=@batchno and UniqueIdentifier =@uuid     
  
       
update VI_PaymentWHTRate set effrate = @rate where Batchid= @batchno and UniqueIdentifier = @uuid	   

update VI_importstandardfiles_Processed set reasonforCN = @comment where Batchid= @batchno and UniqueIdentifier = @uuid	   

end
GO
