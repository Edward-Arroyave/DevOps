CREATE TABLE [dbo].[TB_QuoteValidity]
(
[IdQuoteValidity] [tinyint] NOT NULL IDENTITY(1, 1),
[QuoteValidity] [varchar] (7) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_QuoteValidity] ADD CONSTRAINT [PK_TB_QuoteValidity] PRIMARY KEY CLUSTERED ([IdQuoteValidity])
GO
