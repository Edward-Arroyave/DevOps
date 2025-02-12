CREATE TABLE [INTER].[HomologationCode]
(
[IdHomologationCode] [int] NOT NULL IDENTITY(1, 1),
[CodeDM] [varchar] (100) NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[IdExam] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL,
[TypeResult] [varchar] (100) NULL,
[Homologation] [varchar] (100) NULL,
[HostQuery] [varchar] (100) NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [PK__Homologa__C2F9807B98C4A1BD] PRIMARY KEY CLUSTERED ([IdHomologationCode])
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [UQ__Homologa__C6DE828D07533E0D] UNIQUE NONCLUSTERED ([CodeDM])
GO
CREATE NONCLUSTERED INDEX [IDX_INTER_HomologationCode_] ON [INTER].[HomologationCode] ([IdAttentionCenter], [IdMedicalDevice], [IdReactive], [TypeResult], [Homologation])
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [FK_Analyte_INTER_HomologationCode] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [FK_AttentionCenter_INTER_HomologationCode] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [FK_Exam_INTER_HomologationCode] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [FK_MedicalDevice_INTER_HomologationCode] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [FK_Reactive_INTER_HomologationCode] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [INTER].[HomologationCode] ADD CONSTRAINT [FK_User_INTER_HomologationCode] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
