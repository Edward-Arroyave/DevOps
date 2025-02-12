CREATE TABLE [dbo].[TB_TariffScheme]
(
[IdTariffScheme] [int] NOT NULL IDENTITY(1, 1),
[TariffSchemeCode] [varchar] (10) NOT NULL,
[TariffSchemeName] [varchar] (100) NOT NULL,
[IdTariffSchemeType] [int] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TariffScheme] ADD CONSTRAINT [PK_TB_TariffScheme] PRIMARY KEY CLUSTERED ([IdTariffScheme])
GO
ALTER TABLE [dbo].[TB_TariffScheme] ADD CONSTRAINT [FK_TB_TariffScheme_TB_TariffSchemeType] FOREIGN KEY ([IdTariffSchemeType]) REFERENCES [dbo].[TB_TariffSchemeType] ([IdTariffSchemeType])
GO
ALTER TABLE [dbo].[TB_TariffScheme] ADD CONSTRAINT [FK_TB_TariffScheme_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_TariffScheme] ADD CONSTRAINT [FK_TB_TariffScheme_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
