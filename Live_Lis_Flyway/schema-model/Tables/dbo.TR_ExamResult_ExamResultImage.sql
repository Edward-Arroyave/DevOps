CREATE TABLE [dbo].[TR_ExamResult_ExamResultImage]
(
[IdExamResult_ExamResultImage] [int] NOT NULL IDENTITY(1, 1),
[IdExamResult] [int] NOT NULL,
[IdExamResultImage] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_ExamResult_ExamResultImage] ADD CONSTRAINT [PK_TR_ExamResult_ExamResultImage] PRIMARY KEY CLUSTERED ([IdExamResult_ExamResultImage])
GO
ALTER TABLE [dbo].[TR_ExamResult_ExamResultImage] ADD CONSTRAINT [FK_TR_ExamResult_ExamResultImage_TB_ExamResult] FOREIGN KEY ([IdExamResult]) REFERENCES [dbo].[TB_ExamResult] ([IdExamResult])
GO
ALTER TABLE [dbo].[TR_ExamResult_ExamResultImage] ADD CONSTRAINT [FK_TR_ExamResult_ExamResultImage_TB_ExamResultImage] FOREIGN KEY ([IdExamResultImage]) REFERENCES [dbo].[TB_ExamResultImage] ([IdExamResultImage])
GO
