SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create   procedure [dbo].[GetTaxcodeDropdown]     -- exec GetTaxcodeDropdown

as begin 

declare @CITTaxCodeDropdown as table 

(BSIS  nvarchar(50),        
   Description  nvarchar(max),
   TaxCode nvarchar(max) )


 --   insert into @CITTaxCodeDropdown
	--(
	--BSIS ,
	--Description ,
	--TaxCode
	--)

	-- select      
        
       
 --      '' as BSIS,        
 --       '' as Description,
	--	'' AS TaxCode

		insert into @CITTaxCodeDropdown(BSIS,Description,TaxCode)         
values('IS','Income from Operational Activity',10101)

		insert into @CITTaxCodeDropdown(BSIS,Description,TaxCode)         
values('IS','Income from Insurance',10102)


		insert into @CITTaxCodeDropdown(BSIS,Description,TaxCode)         
values('IS','Income from Contracts',10103)

select 
BSIS,        
   Description ,
   TaxCode 
   from @CITTaxCodeDropdown
   end
GO
