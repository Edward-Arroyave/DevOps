CREATE TABLE [dbo].[TB_AffiliationCategory]
(
[IdAffiliationCategory] [tinyint] NOT NULL IDENTITY(1, 1),
[AffiliationCategory] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AffiliationCategory] ADD CONSTRAINT [PK_TB_AffiliationCategory] PRIMARY KEY CLUSTERED ([IdAffiliationCategory])
GO
