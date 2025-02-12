CREATE TABLE [dbo].[TB_ExamResultImage]
(
[IdExamResultImage] [int] NOT NULL,
[ExamResultImage] [image] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ExamResultImage] ADD CONSTRAINT [PK_TB_ExamResultImage] PRIMARY KEY CLUSTERED ([IdExamResultImage])
GO
