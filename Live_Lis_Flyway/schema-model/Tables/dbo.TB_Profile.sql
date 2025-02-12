CREATE TABLE [dbo].[TB_Profile]
(
[IdProfile] [tinyint] NOT NULL IDENTITY(1, 1),
[ProfileName] [varchar] (15) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Profile] ADD CONSTRAINT [PK_Tb_Profile] PRIMARY KEY CLUSTERED ([IdProfile])
GO
