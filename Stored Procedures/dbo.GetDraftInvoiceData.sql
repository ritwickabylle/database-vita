SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[GetDraftInvoiceData]   
  
@IrnNo nvarchar(10) =52,   
  
@tenantId int = 127,  
  
@transtype NVARCHAR(10) = '388'  
  
AS   
  
  
BEGIN   
  Select id as IRNNo,
  UniqueIdentifier
  from draft
  where   
  Id = @IrnNo   
  
  and tenantid = @tenantId;

select   
  
  *   
  
from   
  
  Draft   
  
where   
  
  Id = @IrnNo   
  
  and tenantid = @tenantId;  
  
Select   
  
  *   
  
from   
  
  DraftItem   
  
where   
  
  IRNNo = @IrnNo   
  
  and tenantid = @tenantId and IsDeleted=0;  
  
Select   
  
  *   
  
from   
  
  DraftSummary   
  
where   
  
  IRNNo = @IrnNo   
  
  and tenantid = @tenantId;  
  
Select   
  
  *   
  
from   
  
  DraftParty   
  
where   
  
  IRNNo = @IrnNo   
  
  and tenantid = @tenantId and  ISNULL(Language,'EN')='EN';  
  
Select   
  
  *   
  
from   
  
  DraftAddress   
  
where   
  
  IRNNo = @IrnNo   
  
  and tenantid = @tenantId and  ISNULL(Language,'EN')='EN';  
  
Select *   
  
from   
  
  DraftContactPerson   
  
where   
  
  IRNNo = @IrnNo   
  
  and tenantid = @tenantId and  ISNULL(Language,'EN')='EN';  
  
Select   
  
  *   
  
from   
  
  DraftVATDetail   
  
where   
  
  IRNNo = @IrnNo   
  
  and tenantid = @tenantId;  
  
Select   
  
  *   
  
from   
  
  DraftDiscount   
  
where   
  
  IRNNo = @IrnNo   
  
  and tenantid = @tenantId;    
END
GO
