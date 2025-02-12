CREATE TABLE [POSANT].[TB_ReferenceValueExamConfig]
(
[IdReferenceValueExamConfig] [int] NOT NULL IDENTITY(1, 1),
[IdExamConfig] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL,
[IdDataType] [tinyint] NOT NULL,
[ExpectedValue] [varchar] (50) NULL,
[MinimumValue] [varchar] (15) NULL,
[MaximumValue] [varchar] (15) NULL,
[IdBiologicalSex] [tinyint] NOT NULL,
[IdAgeTimeUnit] [tinyint] NOT NULL,
[InitalAge] [int] NOT NULL,
[FinalAge] [int] NOT NULL,
[PatientType] [int] NOT NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[Status] [bit] NOT NULL
)
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [PK__TB_Refer__9162817C0F07706F] PRIMARY KEY CLUSTERED ([IdReferenceValueExamConfig])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdAna__34BF8387] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdAna__35B3A7C0] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdAna__36A7CBF9] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdBio__379BF032] FOREIGN KEY ([IdBiologicalSex]) REFERENCES [dbo].[TB_BiologicalSex] ([IdBiologicalSex])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdBio__3890146B] FOREIGN KEY ([IdBiologicalSex]) REFERENCES [dbo].[TB_BiologicalSex] ([IdBiologicalSex])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdBio__398438A4] FOREIGN KEY ([IdBiologicalSex]) REFERENCES [dbo].[TB_BiologicalSex] ([IdBiologicalSex])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdDat__3A785CDD] FOREIGN KEY ([IdDataType]) REFERENCES [dbo].[TB_DataType] ([IdDataType])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdDat__3B6C8116] FOREIGN KEY ([IdDataType]) REFERENCES [dbo].[TB_DataType] ([IdDataType])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdDat__3C60A54F] FOREIGN KEY ([IdDataType]) REFERENCES [dbo].[TB_DataType] ([IdDataType])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdAge__32D73B15] FOREIGN KEY ([IdAgeTimeUnit]) REFERENCES [dbo].[TB_TimeUnit] ([IdTimeUnit])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdAge__33CB5F4E] FOREIGN KEY ([IdAgeTimeUnit]) REFERENCES [dbo].[TB_TimeUnit] ([IdTimeUnit])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdUse__3D54C988] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdUse__3E48EDC1] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [POSANT].[TB_ReferenceValueExamConfig] ADD CONSTRAINT [FK__TB_Refere__IdUse__3F3D11FA] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
