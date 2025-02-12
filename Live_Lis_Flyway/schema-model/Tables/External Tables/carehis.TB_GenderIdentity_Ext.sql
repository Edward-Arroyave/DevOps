CREATE EXTERNAL TABLE [carehis].[TB_GenderIdentity_Ext]
(
[IdGenderIdentity] [tinyint] NOT NULL,
[GenderIdentityCode] [varchar] (3) NOT NULL,
[GenderIdentity] [varchar] (15) NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_GenderIdentity'
)
GO
