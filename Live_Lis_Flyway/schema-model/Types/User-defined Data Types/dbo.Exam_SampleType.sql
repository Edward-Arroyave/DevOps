CREATE TYPE [dbo].[Exam_SampleType] AS TABLE
(
[IdSampleType] [int] NOT NULL,
[IdContainerType] [int] NOT NULL,
[Volume] [decimal] (7, 3) NULL,
[IdVolumeMeasure] [tinyint] NULL,
[AmbientTemperature] [varchar] (15) NULL,
[RefrigeratedTemperture] [varchar] (15) NULL,
[FrozenTemperature] [varchar] (15) NULL,
[Required] [bit] NULL
)
GO
