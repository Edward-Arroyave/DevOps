CREATE EXTERNAL TABLE [carehis].[TB_Locality_Ext]
(
[IdLocality] [tinyint] NOT NULL,
[LocalityCode] [varchar] (3) NULL,
[Locality] [varchar] (50) NOT NULL,
[IdCity] [int] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_Locality'
)
GO
