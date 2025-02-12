CREATE TABLE [PTO].[TB_SampleStorage]
(
[IdSampleStorage] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NOT NULL,
[IdLevelType] [int] NOT NULL,
[LevelType] [smallint] NOT NULL,
[TimeAmount] [tinyint] NOT NULL,
[TimeType] [varchar] (1) NOT NULL,
[StorageEndDate] [date] NULL,
[SampleStatus] [varchar] (1) NOT NULL,
[Observation] [text] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[NoveltyGeneration] [bit] NULL
)
GO
ALTER TABLE [PTO].[TB_SampleStorage] ADD CONSTRAINT [PK_TB_SampleStorage] PRIMARY KEY CLUSTERED ([IdSampleStorage])
GO
ALTER TABLE [PTO].[TB_SampleStorage] ADD CONSTRAINT [FK_TB_SampleStorage_TB_LevelType] FOREIGN KEY ([IdLevelType]) REFERENCES [PTO].[TB_LevelType] ([IdLevelType])
GO
ALTER TABLE [PTO].[TB_SampleStorage] ADD CONSTRAINT [FK_TB_SampleStorage_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_SampleStorage] ADD CONSTRAINT [FK_TB_SampleStorage_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
