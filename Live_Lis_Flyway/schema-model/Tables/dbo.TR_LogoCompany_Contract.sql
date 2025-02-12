CREATE TABLE [dbo].[TR_LogoCompany_Contract]
(
[IdLogoCompany_Contract] [int] NOT NULL IDENTITY(1, 1),
[IdLogo_Contract] [int] NOT NULL,
[IdLogo] [int] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_LogoCompany_Contract] ADD CONSTRAINT [PK__TR_LogoC__DFDEA2EFCB152421] PRIMARY KEY CLUSTERED ([IdLogoCompany_Contract])
GO
ALTER TABLE [dbo].[TR_LogoCompany_Contract] ADD CONSTRAINT [FK_TR_LogoCompany_Contract_TB_Logo] FOREIGN KEY ([IdLogo]) REFERENCES [dbo].[TB_Logo] ([IdLogo])
GO
ALTER TABLE [dbo].[TR_LogoCompany_Contract] ADD CONSTRAINT [FK_TR_LogoCompany_Contract_TR_Logo_Contract] FOREIGN KEY ([IdLogo_Contract]) REFERENCES [dbo].[TR_Logo_Contract] ([IdLogo_Contract])
GO
