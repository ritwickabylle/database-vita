SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create       procedure [dbo].[getOverheadApportionmentPreviousData]  --exec getOverheadApportionmentPreviousData 130,'Detailed'      
(        
@tenantid int,      
@type nvarchar(20)      
)        
as        
begin  
      
if(@type='Summary')      
begin      
if exists(select Type from ApportionmentBaseData where TenantId=@tenantid and Type='Summary')      
begin      
select [TaxableSupply] as taxableSupplies, [ExemptSupply]as exemptSupplies, [TotalExemptSales]as exemptTaxableSupplies, TaxablePurchase as taxablePurchase , [ExemptPurchase]as exemptPurchase,      
[TotalExemptPurchase]as exemptTaxablePurchase, [ApportionmentSupplies]      
 as percentageofTaxable from ApportionmentBaseData        
where TenantId=@tenantid  and [Type]=@type       
end      
else      
begin      
select [TaxableSupply] as taxableSupplies, [ExemptSupply]as exemptSupplies, [TotalExemptSales]as exemptTaxableSupplies, TaxablePurchase as taxablePurchase , [ExemptPurchase]as exemptPurchase,      
[TotalExemptPurchase]as exemptTaxablePurchase,case when @type='Detailed' then      
(select ApportionmentSupplies from ApportionmentBaseData          
where TenantId=@tenantid  and [Type]='Previous' and [Date]='Total') else ApportionmentSupplies end as percentageofTaxable       
 from ApportionmentBaseData          
where TenantId=@tenantid  and [Type]='Detailed' and [Date]='Total'      
end      
      
end      
else      
begin   
if(@type='Previous')  
begin  
select [TaxableSupply] as taxableSupplies, [ExemptSupply]as exemptSupplies, [TotalExemptSales]as exemptTaxableSupplies, TaxablePurchase as taxablePurchase , [ExemptPurchase]as exemptPurchase,      
[TotalExemptPurchase]as exemptTaxablePurchase, [ApportionmentSupplies]      
as percentageofTaxable ,[Type] as [type],[date] as [date] from ApportionmentBaseData        
where TenantId=@tenantid  and [Type]=@type   
end  
else  
begin  
select [TaxableSupply] as taxableSupplies, [ExemptSupply]as exemptSupplies, [TotalExemptSales]as exemptTaxableSupplies, TaxablePurchase as taxablePurchase , [ExemptPurchase]as exemptPurchase,      
[TotalExemptPurchase]as exemptTaxablePurchase, case when @type='Detailed' then      
(select ApportionmentSupplies from ApportionmentBaseData          
where TenantId=@tenantid  and [Type]='Previous' and [Date]='Total') else ApportionmentSupplies end as percentageofTaxable  ,[Type] as [type],[date] as [date] from ApportionmentBaseData        
where TenantId=@tenantid  and [Type]=@type   
end  
end      
end
GO
