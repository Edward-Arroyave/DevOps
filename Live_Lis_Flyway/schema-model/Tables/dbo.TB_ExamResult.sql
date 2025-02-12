CREATE TABLE [dbo].[TB_ExamResult]
(
[IdExamResult] [int] NOT NULL IDENTITY(1, 1),
[ExamResultDate] [datetime] NOT NULL,
[ExamResult] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ExamResult] ADD CONSTRAINT [PK_TB_ExamResult] PRIMARY KEY CLUSTERED ([IdExamResult])
GO
