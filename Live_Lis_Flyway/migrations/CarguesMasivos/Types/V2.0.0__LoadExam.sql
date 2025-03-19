

/****** Object:  UserDefinedTableType [dbo].[LoadExam]    Script Date: 19/02/2025 11:25:25 a. m. ******/
CREATE TYPE [dbo].[LoadExam] AS TABLE(
	[GroupType] [varchar](10) NULL,
	[ExamCode] [varchar](20) NULL,
	[ExamName] [varchar](255) NULL,
	[ExamTitle] [varchar](255) NULL,
	[Visible] [varchar](10) NULL,
	[ExamTechnique] [varchar](255) NULL,
	[ExamType] [varchar](20) NULL,
	[Priority] [varchar](10) NULL,
	[LevelOfComplexity] [int] NULL,
	[Confidential] [varchar](10) NULL,
	[NotPrintResults] [varchar](10) NULL,
	[DeliveryOpportunity] [int] NULL,
	[ControlOpportunity] [varchar](20) NULL,
	[Decimal] [int] NULL,
	[ProcessingDays] [varchar](255) NULL,
	[Section] [varchar](255) NULL,
	[Template] [varchar](50) NULL,
	[BiologicalSex] [varchar](20) NULL,
	[MinAge] [int] NULL,
	[MaxAge] [int] NULL,
	[AgeTimeUnit] [varchar](20) NULL,
	[SampleType] [varchar](255) NULL,
	[ContainerType] [varchar](255) NULL,
	[Volume] [varchar](50) NULL,
	[ObligatoryTemperature] [varchar](15) NULL,
	[SampleConditions] [varchar](255) NULL,
	[AmbientTemperature] [varchar](15) NULL,
	[RefrigeratedTemperture] [varchar](15) NULL,
	[FrozenTemperature] [varchar](15) NULL,
	[TakingFrequency] [int] NULL,
	[TimeUnit] [varchar](20) NULL,
	[PBS] [varchar](10) NULL,
	[EpidemiologicalNotification] [varchar](10) NULL,
	[AssociateScore] [varchar](10) NULL,
	[Score] [int] NULL,
	[PlanValidity] [int] NULL,
	[PlanTimeUnit] [varchar](20) NULL
)
GO

