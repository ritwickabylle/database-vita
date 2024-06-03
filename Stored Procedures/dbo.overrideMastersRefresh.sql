SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          PROCEDURE [dbo].[overrideMastersRefresh]      -- exec overrideMastersRefresh null,1

@uuid uniqueidentifier,
@batchno int

AS       

declare @mastertype nvarchar(50),
@tenantid int

      
begin

if @uuid is not null 
   begin
   --insert into logs(batchid,date,json) values(@batchno,getdate(),'uuid')
     delete from importmaster_Errorlists where uniqueIdentifier= @uuid and errortype in (select code from ErrorType where ErrorGroupId = 3)
   
   set @mastertype = (select mastertype from ImportMasterBatchData where UniqueIdentifier = @uuid)

   set @tenantid = (select tenantid from ImportMasterBatchData where UniqueIdentifier = @uuid)

  end

if @batchno is not null and @uuid is null
   begin
     -- insert into logs(batchid,date,json) values(@batchno,getdate(),'Batch')

     delete from importmaster_Errorlists where Batchid = @batchno and errortype in (select code from ErrorType where ErrorGroupId = 3)
  
     set @mastertype = (select distinct mastertype from ImportMasterBatchData where batchid = @batchno )

     set @tenantid = (select distinct tenantid from ImportMasterBatchData where batchid = @batchno)

  end
 
end


if @mastertype = 'Tenant'
begin
  exec TenantTransValidation @batchno,@tenantid
end
if @mastertype = 'Customer'
begin
  exec CustomerMasterValidation @batchno,@tenantid
end
if @mastertype = 'Vendor'
begin
  exec VendorTransValidation @batchno,@tenantid
end
GO
