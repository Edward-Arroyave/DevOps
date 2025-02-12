CREATE TABLE [dbo].[TB_MarketGroup]
(
[IdMarketGroup] [tinyint] NOT NULL IDENTITY(1, 1),
[MarketGroup] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_MarketGroup] ADD CONSTRAINT [PK_TB_MarketGroup] PRIMARY KEY CLUSTERED ([IdMarketGroup])
GO
