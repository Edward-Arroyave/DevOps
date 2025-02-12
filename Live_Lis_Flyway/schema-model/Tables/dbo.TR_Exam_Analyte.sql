CREATE TABLE [dbo].[TR_Exam_Analyte]
(
[IdExam_Analyte] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Exam_Analyte] ADD CONSTRAINT [PK_TR_Exam_Analyte] PRIMARY KEY CLUSTERED ([IdExam_Analyte])
GO
