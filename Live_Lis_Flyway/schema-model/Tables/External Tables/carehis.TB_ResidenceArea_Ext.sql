CREATE EXTERNAL TABLE [carehis].[TB_ResidenceArea_Ext]
(
[IdResidenceArea] [tinyint] NOT NULL,
[ResidenceAreaCode] [varchar] (3) NOT NULL,
[ResidenceArea] [varchar] (20) NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_ResidenceArea'
)
GO
