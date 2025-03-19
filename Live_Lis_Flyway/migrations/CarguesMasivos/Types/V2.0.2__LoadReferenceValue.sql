/****** Object:  UserDefinedTableType [dbo].[LoadReferenceValue]    Script Date: 19/02/2025 11:30:48 a. m. ******/
CREATE TYPE [dbo].[LoadReferenceValue] AS TABLE(
	[AnalyteCode] [varchar](20) NULL,
	[MedicalDevice] [varchar](50) NULL,
	[BiologicalSex] [varchar](50) NULL,
	[MinAge] [int] NULL,
	[MaxAge] [int] NULL,
	[AgeTimeUnit] [varchar](20) NULL,
	[ExamTechnique] [varchar](50) NULL,
	[UnitOfMeasurement] [varchar](20) NULL,
	[DataType] [varchar](20) NULL,
	[InitialValue] [varchar](30) NULL,
	[FinalValue] [varchar](30) NULL,
	[ExpectedValue] [varchar](20) NULL,
	[CodificationText] [varchar](max) NULL,
	[Reactive] [varchar](50) NULL
)
GO

