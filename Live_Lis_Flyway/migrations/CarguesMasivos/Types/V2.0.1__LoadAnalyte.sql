/****** Object:  UserDefinedTableType [dbo].[LoadAnalyte]    Script Date: 19/02/2025 11:26:38 a. m. ******/


CREATE TYPE [dbo].[LoadAnalyte] AS TABLE(
	[GroupType] [varchar](10) NULL,
	[CodeExam] [varchar](20) NULL,
	[NameExam] [varchar](50) NULL,
	[NameAnalyte] [varchar](50) NULL,
	[Visible] [varchar](10) NULL,
	[Active] [varchar](10) NULL,
	[ExamTechnique] [varchar](50) NULL,
	[UnitOfMeasurement] [varchar](50) NULL,
	[AnalyteTypeComments] [varchar](10) NULL,
	[CodificationText] [varchar](max) NULL,
	[Comments] [varchar](200) NULL,
	[DataType] [varchar](20) NULL,
	[InitialValue] [varchar](30) NULL,
	[FinalValue] [varchar](30) NULL,
	[ExpectedValue] [varchar](50) NULL,
	[Decimal] [int] NULL,
	[DecimalAutoComplete] [varchar](10) NULL,
	[AnalyteMicrobiologyResult] [varchar](10) NULL
)
GO

