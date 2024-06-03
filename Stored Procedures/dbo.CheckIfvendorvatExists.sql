SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 create    procedure [dbo].[CheckIfvendorvatExists]
(
@vat nvarchar(200) ,
@checkInAllVendor char(1) = 1
)
as
begin
select count(*) as count from VendorDocuments with(nolock) where DocumentTypeCode='VAT' and DocumentNumber=@vat
end
GO
