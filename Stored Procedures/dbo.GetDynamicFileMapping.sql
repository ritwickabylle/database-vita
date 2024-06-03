SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetDynamicFileMapping]   --  exec GetDynamicFileMapping 'VAT'  
  
@module nvarchar(max)= 'VAT'        
  
as begin       
  
   
  
if (@module is not null)  
begin    
  
   
  
    SELECT DISTINCT [Country],[Module],[TransactionType],[Field],[DefaultValue],[IsMandatory],[DisplaySequence],[DisplayName],[DataType]  
    FROM DynamicFileMapping  
    where [Module] = @module and [IsActive] = 1 order by DisplaySequence asc  
  
end    
end
GO
