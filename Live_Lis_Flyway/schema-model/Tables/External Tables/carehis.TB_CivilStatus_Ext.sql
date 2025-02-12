CREATE EXTERNAL TABLE [carehis].[TB_CivilStatus_Ext]
(
[IdCivilStatus] [tinyint] NOT NULL,
[CivilStatusCode] [varchar] (2) NOT NULL,
[CivilStatus] [varchar] (20) NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_CivilStatus'
)
GO
