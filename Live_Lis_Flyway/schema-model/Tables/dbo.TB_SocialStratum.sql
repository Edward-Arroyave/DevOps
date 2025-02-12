CREATE TABLE [dbo].[TB_SocialStratum]
(
[IdSocialStratum] [tinyint] NOT NULL IDENTITY(1, 1),
[SocialStratum] [varchar] (10) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_SocialStratum] ADD CONSTRAINT [PK_TB_SocialStratum] PRIMARY KEY CLUSTERED ([IdSocialStratum])
GO
