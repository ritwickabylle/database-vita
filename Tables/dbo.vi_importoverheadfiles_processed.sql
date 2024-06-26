CREATE TABLE [dbo].[vi_importoverheadfiles_processed]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NULL,
[BatchId] [int] NOT NULL,
[Filename] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssueDate] [datetime2] NULL,
[IssueTime] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceCurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurchaseOrderId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplyDate] [datetime2] NULL,
[SupplyEndDate] [datetime2] NULL,
[BuyerMasterCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerVatCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerContact] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerCountryCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceLineIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemMasterCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UOM] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrossPrice] [decimal] (18, 2) NOT NULL,
[Discount] [decimal] (18, 2) NOT NULL,
[NetPrice] [decimal] (18, 2) NOT NULL,
[Quantity] [decimal] (18, 2) NOT NULL,
[LineNetAmount] [decimal] (18, 2) NOT NULL,
[VatCategoryCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VatRate] [decimal] (18, 2) NOT NULL,
[VatExemptionReasonCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VatExemptionReason] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATLineAmount] [decimal] (18, 2) NOT NULL,
[LineAmountInclusiveVAT] [decimal] (18, 2) NOT NULL,
[Processed] [bit] NOT NULL,
[Error] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingReferenceId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrignalSupplyDate] [datetime2] NULL,
[ReasonForCN] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillOfEntry] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillOfEntryDate] [datetime2] NULL,
[CustomsPaid] [decimal] (18, 2) NOT NULL,
[CustomTax] [decimal] (18, 2) NOT NULL,
[WHTApplicable] [bit] NOT NULL,
[PurchaseNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurchaseCategory] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LedgerHeader] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdvanceRcptAmtAdjusted] [decimal] (18, 2) NULL,
[VatOnAdvanceRcptAmtAdjusted] [decimal] (18, 2) NULL,
[AdvanceRcptRefNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentMeans] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentTerms] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NatureofServices] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Isapportionment] [bit] NOT NULL,
[ExciseTaxPaid] [decimal] (18, 2) NOT NULL,
[OtherChargesPaid] [decimal] (18, 2) NOT NULL,
[TotalTaxableAmount] [decimal] (18, 2) NOT NULL,
[VATDeffered] [bit] NOT NULL,
[PlaceofSupply] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RCMApplicable] [bit] NOT NULL,
[OrgType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[AffiliationStatus] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CapitalInvestedbyForeignCompany] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CapitalInvestmentCurrency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CapitalInvestmentDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExchangeRate] [decimal] (18, 2) NULL,
[PerCapitaHoldingForiegnCo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceInvoiceAmount] [decimal] (18, 2) NULL,
[VendorCostitution] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[effdate] [date] NULL
) ON [PRIMARY]
GO
