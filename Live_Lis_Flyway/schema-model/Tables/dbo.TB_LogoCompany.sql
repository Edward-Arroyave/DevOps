CREATE TABLE [dbo].[TB_LogoCompany]
(
[IdLogoCompany] [int] NOT NULL IDENTITY(1, 1),
[IdCompany] [int] NOT NULL,
[IdCover] [int] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUser] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_LogoCompany] ADD CONSTRAINT [PK__TB_LogoC__3D249227173A4D2A] PRIMARY KEY CLUSTERED ([IdLogoCompany])
GO
ALTER TABLE [dbo].[TB_LogoCompany] ADD CONSTRAINT [TB_LogoCompany_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_LogoCompany] ADD CONSTRAINT [TB_LogoCompany_TB_Cover] FOREIGN KEY ([IdCover]) REFERENCES [dbo].[TB_Cover] ([IdCover])
GO
ALTER TABLE [dbo].[TB_LogoCompany] ADD CONSTRAINT [TB_LogoCompany_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
