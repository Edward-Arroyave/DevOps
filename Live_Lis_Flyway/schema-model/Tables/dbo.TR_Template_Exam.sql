CREATE TABLE [dbo].[TR_Template_Exam]
(
[IdTemplateExam] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[IdTemplate] [int] NULL,
[TemplateStartDate] [datetime] NULL,
[TemplateEndDate] [datetime] NULL,
[iduseraction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Template_Exam] ADD CONSTRAINT [PK__TR_Templ__7F350E387B544A17] PRIMARY KEY CLUSTERED ([IdTemplateExam])
GO
ALTER TABLE [dbo].[TR_Template_Exam] ADD CONSTRAINT [FK_TR_Template_Exam_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Template_Exam] ADD CONSTRAINT [FK_TR_Template_Exam_TB_Template] FOREIGN KEY ([IdTemplate]) REFERENCES [dbo].[TB_Template] ([IdTemplate])
GO
ALTER TABLE [dbo].[TR_Template_Exam] ADD CONSTRAINT [FK_TR_Template_Exam_TB_User] FOREIGN KEY ([iduseraction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
