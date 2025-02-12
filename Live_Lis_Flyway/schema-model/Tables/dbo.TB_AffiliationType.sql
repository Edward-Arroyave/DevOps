CREATE TABLE [dbo].[TB_AffiliationType]
(
[IdAffiliationType] [tinyint] NOT NULL IDENTITY(1, 1),
[AffiliationTypeCode] [varchar] (3) NOT NULL,
[AffiliationType] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AffiliationType] ADD CONSTRAINT [PK_TB_AffiliationType] PRIMARY KEY CLUSTERED ([IdAffiliationType])
GO
