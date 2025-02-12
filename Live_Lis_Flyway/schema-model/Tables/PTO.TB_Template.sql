CREATE TABLE [PTO].[TB_Template]
(
[IdTemplate] [int] NOT NULL IDENTITY(1, 1),
[IdPathologyProcess] [int] NOT NULL,
[IdBodyPart] [int] NOT NULL,
[TemplateName] [varchar] (80) NULL,
[TemplateDescription] [text] NULL,
[Active] [bit] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_Templa__Visib__5264F507] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_Template] ADD CONSTRAINT [PK_TB_TEMPLATE] PRIMARY KEY CLUSTERED ([IdTemplate])
GO
ALTER TABLE [PTO].[TB_Template] ADD CONSTRAINT [FK_TB_Template_TB_BodyPart] FOREIGN KEY ([IdBodyPart]) REFERENCES [PTO].[TB_BodyPart] ([IdBodyPart])
GO
ALTER TABLE [PTO].[TB_Template] ADD CONSTRAINT [FK_TB_Template_TB_PathologyProcess] FOREIGN KEY ([IdPathologyProcess]) REFERENCES [PTO].[TB_PathologyProcess] ([IdPathologyProcess])
GO
ALTER TABLE [PTO].[TB_Template] ADD CONSTRAINT [FK_TB_Template_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
