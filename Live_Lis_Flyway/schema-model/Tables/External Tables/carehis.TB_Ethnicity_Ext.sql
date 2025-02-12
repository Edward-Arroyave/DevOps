CREATE EXTERNAL TABLE [carehis].[TB_Ethnicity_Ext]
(
[IdEthnicity] [tinyint] NOT NULL,
[EthnicityCode] [varchar] (5) NOT NULL,
[Ethnicity] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_Ethnicity'
)
GO
