CREATE EXTERNAL TABLE [carehis].[TB_AffiliationCategory_Ext]
(
[IdAffiliationCategory] [tinyint] NOT NULL,
[AffiliationCategory] [varchar] (15) NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_AffiliationCategory'
)
GO
