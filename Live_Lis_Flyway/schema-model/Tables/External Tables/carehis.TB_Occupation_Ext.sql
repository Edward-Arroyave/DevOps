CREATE EXTERNAL TABLE [carehis].[TB_Occupation_Ext]
(
[IdOccupation] [int] NOT NULL,
[OccupationCode] [varchar] (5) NOT NULL,
[Occupation] [varchar] (150) NOT NULL,
[ParentIdOccupation] [int] NULL,
[Level] [int] NULL,
[Active] [bit] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_Occupation'
)
GO
