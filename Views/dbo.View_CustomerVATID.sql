SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[View_CustomerVATID] 
as  select c.id,c.tenantid,c.name,c.legalname,c.uniqueidentifier,d.documentnumber
from customers c left outer join customerdocuments d on c.id = d.CustomerID where d.DocumentName ='VAT'
GO
