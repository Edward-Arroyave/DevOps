CREATE TABLE [PTO].[TB_SpecialPermission]
(
[IdSpecialPermission] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdMenu] [smallint] NOT NULL,
[Validate] [bit] NOT NULL,
[Invalidate] [bit] NOT NULL,
[Macroscopy] [bit] NULL,
[Histotechnics] [bit] NULL,
[Microscopy] [bit] NULL,
[Reports] [bit] NULL,
[PostAnalytical] [bit] NULL,
[GenerateWorkSheet] [bit] NULL,
[Tracking] [bit] NULL,
[Assignment] [bit] NULL,
[Traceability] [bit] NULL,
[Parameterization] [bit] NULL,
[Storage] [bit] NULL,
[Cut_ColorRequest] [bit] NULL
)
GO
ALTER TABLE [PTO].[TB_SpecialPermission] ADD CONSTRAINT [PK_TB_SpecialPermission] PRIMARY KEY CLUSTERED ([IdSpecialPermission])
GO
ALTER TABLE [PTO].[TB_SpecialPermission] ADD CONSTRAINT [FK_TB_SpecialPermission_TB_Menu] FOREIGN KEY ([IdMenu]) REFERENCES [dbo].[TB_Menu] ([IdMenu])
GO
ALTER TABLE [PTO].[TB_SpecialPermission] ADD CONSTRAINT [FK_TB_SpecialPermission_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
