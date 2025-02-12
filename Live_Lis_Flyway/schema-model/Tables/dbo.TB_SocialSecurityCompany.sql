CREATE TABLE [dbo].[TB_SocialSecurityCompany]
(
[IdSocialSecurityCompany] [int] NOT NULL IDENTITY(1, 1),
[SocialSecurityCompanyCode] [varchar] (6) NOT NULL,
[SocialSecurityCompanyName] [varchar] (100) NOT NULL,
[Subsystem] [varchar] (4) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_SocialSecurityCompany] ADD CONSTRAINT [PK_TB_SocialSecurityCompany] PRIMARY KEY CLUSTERED ([IdSocialSecurityCompany])
GO
