CREATE TABLE [dbo].[TB_ModerationFee]
(
[IdModerationFee] [int] NOT NULL IDENTITY(1, 1),
[IdAffiliationCategory] [tinyint] NOT NULL,
[Value] [bigint] NOT NULL,
[InitialDate] [datetime] NOT NULL,
[FinalDate] [datetime] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ModerationFee] ADD CONSTRAINT [PK_TB_ModerationFee] PRIMARY KEY CLUSTERED ([IdModerationFee])
GO
ALTER TABLE [dbo].[TB_ModerationFee] ADD CONSTRAINT [FK_TB_ModerationFee_TB_AffiliationCategory] FOREIGN KEY ([IdAffiliationCategory]) REFERENCES [dbo].[TB_AffiliationCategory] ([IdAffiliationCategory])
GO
ALTER TABLE [dbo].[TB_ModerationFee] ADD CONSTRAINT [FK_TB_ModerationFee_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
