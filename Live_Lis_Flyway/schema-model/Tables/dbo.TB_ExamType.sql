CREATE TABLE [dbo].[TB_ExamType]
(
[IdExamType] [tinyint] NOT NULL IDENTITY(1, 1),
[ExamType] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ExamType] ADD CONSTRAINT [PK_TB_Exam] PRIMARY KEY CLUSTERED ([IdExamType])
GO
