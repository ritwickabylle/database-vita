SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
          
create         procedure [dbo].[UpdateInvoiceStatus]  -- UpdateInvoiceStatus 'I',4, 770,'207504',''          
(          
@Status nvarchar(50),          
@TenantId int=null,          
@BatchId int,          
@refNo nvarchar(50)=null   ,      
@errors nvarchar(max)  ,    
@irnno nvarchar(100)=null    ,
@invoiceType varchar(50)='',
@isXmlSigned bit=0,
@isPdfGenerated bit=0,
@inputData nvarchar(max)=null
)          
as          
begin          
--select * into #statusMaster from (          
--select 'R' as status,          
--1 as priority          
--union          
--select 'V' as status,          
--2 as priority          
--union          
--select 'X' as status,          
--3 as priority          
--union          
--select 'I' as status,          
--4 as priority          
--) as x  ;        
update importbatchdata set AffiliationStatus=@Status,Error=@errors, IRNNo=@irnno where batchId=@BatchId and InvoiceNumber=@refNo  ;
if @Status='R' or @Status='V'
begin
insert into InvoiceStatus(invoiceType,
status,
irnno,
batchId ,
invoiceNumber,isXmlSigned,isPdfGenerated,inputData,TenantId ) values (@invoiceType,@Status,@irnno,@BatchId,@refNo,@isXmlSigned,@isPdfGenerated,@inputData,@TenantId);
end
else
begin
update InvoiceStatus set status=@status,isXmlSigned=@isXmlSigned,isPdfGenerated=@isPdfGenerated,inputData=@inputData
where irnno=@irnno and TenantId=@TenantId
end
end
GO
