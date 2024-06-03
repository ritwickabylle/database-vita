SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create        procedure [dbo].[InsertXMLLog](    
   @uuid uniqueidentifier    
           ,@createdOn datetime    
           ,@createdBy int    
           ,@tenantId int    
           ,@signature nvarchar(max)=''    
           ,@certificate nvarchar(max)=''    
           ,@xml64 nvarchar(max)=''    
           ,@invoiceHash64 nvarchar(100)=''    
   ,@qrBase64 nvarchar(max)=''    
           ,@csid nvarchar(max)=''    
           ,@complianceInvoiceResponse nvarchar(max)=''    
           ,@reportInvoiceResponse nvarchar(max)=''    
           ,@clearanceResponse nvarchar(max)=''  
     ,@vatAmount decimal(18,2)  
     ,@totalAmount decimal(18,2)  
     ,@irnno int  
     ,@errors nvarchar(max)=''  
     ,@status nvarchar(20))    
as    
begin    
INSERT INTO logs_xml    
           ([uuid]    
           ,[createdOn]    
           ,[createdBy]    
           ,[tenantId]    
           ,[signature]    
           ,[certificate]    
           ,[xml64]    
           ,[invoiceHash64]    
           ,[csid]    
   ,[qrBase64]    
           ,[complianceInvoiceResponse]    
           ,[reportInvoiceResponse]    
           ,[clearanceResponse]  
     ,[totalAmount]  
     ,[vatAmount]  
     ,[errors]  
     ,[irnno]  
     ,[status])    
     VALUES    
           (@uuid    
,@createdOn    
,@createdBy    
,@tenantId    
,@signature    
,@certificate    
,@xml64    
,@invoiceHash64    
,@csid    
,@qrBase64    
,@complianceInvoiceResponse    
,@reportInvoiceResponse    
,@clearanceResponse  
,@totalAmount  
,@vatAmount  
,@errors  
,@irnno  
,@status)    
end
GO
