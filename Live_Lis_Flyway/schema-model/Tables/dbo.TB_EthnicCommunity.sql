CREATE TABLE [dbo].[TB_EthnicCommunity]
(
[IdEthnicCommunity] [tinyint] NOT NULL IDENTITY(1, 1),
[EthnicCommunityCode] [varchar] (3) NOT NULL,
[EthnicCommunity] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_EthnicCommunity] ADD CONSTRAINT [PK_TB_EthnicGroup] PRIMARY KEY CLUSTERED ([IdEthnicCommunity])
GO
