SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[SP_WHTDTTSpecialRate] (@batchno int) --(@uuid uniqueidentifier)   --exec SP_WHTDTTSpecialRate 604
as  
BEGIN  
declare @sql nvarchar(max)  
declare @sql1 nvarchar(max)  
declare @uuid uniqueidentifier  


  
declare temp_uuid CURSOR FOR  
select v.UniqueIdentifier from  VI_importstandardfiles_Processed  v inner join whtdttrates w on upper(v.NatureofServices) = upper(w.servicename)    
where w.status = 1 and v.BatchId=@batchno and v.InvoiceType like 'WHT%'  and left(v.BuyerCountryCode,2)=w.AlphaCode   
and  isnull(AdvanceRcptRefNo,0) <> 13   
and v.UniqueIdentifier not in (select UniqueIdentifier from vi_paymentwhtrate where batchid = @batchno)  
  
open temp_uuid  
fetch next from temp_uuid into @uuid  
--print @uuid  
while @@FETCH_STATUS=0  
     Begin  
  set @sql = (select rulecommand from whtrules r inner join whtdttrates w on r.ruleid = w.ruleid  
        inner join VI_importstandardfiles_Processed   v on upper(v.NatureofServices) = upper(w.servicename)    
        and left(v.buyercountrycode,2) = w.alphacode where v.uniqueidentifier = @uuid)   
        set @sql1 = '(select 1 as specialstatus from vi_importstandardfiles_processed v where v.uniqueidentifier ='''+ CONVERT(varchar(max), @uuid) +''' and ' + @sql+')'  
--  print @sql1  
--  print @sql  
--  print @uuid  
  EXECUTE sp_executesql @sql1  
  
  if @@ROWCOUNT>0  
  begin  
           update VI_importstandardfiles_Processed  set AdvanceRcptRefNo = '13' where UniqueIdentifier = @uuid --  select * from vi_importstandardfiles_processed where batchid = 5  
        end   
  
  fetch next from temp_uuid into @uuid  
  End  
  close temp_uuid  
  deallocate temp_uuid  
  
end  


--select * from WHTRules  where ruleid = 2
--select * from whtdttrates where alphacode = 'NL'
--update whtrules set rulecommand = 'upper(v.VendorConstitution) not like '%PARTNER%' and upper(v.VendorConstitution) <> 'LLP' and v.PerCapitaHoldingForiegnCo >= 10' where ruleid = 2
--select * from ImportBatchData 

--update whtrules set rulecommand = 'upper(v.VendorCostitution) not like ''%PARTNER%'' and upper(v.VendorCostitution) <> ''LLP'' and v.PerCapitaHoldingForiegnCo >= 10' where ruleid = 2
GO
