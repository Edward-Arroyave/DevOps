CREATE TABLE [dbo].[TB_Analyte]
(
[IdAnalyte] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NULL,
[AnalyteCode] [varchar] (10) NOT NULL,
[AnalyteCodeAlter] [varchar] (10) NULL,
[AnalyteName] [varchar] (250) NOT NULL,
[IdSampleType] [int] NULL,
[IdExamTechnique] [int] NULL,
[IdUnitOfMeasurement] [tinyint] NULL,
[Comments] [varchar] (max) NULL,
[ResultFormula] [varchar] (max) NULL,
[IdDataType] [tinyint] NULL,
[InitialValue] [decimal] (15, 8) NULL,
[FinalValue] [decimal] (15, 8) NULL,
[IdExpectedValue] [smallint] NULL,
[CodificationText] [varchar] (max) NULL,
[Visible] [bit] NULL,
[Position] [int] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Analyte_Active] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_Analyte_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[IdAnalitos] [int] NULL,
[pruebasanalito] [bit] NULL,
[AnalyteTypeComment] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [PK_TB_Analyte] PRIMARY KEY CLUSTERED ([IdAnalyte])
GO
CREATE NONCLUSTERED INDEX [IDX_Analyte_IdAnalyte] ON [dbo].[TB_Analyte] ([IdAnalyte])
GO
CREATE NONCLUSTERED INDEX [IDX_Analyte] ON [dbo].[TB_Analyte] ([IdAnalyte], [Active])
GO
CREATE NONCLUSTERED INDEX [idx_TBA_IdExam] ON [dbo].[TB_Analyte] ([IdExam])
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [FK_TB_Analyte_TB_DataType] FOREIGN KEY ([IdDataType]) REFERENCES [dbo].[TB_DataType] ([IdDataType])
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [FK_TB_Analyte_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [FK_TB_Analyte_TB_ExamTechnique] FOREIGN KEY ([IdExamTechnique]) REFERENCES [dbo].[TB_ExamTechnique] ([IdExamTechnique])
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [FK_TB_Analyte_TB_ExpectedValue] FOREIGN KEY ([IdExpectedValue]) REFERENCES [dbo].[TB_ExpectedValue] ([IdExpectedValue])
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [FK_TB_Analyte_TB_SampleType] FOREIGN KEY ([IdSampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [FK_TB_Analyte_TB_UnitOfMeasurement] FOREIGN KEY ([IdUnitOfMeasurement]) REFERENCES [dbo].[TB_UnitOfMeasurement] ([IdUnitOfMeasurement])
GO
ALTER TABLE [dbo].[TB_Analyte] ADD CONSTRAINT [FK_TB_Analyte_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
