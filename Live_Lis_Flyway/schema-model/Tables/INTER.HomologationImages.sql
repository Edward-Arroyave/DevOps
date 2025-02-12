CREATE TABLE [INTER].[HomologationImages]
(
[IdHomologationImages] [int] NOT NULL IDENTITY(1, 1),
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[IdExam] [int] NOT NULL,
[Homologation] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[HomologationImages] ADD CONSTRAINT [PK__Homologa__7CA03B91257E9416] PRIMARY KEY CLUSTERED ([IdHomologationImages])
GO
ALTER TABLE [INTER].[HomologationImages] ADD CONSTRAINT [FK_Exam_INTER_HomologationImages] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [INTER].[HomologationImages] ADD CONSTRAINT [FK_MedicalDevice_INTER_HomologationImages] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[HomologationImages] ADD CONSTRAINT [FK_Reactive_INTER_HomologationImages] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [INTER].[HomologationImages] ADD CONSTRAINT [FK_User_INTER_HomologationImages] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
