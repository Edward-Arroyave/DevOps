CREATE EXTERNAL TABLE [carehis].[TB_AffiliationType_Ext]
(
[IdAffiliationType] [tinyint] NOT NULL,
[AffiliationTypeCode] [varchar] (5) NOT NULL,
[AffiliationType] [varchar] (50) NOT NULL,
[Active] [bit] NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_AffiliationType'
)
GO
