CREATE EXTERNAL TABLE [carehis].[TB_Schooling_Ext]
(
[IdSchooling] [tinyint] NOT NULL,
[Schooling] [varchar] (17) NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_Schooling'
)
GO
