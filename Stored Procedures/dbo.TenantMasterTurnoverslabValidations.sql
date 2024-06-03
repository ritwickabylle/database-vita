SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[TenantMasterTurnoverslabValidations]  -- exec TenantMasterTurnoverslabValidations 155123          
(          
@BatchNo numeric  ,
@tenantid numeric
)          
as       
set nocount on     
begin          
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype = 303        
end          
          
begin          
          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Turnover slab cannot be blank',303,0,getdate() from ImportMasterBatchData with(nolock)           
where  UPPER(TurnoverSlab) not in       
 --not in ('<40 MM ','>40MM','<375000')      
 (select upper(name) from businessTurnoverSlab   )   and batchid=@batchno and tenantid=@tenantid
            
      
end
GO
