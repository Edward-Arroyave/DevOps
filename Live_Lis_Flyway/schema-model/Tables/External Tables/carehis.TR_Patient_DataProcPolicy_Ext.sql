CREATE EXTERNAL TABLE [carehis].[TR_Patient_DataProcPolicy_Ext]
(
[IdPatientDataProcPolicy] [int] NOT NULL,
[IdPatient] [int] NOT NULL,
[AcceptDataProcessingPolicy] [bit] NULL,
[DataProcessingPolicy] [varchar] (150) NULL,
[DataProcessingPolicySignature] [varchar] (150) NULL,
[ExpirationDataProcessingPolicy] [date] NULL,
[DataBaseSource] [int] NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TR_Patient_DataProcPolicy'
)
GO
