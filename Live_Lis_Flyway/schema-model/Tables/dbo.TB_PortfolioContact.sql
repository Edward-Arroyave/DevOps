CREATE TABLE [dbo].[TB_PortfolioContact]
(
[IdPortfolioContact] [int] NOT NULL IDENTITY(1, 1),
[PortfolioContactName] [varchar] (100) NOT NULL,
[Email] [varchar] (100) NOT NULL,
[TelephoneNumber] [varchar] (20) NOT NULL,
[TelephoneNumber2] [varchar] (20) NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PortfolioContact] ADD CONSTRAINT [PK_TB_PortfolioContact] PRIMARY KEY CLUSTERED ([IdPortfolioContact])
GO
