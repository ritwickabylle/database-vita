SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	CREATE         procedure [dbo].[GetPurchaseDetailedReport]  --exec GetPurchaseDetailedReport '2023-02-01', '2023-02-28',33,'VATPUR000'   
	(          
	@fromDate Date=null,          
	@toDate Date=null,    
	@tenantId int=null ,  
	@code nvarchar(max)=null,
	@type NVARCHAR(MAX)=NULL,          
    @text NVARCHAR(MAX)=NULL
	)          
	as begin          
  
	declare @sql nvarchar(max)  

	set @sql = (select SPname from ReportCode where Code = @code)  

   if @code is null or @sql is null or len(@sql)=0
	begin
	
	exec GetPurchaseDetailedReportEffdate @fromDate,@toDate,@tenantId,@type,@text
	end

	else
	begin

	exec @sql @fromDate,@toDate,@tenantId,@code
	
  end

  END
	 --select LineNetAmount,VatCategoryCode,BuyerCountryCode from VI_importstandardfiles_Processed where batchid=926 and id=87250
GO
