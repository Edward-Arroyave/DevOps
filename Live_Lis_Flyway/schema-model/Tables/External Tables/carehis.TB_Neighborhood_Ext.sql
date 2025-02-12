CREATE EXTERNAL TABLE [carehis].[TB_Neighborhood_Ext]
(
[IdNeighborhood] [smallint] NOT NULL,
[NeighborhoodCode] [varchar] (5) NULL,
[Neighborhood] [varchar] (50) NOT NULL,
[IdLocality] [tinyint] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_Neighborhood'
)
GO
