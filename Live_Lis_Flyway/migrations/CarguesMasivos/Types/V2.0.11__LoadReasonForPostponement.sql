/****** Object:  UserDefinedTableType [dbo].[LoadReasonForPostponement]    Script Date: 19/02/2025 11:49:28 a. m. ******/
CREATE TYPE [dbo].[LoadReasonForPostponement] AS TABLE(
	[PostponementCode] [varchar](10) NULL,
	[PostponementName] [varchar](200) NULL
)
GO

