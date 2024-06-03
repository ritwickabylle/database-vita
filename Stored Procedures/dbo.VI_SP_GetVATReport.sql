SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[VI_SP_GetVATReport]
(@FromDate datetime,   
@ToDate datetime)    
														--exec VI_SP_GetVATReport '2022-09-01', '2022-09-30'
as
begin
declare @VatReport as table
(id int,
vatDescription varchar(100),
Amount decimal (18,2),
AdjustmentAmount decimal (18,2),
VatAmount decimal (18,2)
)


--insert into @VatReport values (1,'1.Standard Rated Sales 15%',0,0,0);

insert into @VatReport--(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportStandardRatedSales15 @Fromdate, @Todate 
 
 

----insert into @VatReport values (2,'1.1 Standard Rated Sales 5%',0,0,0)

insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportStandardRatedSales5 @Fromdate, @Todate 



----insert into @VatReport values (3,'1.2 Government supplies sales subject to VAT Standard rate (15%)',0,0,0);

insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportStandardRatedSalesGovt @Fromdate, @Todate 


insert into @VatReport values (4,'2. Sales on which the government bears the VAT',0,0,0)

--insert into @VatReport values (5,'3. Zero rated domestic sales',0,0,0)

insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportZeroRatedSales @Fromdate, @Todate 

--insert into @VatReport values (6,'4. Export',0,0,0)
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportExports @fromdate, @todate

--insert into @VatReport values (7,'5. Exempt Sales',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportExemptedSales @fromdate, @todate


--insert into @VatReport values (8,'6. Total Sales',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
select 8,'6. Total Sales',sum(amount),sum(adjustmentamount),sum(vatamount) from @VatReport where id <=7

--insert into @VatReport values (9,'7. Standard Rated Domestic Purchase15%',0,0,0)
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportStandardRatedPurchases15 @fromdate,@todate

--insert into @VatReport values (10,'7.1 Standard Rated Domestic Purchase 5%',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportStandardRatedPurchases5 @fromdate,@todate

--insert into @VatReport values (11,'8. Imports subject to VAT paid at customs 15%',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportImportSubjecttoVATPaid15 @fromdate,@todate

--insert into @VatReport values (12,'8.1 Imports subject to VAT paid at customs 5%',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportImportSubjecttoVATPaid5 @fromdate,@todate

--insert into @VatReport values (13,'9. Imports subject to VAT accounted for through reverse charge mechanism 15%',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportImportSubjecttoRCM15 @fromdate,@todate

--insert into @VatReport values (14,'9.1 Imports subject to VAT accounted for through reverse charge mechanism 5%',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportImportSubjecttoRCM5 @fromdate,@todate

--insert into @VatReport values (15,'10. Zero rated purchases',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportZeroRatedPurchases @fromdate,@todate

--insert into @VatReport values (16,'11. Exempt purchases',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportExemptPurchases @fromdate,@todate

--insert into @VatReport values (17,'12. Total purchases',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
select 17,'12. Total purchases',sum(amount),sum(adjustmentamount),sum(vatamount) from @VatReport where id >= 9 and id <=16

--insert into @VatReport values (18,'13. Total VAT due for current period',0,0,0);
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
select 18,'13. Total VAT due for current period',
  sum(case when id = 8 then amount
  when id = 17 then 0-amount end),
  sum(case when id = 8 then adjustmentamount
  when id = 17 then 0-AdjustmentAmount end),
  sum(case when id = 8 then vatamount
  when id = 17 then 0-vatamount end) from @VatReport where id in (8,17)

insert into @VatReport values (19,'14. Corrections from previous period (betweenSAR 5,000±)',0,0,0);
insert into @VatReport values (20,'15. VAT credit carried forward from previous period(s)',0,0,0);

--insert into @VatReport values (21,'16. Apportioned Overhead Adjustments',0,0,0);

insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
exec VI_VATReportApportionedOverhead @fromdate,@todate

--insert into @VatReport values (22,'17. Net VAT due (or claim)',0,0,0); 
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount) 
select 22,'17. Net VAT due (or claim)',
  sum(case when id in (8,21) then amount
  when id = 17 then 0-amount end),
  sum(case when id in (8,21) then adjustmentamount
  when id = 17 then 0-AdjustmentAmount end),
  sum(case when id in (8,21) then vatamount
  when id = 17 then 0-vatamount end) from @VatReport where id in (8,17,21)
  

  select vatDescription,amount,AdjustmentAmount,VatAmount from @VatReport

end
GO
