CREATE TABLE [dbo].[TB_TariffSchemeType]
(
[IdTariffSchemeType] [int] NOT NULL IDENTITY(1, 1),
[TariffSchemeTypeName] [varchar] (100) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TariffSchemeType] ADD CONSTRAINT [PK_TB_TariffSchemeType] PRIMARY KEY CLUSTERED ([IdTariffSchemeType])
GO
ALTER TABLE [dbo].[TB_TariffSchemeType] ADD CONSTRAINT [FK_TB_TariffSchemeType_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
