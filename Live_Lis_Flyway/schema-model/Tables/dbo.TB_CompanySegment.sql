CREATE TABLE [dbo].[TB_CompanySegment]
(
[IdCompanySegment] [tinyint] NOT NULL IDENTITY(1, 1),
[CompanySegment] [varchar] (65) NULL,
[Segment] [bit] NULL,
[IdMarketGroup] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[TB_CompanySegment] ADD CONSTRAINT [PK_TB_CompanySegment] PRIMARY KEY CLUSTERED ([IdCompanySegment])
GO
ALTER TABLE [dbo].[TB_CompanySegment] ADD CONSTRAINT [FK_TB_CompanySegment1_TB_MarketGroup] FOREIGN KEY ([IdMarketGroup]) REFERENCES [dbo].[TB_MarketGroup] ([IdMarketGroup])
GO
