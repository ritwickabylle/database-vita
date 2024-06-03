SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[CheckIfcustomervatExists]
(
@vat nvarchar(200) ,
@checkInAllCustomer char(1) = 1
)
as
begin
select count(*) as count from CustomerDocuments with(nolock) where DocumentTypeCode='VAT' and DocumentNumber=@vat
end
GO
