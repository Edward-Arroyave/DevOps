CREATE TABLE [INTER].[SelfValidations]
(
[IdSelfValidations] [int] NOT NULL IDENTITY(1, 1),
[IdMedicalDevice] [int] NOT NULL,
[IdSection] [smallint] NOT NULL,
[IdExam] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL,
[Validated1] [bit] NOT NULL,
[Validated2] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[SelfValidations] ADD CONSTRAINT [PK__SelfVali__B5637EC97B18850D] PRIMARY KEY CLUSTERED ([IdSelfValidations])
GO
ALTER TABLE [INTER].[SelfValidations] ADD CONSTRAINT [FK_Analyte_INTER_SelfValidations] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [INTER].[SelfValidations] ADD CONSTRAINT [FK_Exam_INTER_SelfValidations] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [INTER].[SelfValidations] ADD CONSTRAINT [FK_MedicalDevice_INTER_SelfValidations] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[SelfValidations] ADD CONSTRAINT [FK_Section_INTER_SelfValidations] FOREIGN KEY ([IdSection]) REFERENCES [dbo].[TB_Section] ([IdSection])
GO
ALTER TABLE [INTER].[SelfValidations] ADD CONSTRAINT [FK_User_INTER_SelfValidations] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
