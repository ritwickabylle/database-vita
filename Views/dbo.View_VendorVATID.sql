SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[View_VendorVATID] 
as  select c.id,c.tenantid,c.name,c.legalname,c.uniqueidentifier,d.documentnumber
from Vendors c left outer join VendorDocuments d on c.id = d.VendorID where d.DocumentName ='VAT'
GO
