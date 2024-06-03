SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
  
CREATE     PROCEDURE [dbo].[SP_WHTreturnReport]  
(@FromDate datetime,    --   exec  SP_WHTreturnReport '2023-01-01','2023-12-31',4,1  
@ToDate datetime,  
@tenantId int=null,  
@ReportType int=1)    
as    
begin    
declare @WhtReturnReport1 as table    
(slno1 int identity(1,1),    
Typeofpayments1 nvarchar(100),    
NameofPayee1 nvarchar(100),    
paymentdate1 datetime,    
totalamountPaid1 decimal(18,2),    
taxrate1 decimal(18,2),  
taxDue1 decimal(18,2)    
)    
  
declare @WhtReturnReport as table    
(slno int identity(1,1),    
Typeofpayments nvarchar(100),    
NameofPayee nvarchar(100),    
paymentdate datetime,    
totalamountPaid decimal(18,2),    
taxrate decimal(18,2),  
taxDue decimal(18,2),  
ordcode nvarchar(3),  
style int  
)    
  
--insert into @WhtReturnReport (TypeofPayment,NameofthePayee,paymentdate,totalamount,taxrate,taxdue)     
--values ('TypeofPayment','NameofthePayee',GETDATE(),1000,15,100);    
     
  
if @ReportType = 2   
begin  
 insert into @WhtReturnReport1 (Typeofpayments1,totalamountPaid1,taxDue1)     
 select v.Natureofservices,sum(v.LineAmountInclusiveVAT) as totalamount,    
  sum(round(v.LineAmountInclusiveVAT*p.effrate/100,2)) as taxdue      
  from VI_importstandardfiles_Processed v     
  inner join vi_paymentWHTrate p on v.UniqueIdentifier = p.uniqueidentifier    
  where v.TenantId=@tenantId and v.IssueDate >= @fromdate and v.IssueDate <= @todate and v.InvoiceType like 'WHT%'      
  group by v.NatureofServices     
  order by v.NatureofServices    
end  
  
if @ReportType = 1    
begin  
 insert into @WhtReturnReport1 (Typeofpayments1,totalamountPaid1,taxDue1)     
 select v.Natureofservices,sum(v.LineAmountInclusiveVAT) as totalamount,    
  sum(round(v.LineAmountInclusiveVAT*v.vatrate/100,2)) as taxdue      
  from VI_importstandardfiles_Processed v     
  inner join vi_paymentWHTrate p on v.UniqueIdentifier = p.uniqueidentifier    
  where v.TenantId=@tenantId and v.IssueDate >= @fromdate and v.IssueDate <= @todate and v.InvoiceType like 'WHT%'      
  group by v.NatureofServices     
  order by v.NatureofServices    
end  
  
 ---- rearranging the WHT return  
  
 insert into @WhtReturnReport (Typeofpayments,NameofPayee,totalamountPaid,taxDue,ordcode,style )     
 select n.description,'SCH-'+n.Code,v.totalamountpaid1,    
  v.taxdue1,n.code,0      
  from NatureofServices n     
  inner join @whtreturnreport1 v on upper(trim(v.typeofpayments1)) = upper(trim(n.name))    
  where n.code <> '0'  order by n.code  
      
 insert into @WhtReturnReport (Typeofpayments,NameofPayee,paymentdate,totalamountPaid,taxrate,taxDue,ordcode,style)     
 select n.description,' ',null,0,0,0,n.code ,0    
  from natureofservices n  
  where n.code <> '0' and n.code not in (select ordcode from @whtreturnreport) order by n.code  
   
insert into @WhtReturnReport (Typeofpayments,NameofPayee,paymentdate,totalamountPaid,taxrate,taxDue,ordcode,style)     
 select 'Monthly Total',' ',null,sum(totalamountpaid),0,sum(taxdue),'96',0     
  from @WhtReturnReport   
  where ordcode in ('1','2','3','4','5','6','7','8','9','10','11','12','13')  
   
insert into @WhtReturnReport (Typeofpayments,NameofPayee,paymentdate,totalamountPaid,taxrate,taxDue,ordcode,style)     
 values ('Delay Fine at 1% for each 30 days of delay',' ',null,0,0,0,'97',0)   
  
insert into @WhtReturnReport (Typeofpayments,NameofPayee,paymentdate,totalamountPaid,taxrate,taxDue,ordcode,style)     
 values ('Evasion Fine',' ',null,0,0,0,'98',0)   
  
 insert into @WhtReturnReport (Typeofpayments,NameofPayee,paymentdate,totalamountPaid,taxrate,taxDue,ordcode,style)     
 select 'Total tax and fine due (14 + 15 + 16)',' ',null,sum(totalamountpaid),0,sum(taxdue),'99',1      
  from @WhtReturnReport   
  where ordcode in ('96','97','98')  
  
  select row_number() over (order by ordcode) as slno,Typeofpayments,NameofPayee,FORMAT(paymentdate,'dd-MM-yyyy') as paymentdate, format(cast(totalamountPaid as decimal(20,2)),'#,0.00') as totalamountPaid, format(cast(taxrate as decimal(20,2)),'#,0.00') as taxrate, format(cast(taxDue as decimal(20,2)),'#,0.00') as taxDue from @WhtReturnReport order by ordcode     
    
end
GO
