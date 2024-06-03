SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[GetSubDropdownSalesReportType] @code varchar(max)  as Begin     
if(@code='VATSAL005')     
begin select distinct taxcode as SubCode,Description as SubReportName from taxmaster,reportcode   where Active=1 end     
if(@code='VATSAL006') begin     
select distinct d.CustomerID as SubCode , cast(c.name as nvarchar(30))+space(10 - len(customerid) +   
cast(customerId as nvarchar(10))) as SubReportName from  customers  c  
inner join customerdocuments d on c.tenantid=d.tenantid and c.uniqueidentifier = d.customeruniqueidentifier  
  
--,customerdocuments d,reportcode r,country T where r.code=@code    
end    
if(@code='VATSAL007')     
begin     
select distinct  cast(AlphaCode as nvarchar(20))+'-'+upper(trim(RIGHT(Name , LEN(Name) - CHARINDEX('-', Name)))) as SubCode , 
cast(AlphaCode as nvarchar(20))+'-'+upper(trim(RIGHT(Name , LEN(Name) - CHARINDEX('-', Name)))) as SubReportName from country where isActive=1   
--,reportcode  where code=@code       
end End




 --select distinct  cast(AlphaCode as nvarchar(20))+'-'+upper(trim(RIGHT(Name , LEN(Name) - CHARINDEX('-', Name)))) as SubCode , Name as SubReportName from country
GO
