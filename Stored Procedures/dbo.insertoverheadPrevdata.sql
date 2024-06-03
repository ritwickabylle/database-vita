SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[insertoverheadPrevdata]            
(            
    @tenantId INT,            
    @TaxableSupplies DECIMAL(18, 2),  
    @ExemptSupplies DECIMAL(18, 2),  
    @ExemptTaxableSupplies DECIMAL(18, 2),  
    @TaxablePurchase DECIMAL(18, 2),  
    @ExemptPurchase DECIMAL(18, 2),  
    @ExemptTaxablePurchase DECIMAL(18, 2),  
    @PercentageofTaxable DECIMAL(18, 2),  
 @Type nvarchar(max),  
 @Date nvarchar(max) = null        
)            
AS            
BEGIN          
declare @count int = 0;        
declare @findate datetime = getdate();  
declare @finstartdate date                      
declare @finenddate date  
  
set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid) --in (select tenantid from ImportBatchData where BatchId=@batchno))                      
                      
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid)  --in (select tenantid from ImportBatchData where BatchId=@batchno))    
  
if (@type = 'Detailed')  
begin        
select @count=count(*) from ApportionmentBaseData where [Type] = @type and substring(FinYear,6,9) = year(@finenddate) and ([date] = 'Total' or [date]=@date) and tenantid = @tenantId        
end        
else if (@type = 'Nominal')  
begin        
select @count=count(*) from ApportionmentBaseData where [Type] = @type and substring(FinYear,6,9) = year(@finenddate) and ([date] = 'Total' or [date]=@date) and tenantid = @tenantId        
end        
else        
begin        
select @count=count(*) from ApportionmentBaseData where [Type] = @type and substring(FinYear,6,9) = year(@finenddate)  and tenantid = @tenantId       
end        
if(@count=0)        
begin        
--select * from ApportionmentBaseData
    INSERT INTO ApportionmentBaseData           
 (UniqueIdentifier,TenantId, [TaxableSupply], [ExemptSupply], [TotalExemptSales], TaxablePurchase, [ExemptPurchase], [TotalExemptPurchase], [ApportionmentSupplies],[ApportionmentPurchases],[Type],
 [Date],CreationTime,IsDeleted,FinYear,EffectiveFromDate,EffectiveTillEndDate,TotalSupply,TotalPurchase )            
    VALUES (newid(),          
 @tenantId,          
 @TaxableSupplies,          
 @ExemptSupplies,          
 @ExemptTaxableSupplies,          
 @TaxablePurchase,          
 @ExemptPurchase,          
 @ExemptTaxablePurchase,          
 case when (@TaxableSupplies = 0 or @ExemptTaxableSupplies=0) then @PercentageofTaxable else (@TaxableSupplies/@ExemptTaxableSupplies)*100 end,        
 case when (@TaxablePurchase = 0 or @ExemptTaxablePurchase=0) then 0 else (@TaxablePurchase/@ExemptTaxablePurchase)*100 end,        
 @Type,          
 --isnull(@Date,' '),          
     CASE           
        WHEN @Date = '0' THEN '1'+'-'+cast(year(@finenddate) as nvarchar(50))          
        WHEN @Date = '1' THEN '2'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '2' THEN '3'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '3' THEN '4'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '4' THEN '5'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '5' THEN '6'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '6' THEN '7'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '7' THEN '8'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '8' THEN '9'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '9' THEN '10'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '10' THEN '11'+'-'+cast(year(@finenddate) as nvarchar(50))        
        WHEN @Date = '11' THEN 'Total'        
        ELSE 'Total'          
    END,          
 getdate(),0,        
  cast(year(@finstartdate) as nvarchar(20))+'-'+cast(year(@finenddate) as nvarchar(20)),  
  @finstartdate,  
  @finenddate,
  isnull(@TaxableSupplies,0)+isnull(@ExemptSupplies,0),
  isnull(@TaxablePurchase,0)+isnull(@ExemptPurchase,0)
  )  
        
 end        
        
 else    
 if(@Type='Detailed' or @Type = 'Nominal')        
        
 begin        
 update ApportionmentBaseData set TaxableSupply=@TaxableSupplies,[ExemptSupply]=@ExemptSupplies,TotalExemptSales=@ExemptTaxableSupplies,        
 TaxablePurchase=@TaxablePurchase, [ExemptPurchase]=@ExemptPurchase, [TotalExemptPurchase]=@ExemptTaxablePurchase,
 totalsupply=@taxablesupplies+@exemptsupplies, totalPurchase=@TaxablePurchase + @ExemptPurchase,  
 [ApportionmentSupplies]=case when (@TaxableSupplies = 0 or @ExemptTaxableSupplies=0) then 0 else (@TaxableSupplies/@ExemptTaxableSupplies)*100 end,        
 [ApportionmentPurchases] = case when (@TaxablePurchase = 0 or @ExemptTaxablePurchase=0) then 0 else (@TaxablePurchase/@ExemptTaxablePurchase)*100 end        
 where TenantId=@tenantId and [type]=@Type  
 and [date] = @date      
 end        
        
 else        
 begin        
 update ApportionmentBaseData set TaxableSupply=@TaxableSupplies,[ExemptSupply]=@ExemptSupplies,TotalExemptSales=@ExemptTaxableSupplies,        
 TaxablePurchase=@TaxablePurchase, [ExemptPurchase]=@ExemptPurchase, [TotalExemptPurchase]=@ExemptTaxablePurchase, [ApportionmentSupplies]=@PercentageofTaxable,        
 totalsupply=@taxablesupplies+@exemptsupplies, totalPurchase=@TaxablePurchase + @ExemptPurchase,
 [ApportionmentPurchases] = case when (@TaxablePurchase = 0 or @ExemptTaxablePurchase=0) then 0 else (@TaxablePurchase/@ExemptTaxablePurchase)*100 end        
 where TenantId=@tenantId and [type]=@Type and substring(FinYear,6,9) = cast(year(@finenddate) as nvarchar(20)) and [Date] = 'Total'        
 end        
END
GO
