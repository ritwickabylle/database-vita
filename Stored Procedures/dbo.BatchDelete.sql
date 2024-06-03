SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
  
CREATE        procedure [dbo].[BatchDelete]  --  exec BatchDelete 776,1      
(               
         
@batchno numeric,
@MastTrans int,
@tenantid int
)          
as          
    
set nocount on    
    
Begin      

if @MastTrans = 1 -- Master Batch Delete
   begin
      if @batchno = 0
	     begin
		   delete from BatchMasterData where tenantid = @tenantid
		   delete from ImportMasterBatchData where tenantid = @tenantid
		   delete from importmaster_ErrorLists where tenantid = @tenantid 
		   delete from Masteroverride where tenantid = @tenantid
		   delete from VI_ImportMasterFiles_Processed where tenantid = @tenantid
		 end
      else
	     begin
		   delete from BatchMasterData where tenantid = @tenantid and batchid = @batchno
		   delete from ImportMasterBatchData where tenantid = @tenantid and batchid = @batchno
		   delete from importmaster_ErrorLists where tenantid = @tenantid and batchid = @batchno
		   delete from Masteroverride where tenantid = @tenantid  and batchid = @batchno
		   delete from VI_ImportMasterFiles_Processed where tenantid = @tenantid and batchid = @batchno
		 end
   end
else if @MastTrans = 2 -- Transaction Batch Delete
   begin
      if @batchno = 0
	     begin
		   delete from BatchData where tenantid = @tenantid
		   delete from ImportBatchData where tenantid = @tenantid
		   delete from importstandardfiles_ErrorLists where tenantid = @tenantid 
		   delete from transactionoverride where tenantid = @tenantid
		   delete from VI_ImportstandardFiles_Processed where tenantid = @tenantid
		   delete from vi_importoverheadfiles_processed where tenantid = @tenantid
		 end
      else
	     begin
		   delete from BatchData where tenantid = @tenantid and batchid = @batchno
		   delete from ImportBatchData where tenantid = @tenantid and batchid = @batchno
		   delete from importstandardfiles_ErrorLists where tenantid = @tenantid and batchid = @batchno
		   delete from transactionoverride where tenantid = @tenantid  and batchid = @batchno
		   delete from VI_ImportstandardFiles_Processed where tenantid = @tenantid and batchid = @batchno
		   delete from vi_importoverheadfiles_processed where tenantid = @tenantid and batchid = @batchno
		 end
     end
end
GO
