CREATE TABLE [POSANT].[TB_ExamConfig]
(
[IdExamConfig] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[Status] [bit] NOT NULL
)
GO
ALTER TABLE [POSANT].[TB_ExamConfig] ADD CONSTRAINT [FK__TB_ExamCo__IdExa__2C2A3D86] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [POSANT].[TB_ExamConfig] ADD CONSTRAINT [FK__TB_ExamCo__IdMed__2D1E61BF] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [POSANT].[TB_ExamConfig] ADD CONSTRAINT [FK__TB_ExamCo__IdRea__2E1285F8] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [POSANT].[TB_ExamConfig] ADD CONSTRAINT [FK__TB_ExamCo__IdUse__2F06AA31] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
