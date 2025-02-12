CREATE EXTERNAL TABLE [carehis].[TB_BiologicalSex_Ext]
(
[IdBiologicalSex] [tinyint] NOT NULL,
[BiologicalSexCode] [varchar] (3) NOT NULL,
[BiologicalSex] [varchar] (30) NOT NULL,
[Abbreviation] [varchar] (1) NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_BiologicalSex'
)
GO
