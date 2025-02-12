CREATE TABLE [dbo].[TR_AlliedMedicalExam]
(
[IdAlliedMedicalExam] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[IdExam] [int] NULL,
[IdExamGroup] [int] NULL,
[ExpirationDate] [datetime] NULL,
[PointsExam] [int] NOT NULL,
[PointsWon] [int] NOT NULL,
[PointsRedeemed] [int] NULL,
[PointsExpired] [int] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TR_AlliedMedicalExam] ADD CONSTRAINT [PK__TR_Allie__AE11CE2BD05AA56F] PRIMARY KEY CLUSTERED ([IdAlliedMedicalExam])
GO
ALTER TABLE [dbo].[TR_AlliedMedicalExam] ADD CONSTRAINT [FK_TR_AlliedMedicalExam_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_AlliedMedicalExam] ADD CONSTRAINT [FK_TR_AlliedMedicalExam_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TR_AlliedMedicalExam] ADD CONSTRAINT [FK_TR_AlliedMedicalExam_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
