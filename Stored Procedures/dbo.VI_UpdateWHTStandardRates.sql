SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_UpdateWHTStandardRates]   --- exec VI_UpdateWHTStandardRates 7940          
  
(          
@batchno numeric          
)          
as          
begin          
declare @whtrate decimal(5,2)          
    
delete from vi_paymentWHTrate where batchid = @batchno and rateslno in (10,11,12,13,110,111,210,211,310,311)          
update vi_importstandardfiles_processed set AdvanceRcptRefNo =0 where batchid = @batchno    
  
  
--exec SP_WHTDTTSpecialRate @batchno  
    
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName)           
select v.UniqueIdentifier,w.specialRates ,@batchno,13,w.servicename from VI_importstandardfiles_Processed v inner join whtdttrates w   
on upper(v.NatureofServices) = upper(w.servicename)      
--inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.status = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'  and left(v.BuyerCountryCode,2)=w.AlphaCode and      
AdvanceRcptRefNo = 13 and v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
   
--- DTT Rates      
      
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno in (10,11,12,13)          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName)           
select v.UniqueIdentifier,w.DTTRates ,@batchno,12,w.servicename from VI_importstandardfiles_Processed v inner join whtdttrates w   
on upper(v.NatureofServices) = upper(w.servicename)   
--left outer vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.status = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'    
--and p.rateslno not in (13)   
and left(v.BuyerCountryCode,2)=w.AlphaCode and      
v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
          
-- rates update from whtsubrates  
--------------------------------------------------------------------------------------------------------------  
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 211          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)       
select v.UniqueIdentifier,w.AffiliationRate ,@batchno,211,w.servicename,w.standardrate as lawrate  
from VI_importstandardfiles_Processed v   
inner join mst_whtSubrates w on   
upper(v.NatureofServices) = upper(w.servicename)  --inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'  and   
trim(AffiliationStatus) ='Affiliate' and upper(trim(PlaceofSupply)) = 'INSIDE COUNTRY'  and   -- p.rateslno not in (12,13) and      
v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
    
--------------------------------------------------------------------------------------------------------------------  
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 210          
          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)           
select v.UniqueIdentifier,w.standardrate,@batchno,210,w.servicename,w.standardrate as lawrate   
from VI_importstandardfiles_Processed v inner join mst_WHTSubrates w   
on upper(v.NatureofServices) = upper(w.servicename)-- inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%' and   
trim(AffiliationStatus) ='Non-affiliate' and upper(trim(PlaceofSupply)) = 'INSIDE COUNTRY' and  -- p.rateslno not in (11,12,13) and      
v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
          
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 311          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)       
select v.UniqueIdentifier,w.AffiliationRate ,@batchno,311,w.servicename,w.AffiliationRate_OOK as lawrate   
from VI_importstandardfiles_Processed v inner join mst_whtSubrates w on   
upper(v.NatureofServices) = upper(w.servicename)  --inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'  and   
trim(AffiliationStatus) ='Affiliate' and  upper(trim(PlaceofSupply)) = 'OUTSIDE COUNTRY'  -- p.rateslno not in (12,13) and      
and v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
          
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 310          
          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)           
select v.UniqueIdentifier,w.standardrate,@batchno,310,w.servicename,w.standardrate_ook as lawrate   
from VI_importstandardfiles_Processed v inner join mst_whtsubrates w on   
upper(v.NatureofServices) = upper(w.servicename)-- inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%' and   
trim(AffiliationStatus) ='Non-affiliate' and upper(trim(PlaceofSupply)) = 'OUTSIDE COUNTRY' and  -- p.rateslno not in (11,12,13) and      
v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
  
--- final rates updates          
 ------------------------------------------------------------------------------------------------------------------------        
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 11          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)       
select v.UniqueIdentifier,w.AffiliationRate ,@batchno,11,w.servicename,w.standardrate as lawrate   
from VI_importstandardfiles_Processed v inner join mst_whtrates w on   
upper(v.NatureofServices) = upper(w.servicename)  --inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'    
and trim(AffiliationStatus) ='Affiliate' and upper(trim(PlaceofSupply)) = 'INSIDE COUNTRY'  and   -- p.rateslno not in (12,13) and      
v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
    
    
-------------------------------------------------------------------------------------------------------------------------------  
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 10          
          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)           
select v.UniqueIdentifier,w.standardrate,@batchno,10,w.servicename,w.standardrate as lawrate   
from VI_importstandardfiles_Processed v inner join mst_whtrates w on   
upper(v.NatureofServices) = upper(w.servicename)-- inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'   
and trim(AffiliationStatus) ='Non-affiliate' and upper(trim(PlaceofSupply)) = 'INSIDE COUNTRY' and  -- p.rateslno not in (11,12,13) and      
v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
          
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 111          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)       
select v.UniqueIdentifier,w.AffiliationRate ,@batchno,111,w.servicename,w.standardrate_ook as lawrate  
from VI_importstandardfiles_Processed v inner join mst_whtrates w on   
upper(v.NatureofServices) = upper(w.servicename)  --inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'    
and trim(AffiliationStatus) ='Affiliate' and  upper(trim(PlaceofSupply)) = 'OUTSIDE COUNTRY'  -- p.rateslno not in (12,13) and      
and v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
          
--delete from vi_paymentWHTrate where batchid = @batchno and rateslno = 10          
          
insert into vi_PaymentWHTRate(uniqueidentifier,standardrate,batchid,rateslno,ServiceName,lawrate)           
select v.UniqueIdentifier,w.standardrate,@batchno,110,w.servicename,w.standardrate_ook as lawrate   
from VI_importstandardfiles_Processed v inner join mst_whtrates w on upper(v.NatureofServices) = upper(w.servicename)-- inner join   vi_PaymentWHTRate p on p.Batchid=v.BatchId      
where w.isActive = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%' and  
trim(AffiliationStatus) ='Non-affiliate' and upper(trim(PlaceofSupply)) = 'OUTSIDE COUNTRY' and  -- p.rateslno not in (11,12,13) and      
v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)          
  
----select * from mst_whtsubrates  
----select * from VI_PaymentWHTRate where batchid = 5774  
  
  
update vi_PaymentWHTRate set lawrate = (select isnull(standardrate,0) from mst_whtrates where mst_whtrates.servicename =  vi_PaymentWHTRate.ServiceName)   
where batchid = @batchno and rateslno in (12,13)  
  
--update vi_paymentwhtrate set effrate = case when lawrate < isnull(standardrate,0) then isnull(lawrate,0) else isnull(standardrate,0) end   
--where batchid= @batchno and rateslno in (12,13)  
  
update vi_paymentwhtrate set effrate = lawrate where batchid= @batchno and rateslno in (12,13)  
  
update vi_paymentwhtrate set effrate = lawrate where batchid= @batchno and rateslno in (10,11,111,110,210,310,311)  
   
--------------------------------------------------------------------------------------------------------  
update VI_PaymentWHTRate set EffRate=StandardRate where batchid= @batchno and rateslno in(211)  
---------------------------------------------------------------------------------------------------------  
  
   
end          
  
-- update the lawrate into vi_paymentwhtrate  
  
  
--select * from mst_whtrates  
  
--select * from vi_paymentwhtrate  
  
--select * from vi_paymentwhtrate order by batchid desc  
  
--alter table vi_paymentwhtrate add LawRate numeric(5,2), EffRate numeric(5,2),ServiceName nvarchar(max)  
  
--alter table vi_paymentwhtrate add ServiceName nvarchar(max)  
      
--select AffiliationStatus,uniqueidentifier,BuyerName,TotalTaxableAmount ,LineAmountInclusiveVAT  from VI_importstandardfiles_Processed where BatchId=263719 and  UniqueIdentifier ='F4ACDFAF-D5CA-4D8E-99BF-7DF964F71DAC' and trim(buyername) = 'OLIVER MARKET
  
    
--ING LTD' ItemName='Technical Consultancy'      
--update VI_importstandardfiles_Processed set AffiliationStatus='Affiliate' where UniqueIdentifier ='F4ACDFAF-D5CA-4D8E-99BF-7DF964F71DAC' BuyerName='By Niggi LLC' and BatchId=263719      
      
      
--select *  from VI_importstandardfiles_Processed where BatchId=263719       
      
--select * from vi_paymentwhtrate where UniqueIdentifier ='F4ACDFAF-D5CA-4D8E-99BF-7DF964F71DAC'      
      
--select * from vi_paymentwhtrate where batchid = 5774 
GO
