SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[getExemptionReason]  
@vatcode nvarchar(10)  
AS  
BEGIN  
select Id,Name,Description,Code from ExemptionReason where Code=@vatcode AND IsActive=1  
END
GO
