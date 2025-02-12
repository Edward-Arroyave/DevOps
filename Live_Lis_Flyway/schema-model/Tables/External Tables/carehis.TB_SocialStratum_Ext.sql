CREATE EXTERNAL TABLE [carehis].[TB_SocialStratum_Ext]
(
[IdSocialStratum] [tinyint] NOT NULL,
[SocialStratum] [varchar] (10) NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_SocialStratum'
)
GO
