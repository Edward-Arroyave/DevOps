CREATE EXTERNAL TABLE [carehis].[TB_IdentificationType_Ext]
(
[IdIdentificationType] [tinyint] NOT NULL,
[IdentificationTypeCode] [varchar] (4) NULL,
[IdentificationTypeDesc] [varchar] (35) NOT NULL,
[IdentificationTypeCode_EB] [varchar] (2) NULL,
[Patient] [bit] NOT NULL,
[ElectronicBilling] [bit] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_IdentificationType'
)
GO
