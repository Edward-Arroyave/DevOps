CREATE EXTERNAL TABLE [carehis].[TB_DisabilityCategory_Ext]
(
[IdDisabilityCategory] [int] NOT NULL,
[DisabilityCategoryCode] [varchar] (5) NOT NULL,
[DisbilityCategory] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_DisabilityCategory'
)
GO
