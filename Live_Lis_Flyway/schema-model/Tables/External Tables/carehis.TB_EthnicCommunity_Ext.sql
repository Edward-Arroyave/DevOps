CREATE EXTERNAL TABLE [carehis].[TB_EthnicCommunity_Ext]
(
[IdEthnicCommunity] [tinyint] NOT NULL,
[EthnicCommunityCode] [varchar] (3) NOT NULL,
[EthnicCommunity] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_EthnicCommunity'
)
GO
