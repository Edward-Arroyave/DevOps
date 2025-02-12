CREATE TABLE [dbo].[TB_ExamTechnique]
(
[IdExamTechnique] [int] NOT NULL IDENTITY(1, 1),
[ExamTechnique] [varchar] (120) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ExamTechnique] ADD CONSTRAINT [PK_TB_ExamTechnique] PRIMARY KEY CLUSTERED ([IdExamTechnique])
GO
ALTER TABLE [dbo].[TB_ExamTechnique] ADD CONSTRAINT [FK_TB_ExamTechnique_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
