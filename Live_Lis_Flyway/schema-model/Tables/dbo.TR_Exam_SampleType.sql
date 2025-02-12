CREATE TABLE [dbo].[TR_Exam_SampleType]
(
[IdExam_SampleType] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[IdSampleType] [int] NOT NULL,
[IdContainerType] [tinyint] NULL,
[Volume] [decimal] (7, 3) NULL,
[IdVolumeMeasure] [tinyint] NULL,
[Active] [bit] NOT NULL,
[AmbientTemperature] [varchar] (15) NULL,
[RefrigeratedTemperture] [varchar] (15) NULL,
[FrozenTemperature] [varchar] (15) NULL,
[Required] [bit] NULL
)
GO
ALTER TABLE [dbo].[TR_Exam_SampleType] ADD CONSTRAINT [PK_TR_Exam_SampleType] PRIMARY KEY CLUSTERED ([IdExam_SampleType])
GO
CREATE NONCLUSTERED INDEX [idx_EST_IdExam] ON [dbo].[TR_Exam_SampleType] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Exam_SampleType] ADD CONSTRAINT [FK_TR_Exam_SampleType_TB_ContainerType] FOREIGN KEY ([IdContainerType]) REFERENCES [dbo].[TB_ContainerType] ([IdContainerType])
GO
ALTER TABLE [dbo].[TR_Exam_SampleType] ADD CONSTRAINT [FK_TR_Exam_SampleType_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Exam_SampleType] ADD CONSTRAINT [FK_TR_Exam_SampleType_TB_SampleType] FOREIGN KEY ([IdSampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
ALTER TABLE [dbo].[TR_Exam_SampleType] ADD CONSTRAINT [FK_TR_Exam_SampleType_TB_VolumeMeasure] FOREIGN KEY ([IdVolumeMeasure]) REFERENCES [dbo].[TB_VolumeMeasure] ([IdVolumeMeasure])
GO
