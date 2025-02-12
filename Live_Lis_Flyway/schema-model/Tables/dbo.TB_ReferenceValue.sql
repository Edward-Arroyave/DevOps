CREATE TABLE [dbo].[TB_ReferenceValue]
(
[IdReferenceValue] [int] NOT NULL IDENTITY(1, 1),
[IdAnalyte] [int] NOT NULL,
[IdExamTechnique] [int] NULL,
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[IdBiologicalSex] [tinyint] NOT NULL,
[MinAge] [int] NOT NULL,
[MaxAge] [int] NOT NULL,
[IdAgeTimeUnit] [tinyint] NULL,
[IdUnitOfMeasurement] [tinyint] NULL,
[IdDataType] [tinyint] NULL,
[InitialValue] [decimal] (15, 8) NULL,
[FinalValue] [decimal] (15, 8) NULL,
[IdExpectedValue] [smallint] NULL,
[CodificationText] [varchar] (max) NULL,
[ScheduledUpdateDate] [date] NULL,
[Status] [bit] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[QualitativeInitialValue] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [PK_TB_ReferenceValue] PRIMARY KEY CLUSTERED ([IdReferenceValue])
GO
CREATE NONCLUSTERED INDEX [IDX_Active] ON [dbo].[TB_ReferenceValue] ([Active])
GO
CREATE NONCLUSTERED INDEX [IDX_IdAgeTimeUnit] ON [dbo].[TB_ReferenceValue] ([IdAgeTimeUnit])
GO
CREATE NONCLUSTERED INDEX [IDX_TB_ReferenceValue_ID_] ON [dbo].[TB_ReferenceValue] ([IdAnalyte], [IdMedicalDevice], [IdReactive], [IdAgeTimeUnit], [Status], [Active], [IdBiologicalSex], [MinAge], [MaxAge])
GO
CREATE NONCLUSTERED INDEX [IDX_IdBiologicalSex] ON [dbo].[TB_ReferenceValue] ([IdBiologicalSex])
GO
CREATE NONCLUSTERED INDEX [IDX_TB_ReferenceValue] ON [dbo].[TB_ReferenceValue] ([IdMedicalDevice], [IdReactive], [IdAgeTimeUnit], [Status], [Active], [IdBiologicalSex], [MinAge], [MaxAge]) INCLUDE ([IdAnalyte])
GO
CREATE NONCLUSTERED INDEX [IDX_MaxAge] ON [dbo].[TB_ReferenceValue] ([MaxAge])
GO
CREATE NONCLUSTERED INDEX [IDX_MinAge] ON [dbo].[TB_ReferenceValue] ([MinAge])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_Analyte] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_BiologicalSex] FOREIGN KEY ([IdBiologicalSex]) REFERENCES [dbo].[TB_BiologicalSex] ([IdBiologicalSex])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_DataType] FOREIGN KEY ([IdDataType]) REFERENCES [dbo].[TB_DataType] ([IdDataType])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_ExamTechnique] FOREIGN KEY ([IdExamTechnique]) REFERENCES [dbo].[TB_ExamTechnique] ([IdExamTechnique])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_ExpectedValue] FOREIGN KEY ([IdExpectedValue]) REFERENCES [dbo].[TB_ExpectedValue] ([IdExpectedValue])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_MedicalDevice] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_Reactive] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [dbo].[TB_ReferenceValue] ADD CONSTRAINT [FK_TB_ReferenceValue_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
