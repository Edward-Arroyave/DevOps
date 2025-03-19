/****** Object:  UserDefinedTableType [dbo].[LoadCriticalDataExam]    Script Date: 19/02/2025 11:45:48 a. m. ******/
CREATE TYPE [dbo].[LoadCriticalDataExam] AS TABLE(
	[ExamCode] [varchar](20) NULL,
	[NameAnalyte] [varchar](50) NULL,
	[DataType] [varchar](50) NULL,
	[LowerLimit] [varchar](50) NULL,
	[UpperLimit] [varchar](50) NULL,
	[ExpectedValue] [varchar](50) NULL
)
GO

