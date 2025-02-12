CREATE TABLE [dbo].[TB_RefValueChange]
(
[IdRefValueChange] [int] NOT NULL IDENTITY(1, 1),
[IdReferenceValue] [int] NOT NULL,
[ChangeConsec] [int] NOT NULL,
[IdExamTechnique] [int] NULL,
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[IdBiologicalSex] [tinyint] NOT NULL,
[MinAge] [int] NOT NULL,
[MaxAge] [int] NOT NULL,
[IdAgeTimeUnit] [tinyint] NOT NULL,
[IdUnitOfMeasurement] [tinyint] NULL,
[IdDataType] [tinyint] NULL,
[InitialValue] [decimal] (7, 3) NULL,
[FinalValue] [decimal] (7, 3) NULL,
[IdExpectedValue] [smallint] NULL,
[CodificationText] [varchar] (max) NULL,
[ScheduledUpdateDate] [date] NULL,
[IdRefValueChangeStatus] [tinyint] NOT NULL,
[ReasonCancellation] [varchar] (max) NULL,
[ReturnDate] [datetime] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[QualitativeInitialValue] [bit] NULL,
[Status] [bit] NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [PK_TB_RefValueChange] PRIMARY KEY CLUSTERED ([IdRefValueChange])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_BiologicalSex] FOREIGN KEY ([IdBiologicalSex]) REFERENCES [dbo].[TB_BiologicalSex] ([IdBiologicalSex])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_DataType] FOREIGN KEY ([IdDataType]) REFERENCES [dbo].[TB_DataType] ([IdDataType])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_ExamTechnique] FOREIGN KEY ([IdExamTechnique]) REFERENCES [dbo].[TB_ExamTechnique] ([IdExamTechnique])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_ExpectedValue] FOREIGN KEY ([IdExpectedValue]) REFERENCES [dbo].[TB_ExpectedValue] ([IdExpectedValue])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_MedicalDevice] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_Reactive] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_ReferenceValue] FOREIGN KEY ([IdReferenceValue]) REFERENCES [dbo].[TB_ReferenceValue] ([IdReferenceValue])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_RefValueChangeStatus] FOREIGN KEY ([IdRefValueChangeStatus]) REFERENCES [dbo].[TB_RefValueChangeStatus] ([IdRefValueChangeStatus])
GO
ALTER TABLE [dbo].[TB_RefValueChange] ADD CONSTRAINT [FK_TB_RefValueChange_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
