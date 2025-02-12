CREATE TABLE [dbo].[TR_Logo_Contract]
(
[IdLogo_Contract] [int] NOT NULL IDENTITY(1, 1),
[IdLogoCompany] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Logo_Contract] ADD CONSTRAINT [PK__TR_Logo___1272A23C4C9B2E41] PRIMARY KEY CLUSTERED ([IdLogo_Contract])
GO
ALTER TABLE [dbo].[TR_Logo_Contract] ADD CONSTRAINT [FK_TR_Logo_Contract_TB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TR_Logo_Contract] ADD CONSTRAINT [FK_TR_Logo_Contract_TB_LogoCompany] FOREIGN KEY ([IdLogoCompany]) REFERENCES [dbo].[TB_LogoCompany] ([IdLogoCompany])
GO
