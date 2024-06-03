SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create    FUNCTION [dbo].[get_scheduleMappings] (@Schedule_Type nvarchar(100))  
RETURNS varchar(max) AS  
BEGIN  
    DECLARE @schedule_Json VARCHAR(MAX) 
	if(@Schedule_Type like 'CIT_Schedule2')
	begin
		set @schedule_Json= '[
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

 
RETURN @schedule_Json  
END;
GO
