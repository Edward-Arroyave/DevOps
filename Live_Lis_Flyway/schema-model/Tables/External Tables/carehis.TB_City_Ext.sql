CREATE EXTERNAL TABLE [carehis].[TB_City_Ext]
(
[IdCity] [int] NOT NULL,
[CityCode] [varchar] (5) NOT NULL,
[CityName] [varchar] (30) NOT NULL,
[IdDepartment] [int] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_City'
)
GO
