SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[GetOverrideReport]    --exec GetOverrideReport 39,'2023-06-01','2023-06-30',OVRSI001
(  
@tenantid int=null,  
@fromdate datetime,  
@todate datetime,  
@code nvarchar(max)  
)  
as  
begin  
  
/*  
Codes for types of file upload:  
  
OVRSAL001-Sales Invoice  
OVRSCN002-Sales Credit Note  
OVRSDN003-Sales Debit Note  
OVRPUR004-Purchase Entryv  
OVRPDN005-Purchase Debit Note  
OVRPCN006-Purchase Credit Note  
OVRTEN007-Tenant File  
OVRCUS008-Customer File  
OVRVEN009-Vendor  
*/  
  
if @code= 'OVRSI001'  
begin  
       --insert into logs(json,batchid,date) values ('OVRSAL001',@tenantid,@todate)  
    select distinct  i.InvoiceNumber as Number ,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.BuyerName as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier) 
	as ErrorMessage,format(t.creationtime,'dd-MM-yyyy') as OverrideDate,'Transaction Override' as  NatureofOverride  
    from Transactionoverride t inner join ImportBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and i.InvoiceType like 'Sales%'  
end  
  
  
if @code= 'OVRSCN002'  
begin  
    select distinct  i.InvoiceNumber as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.BuyerName as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy') as OverrideDate
,'Transaction Override' as  NatureofOverride  
    from Transactionoverride t inner join ImportBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and i.InvoiceType like 'Credit%'  
end  
  
if @code= 'OVRSDN003'  
begin  
    select distinct  i.InvoiceNumber as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.BuyerName as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy') as OverrideDate
,'Transaction Override' as  NatureofOverride  
    from Transactionoverride t inner join ImportBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and i.InvoiceType like 'Debit%'  
end  
  
if @code= 'OVRPUR004'  
begin  
    select distinct  i.InvoiceNumber as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.BuyerName as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy') as OverrideDate
,'Transaction Override' as  NatureofOverride  
    from Transactionoverride t inner join ImportBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and i.InvoiceType like 'Purchase%'  
end  
if @code= 'OVRPDN005'  
begin  
    select distinct  i.InvoiceNumber as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.BuyerName as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy') as OverrideDate
,'Transaction Override' as  NatureofOverride  
    from Transactionoverride t inner join ImportBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and i.InvoiceType like 'DN%'  
end  
  
if @code= 'OVRPCN006'  
begin  
    select distinct  i.InvoiceNumber as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.BuyerName as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy') as OverrideDate
,'Transaction Override' as  NatureofOverride  
    from Transactionoverride t inner join ImportBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and i.InvoiceType like 'CN%'  
end  
------------------------  
if @code= 'OVRTEN007'  
begin  
       insert into logs(json,batchid,date) values (@code,123,getdate())  
    select ROW_NUMBER() over (order by t.uniqueidentifier) as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.Name as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy'
) as OverrideDate,'Master Override' as  NatureofOverride  
    from masteroverride t inner join ImportMasterBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and upper(i.MasterType) like 'TENANT%'  
end  
  
if @code= 'OVRCUS008'  
begin  
    select ROW_NUMBER() over (order by t.uniqueidentifier) as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.Name as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy'
) as OverrideDate,'Master Override' as  NatureofOverride  
    from masteroverride t inner join ImportMasterBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and upper(i.MasterType) like 'CUSTOMER%'  
end  
  
if @code= 'OVRVEN009'  
begin  
    select ROW_NUMBER() over (order by t.uniqueidentifier) as Number,t.batchid as BatchNo,format(t.creationtime,'dd-MM-yyyy') as Date,i.Name as Name,dbo.get_OverrideTransactionMessage(t.uniqueIdentifier)  as ErrorMessage,format(t.creationtime,'dd-MM-yyyy'
) as OverrideDate,'Master Override' as  NatureofOverride  
    from masteroverride t inner join ImportMasterBatchData i on t.uniqueidentifier=i.UniqueIdentifier   
    where t.tenantid=@tenantid and FORMAT(t.creationtime ,'yyyy-MM-dd')>=@fromdate and FORMAT(t.creationtime ,'yyyy-MM-dd')<=@todate and upper(i.MasterType) like 'VENDOR%'  
end  
end
GO
