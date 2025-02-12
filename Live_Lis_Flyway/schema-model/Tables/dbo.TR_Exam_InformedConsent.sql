CREATE TABLE [dbo].[TR_Exam_InformedConsent]
(
[IdExam_InformedConsent] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[IdInformedConsent] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Exam_InformedConsent] ADD CONSTRAINT [PK_TR_Exam_InformedConsent] PRIMARY KEY CLUSTERED ([IdExam_InformedConsent])
GO
ALTER TABLE [dbo].[TR_Exam_InformedConsent] ADD CONSTRAINT [FK_TR_Exam_InformedConsent_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Exam_InformedConsent] ADD CONSTRAINT [FK_TR_Exam_InformedConsent_TB_InformedConsent] FOREIGN KEY ([IdInformedConsent]) REFERENCES [dbo].[TB_InformedConsent] ([IdInformedConsent])
GO
