SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[VI_SP_GetVATDetailedReport]
(@FieldNo nvarchar(7),
@FromDate datetime,     
@ToDate datetime ,
@tenantid int=null)


--exec VI_SP_GetVATDetailedReport 'B1','2023-10-11', '2023-11-30',127
--exec VI_SP_GetVATDetailedReport 'A1.1','2020-06-01', '2023-10-30' ,130
--exec VI_SP_GetVATDetailedReport 'A1','2023-10-01', '2023-10-30' ,127

as  
begin  
declare @VatDetailedReport as table  
(SlNo int, 
BuyerName NVARCHAR(MAX),
Issuedate varchar(40),  
InvoiceNumber INT,  
NetAmount decimal (18,2),  
VatAmount decimal (18,2),
TotalAmount decimal (18,2)
)  
If @FieldNo ='A1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedSales15Detailed @Fromdate,@Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (1,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A1.1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedSales5Detailed @Fromdate,@Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (2,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A1.2'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedSalesGovtDetailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (3,'02-02-2023',0,0,0,0)
--end

--insert into @VatDetailedReport values (4,0,0,0,0,0)
If @FieldNo ='A2'
 begin 
insert into @VatDetailedReport Values(1,' ','0',0,0,0,0)
end 

If @FieldNo ='A3'
 begin 
insert into @VatDetailedReport
exec VI_VATReportZeroRatedSalesDetailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (5,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A4'
 begin 
insert into @VatDetailedReport
exec VI_VATReportExportsDetailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (6,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A5'
 begin 
insert into @VatDetailedReport
exec VI_VATReportExemptedSalesDetailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (7,'02-02-2023',0,0,0,0)
--end






If @FieldNo ='A7'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedPurchases15Detailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (8,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A7.1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedPurchases5Detailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (9,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A8'
 begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoVATPaid15Detailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (10,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A8.1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoVATPaid5Detailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (11,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A9'
 begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoRCM15Detailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (12,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A9.1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoRCM5Detailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (13,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A10'
 begin 
insert into @VatDetailedReport
exec VI_VATReportZeroRatedPurchasesDetailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (14,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='A11'
 begin 
insert into @VatDetailedReport
exec VI_VATReportExemptPurchasesDetailed @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (15,'02-02-2023',0,0,0,0)
--end


If @FieldNo ='B1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedSales15DetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (16,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B1.1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedSales5DetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (16,'02-02-2023',0,0,0,0)
--end



If @FieldNo ='B1.2'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedSalesGovtDetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (16,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B2'
 begin 
insert into @VatDetailedReport Values(1,' ','0',0,0,0,0)
end

If @FieldNo ='B3'
 begin 
insert into @VatDetailedReport
exec VI_VATReportZeroRatedSalesDetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (5,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B4'
 begin 
insert into @VatDetailedReport
exec VI_VATReportExportsDetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (6,'02-02-2023',0,0,0,0)
--end


If @FieldNo ='B5'
 begin 
insert into @VatDetailedReport
exec VI_VATReportExemptedSalesDetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (7,'02-02-2023',0,0,0,0)
--end


If @FieldNo ='B7'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedPurchases15DetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (8,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B7.1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportStandardRatedPurchases5DetailedAdjustment @Fromdate, @Todate,@tenantid
end

If @FieldNo ='B8'
 begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoVATPaid15DetailedAdjustment @Fromdate, @Todate,@tenantid
end 
 
--else 
--begin
--insert into @VatDetailedReport values (9,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B8.1'
begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoVATPaid5DetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (11,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B9'
 begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoRCM15DetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (12,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B9.1'
 begin 
insert into @VatDetailedReport
exec VI_VATReportImportSubjecttoRCM5DetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (13,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B10'
 begin 
insert into @VatDetailedReport
exec VI_VATReportZeroRatedPurchasesDetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (14,'02-02-2023',0,0,0,0)
--end

If @FieldNo ='B11'
 begin 
insert into @VatDetailedReport
exec VI_VATReportExemptPurchasesDetailedAdjustment @Fromdate, @Todate,@tenantid
end 
--else 
--begin
--insert into @VatDetailedReport values (15,'02-02-2023',0,0,0,0)
--end

select SlNo,BuyerName,Issuedate,InvoiceNumber,NetAmount,VatAmount,TotalAmount from @VatDetailedReport
end
GO
