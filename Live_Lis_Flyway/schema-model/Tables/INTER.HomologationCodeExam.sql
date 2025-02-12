CREATE TABLE [INTER].[HomologationCodeExam]
(
[IdHomologationCodeExam] [int] NOT NULL IDENTITY(1, 1),
[CodeDM] [varchar] (100) NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[IdExam] [int] NOT NULL,
[HostQuery] [varchar] (100) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[HomologationCodeExam] ADD CONSTRAINT [PK__Homologa__4C63310D4749283F] PRIMARY KEY CLUSTERED ([IdHomologationCodeExam])
GO
ALTER TABLE [INTER].[HomologationCodeExam] ADD CONSTRAINT [UQ__Homologa__C6DE828D22913FD8] UNIQUE NONCLUSTERED ([CodeDM])
GO
ALTER TABLE [INTER].[HomologationCodeExam] ADD CONSTRAINT [FK_AttentionCenter_INTER_HomologationCodeExam] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [INTER].[HomologationCodeExam] ADD CONSTRAINT [FK_Exam_INTER_HomologationCodeExam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [INTER].[HomologationCodeExam] ADD CONSTRAINT [FK_MedicalDevice_INTER_HomologationCodeExam] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[HomologationCodeExam] ADD CONSTRAINT [FK_Reactive_INTER_HomologationCodeExam] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [INTER].[HomologationCodeExam] ADD CONSTRAINT [FK_User_INTER_HomologationCodeExam] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
