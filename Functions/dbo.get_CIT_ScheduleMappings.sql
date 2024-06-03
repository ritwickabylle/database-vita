SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    FUNCTION [dbo].[get_CIT_ScheduleMappings] (@Schedule_Type nvarchar(100))  --select dbo.get_CIT_ScheduleMappings('CIT_TrailBalance')
RETURNS varchar(max) AS  
BEGIN  
    DECLARE @schedule_Json VARCHAR(MAX) 
	if(@Schedule_Type like 'CIT_Schedule2')
	begin
		set @schedule_Json= N'[
  {
    "uploadedFields": [
      "ID Type"
    ],
    "fieldForMapping": "IDType",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "IDType"
    ],
    "sequenceNumber": 1,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "ID Number"
    ],
    "fieldForMapping": "IDNumber",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "IDNumber"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Contracting Party"
    ],
    "fieldForMapping": "ContractingParty",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "ContractingParty"
    ],
    "sequenceNumber": 3,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Contract Date"
    ],
    "fieldForMapping": "ContractDate",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "ContractDate"
    ],
    "sequenceNumber": 4,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Original Value"
    ],
    "fieldForMapping": "OriginalValue",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "OriginalValue"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Amendments to original value"
    ],
    "fieldForMapping": "AmendmentsToOriginalValue",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "AmendmentsToOriginalValue"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Contract value after amendments"
    ],
    "fieldForMapping": "ContractValueAfterAmendments",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "ContractValueAfterAmendments"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Total actual costs incurred to date"
    ],
    "fieldForMapping": "TotalActualCostsIncurred",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "TotalActualCostsIncurred"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Contract estimated cost"
    ],
    "fieldForMapping": "ContractEstimatedCost",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "ContractEstimatedCost"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Completion percentage"
    ],
    "fieldForMapping": "CompletionPercentage",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "CompletionPercentage"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Revenues according to the % of completion to date"
    ],
    "fieldForMapping": "RevenuesAccordingToCompletionToDate",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "RevenuesAccordingToCompletionToDate"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Revenues according to the % of completion in prior years"
    ],
    "fieldForMapping": "RevenuesAccordingToCompletionPriorYear",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "RevenuesAccordingToCompletionPriorYear"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Revenues according to the % of completion during the current year"
    ],
    "fieldForMapping": "RevenuesAccordingToCompletionDuringCurrentYear",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "RevenuesAccordingToCompletionDuringCurrentYear"
    ],
    "sequenceNumber": 5,
    "isCustomerMapped": true
  }
]'
	end
	else if(@Schedule_Type like 'CIT_Schedule2_1')
	begin
	set @schedule_Json=N'[
  {
    "uploadedFields": [
      "Description"
    ],
    "fieldForMapping": "Description",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "Description"
    ],
    "sequenceNumber": 1,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Amount"
    ],
    "fieldForMapping": "Amount",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "Amount"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  }
]'
	end
		else if(@Schedule_Type like 'CIT_Schedule3')
	begin
	set @schedule_Json=N'[
  {
    "uploadedFields": [
      "ID Type"
    ],
    "fieldForMapping": "IDType",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "IDType"
    ],
    "sequenceNumber": 1,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "ID Number"
    ],
    "fieldForMapping": "IDNumber",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "IDNumber"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Contractor Name"
    ],
    "fieldForMapping": "ContractorName",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "ContractorName"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Country"
    ],
    "fieldForMapping": "Country",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "Country"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Value of works executed in SAR"
    ],
    "fieldForMapping": "Valueofworksexecuted",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "Valueofworksexecuted"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  }
]'
	end

	else if(@Schedule_Type like 'CIT_TrailBalance')
	begin
	set @schedule_Json=N'[
  {
    "uploadedFields": [
      "GL Code"
    ],
    "fieldForMapping": "GLCode",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "GLCode"
    ],
    "sequenceNumber": 1,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "GL Name"
    ],
    "fieldForMapping": "GLName",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "GLName"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "GL Group"
    ],
    "fieldForMapping": "GLGroup",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "GLGroup"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "OP BAL"
    ],
    "fieldForMapping": "OPBalance",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "OPBalance"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Op Bal Type"
    ],
    "fieldForMapping": "OpBalanceType",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "OpBalanceType"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "DEBIT"
    ],
    "fieldForMapping": "Debit",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "Debit"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "CREDIT"
    ],
    "fieldForMapping": "Credit",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "Credit"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "CL BAL"
    ],
    "fieldForMapping": "CLBalance",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "CLBalance"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "CL Bal Type"
    ],
    "fieldForMapping": "CLBalanceType",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "CLBalanceType"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Tax Code"
    ],
    "fieldForMapping": "TaxCode",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "TaxCode"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "ISBS"
    ],
    "fieldForMapping": "ISBS",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "ISBS"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  }
]'
	end

	else if(@Schedule_Type like 'CIT_Schedule4')
	begin
	set @schedule_Json=N'[
  {
    "uploadedFields": [
      "ID Type"
    ],
    "fieldForMapping": "IDType",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "IDType"
    ],
    "sequenceNumber": 1,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "ID Number"
    ],
    "fieldForMapping": "IDNumber",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "IDNumber"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Beneficiary Name"
    ],
    "fieldForMapping": "BeneficiaryName",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "BeneficiaryName"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Local / Foreign"
    ],
    "fieldForMapping": "LocalorForeign",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "LocalorForeign"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Country"
    ],
    "fieldForMapping": "Country",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "Country"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Beginning of the year Balance"
    ],
    "fieldForMapping": "BeginningoftheyearBalance",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "BeginningoftheyearBalance"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Charged to the Accounts"
    ],
    "fieldForMapping": "ChargetotheAccounts",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "ChargetotheAccounts"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "Paid Amount"
    ],
    "fieldForMapping": "PaidAmount",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "PaidAmount"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  },
  {
    "uploadedFields": [
      "End of the year Balance"
    ],
    "fieldForMapping": "EndoftheyearBalance",
    "defaultValue": "",
    "transform": [],
    "dataType": "nvarchar",
    "combination": [
      "EndoftheyearBalance"
    ],
    "sequenceNumber": 2,
    "isCustomerMapped": true
  }
]'
	end

 
RETURN @schedule_Json  
END;
GO
