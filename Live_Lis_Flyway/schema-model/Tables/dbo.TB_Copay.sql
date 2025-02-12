CREATE TABLE [dbo].[TB_Copay]
(
[IdCopay] [int] NOT NULL IDENTITY(1, 1),
[Rank] [varchar] (100) NOT NULL,
[IdAffiliationCategory] [tinyint] NOT NULL,
[Percentage] [decimal] (4, 2) NOT NULL,
[MaximumValue] [bigint] NOT NULL,
[MinimumValue] [bigint] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Copay] ADD CONSTRAINT [PK_TB_Copay] PRIMARY KEY CLUSTERED ([IdCopay])
GO
ALTER TABLE [dbo].[TB_Copay] ADD CONSTRAINT [FK_TB_Copay_TB_AffiliationCategory] FOREIGN KEY ([IdAffiliationCategory]) REFERENCES [dbo].[TB_AffiliationCategory] ([IdAffiliationCategory])
GO
ALTER TABLE [dbo].[TB_Copay] ADD CONSTRAINT [FK_TB_Copay_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
