CREATE TABLE [dbo].[TR_ExamGroup_Exam]
(
[IdExamGroup_Exam] [int] NOT NULL IDENTITY(1, 1),
[IdExamGroup] [int] NOT NULL,
[IdExam] [int] NOT NULL,
[IdService] [int] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_ExamGroup_Exam_Active] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TR_ExamGroup_Exam] ADD CONSTRAINT [PK_TR_ExamGroup_Exam] PRIMARY KEY CLUSTERED ([IdExamGroup_Exam])
GO
ALTER TABLE [dbo].[TR_ExamGroup_Exam] ADD CONSTRAINT [FK_TR_ExamGroup_Exam_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_ExamGroup_Exam] ADD CONSTRAINT [FK_TR_ExamGroup_Exam_TB_ExamGroup] FOREIGN KEY ([IdExamGroup]) REFERENCES [dbo].[TB_ExamGroup] ([IdExamGroup])
GO
ALTER TABLE [dbo].[TR_ExamGroup_Exam] ADD CONSTRAINT [FK_TR_ExamGroup_Exam_TB_Service] FOREIGN KEY ([IdService]) REFERENCES [dbo].[TB_Service] ([IdService])
GO
