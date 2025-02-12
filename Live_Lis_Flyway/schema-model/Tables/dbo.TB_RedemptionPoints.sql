CREATE TABLE [dbo].[TB_RedemptionPoints]
(
[IdRedemptionPoints] [int] NOT NULL IDENTITY(1, 1),
[IdAlliedMedicalExam] [int] NOT NULL,
[Points] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_RedemptionPoints] ADD CONSTRAINT [PK__TB_Redem__0F5CA550801A2F96] PRIMARY KEY CLUSTERED ([IdRedemptionPoints])
GO
ALTER TABLE [dbo].[TB_RedemptionPoints] ADD CONSTRAINT [FK_TB_RedemptionPoints_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_RedemptionPoints] ADD CONSTRAINT [FK_TB_RedemptionPoints_TR_AlliedMedicalExam] FOREIGN KEY ([IdAlliedMedicalExam]) REFERENCES [dbo].[TR_AlliedMedicalExam] ([IdAlliedMedicalExam])
GO
