/****** Object:  UserDefinedTableType [dbo].[LoadUser]    Script Date: 19/02/2025 11:53:53 a. m. ******/
CREATE TYPE [dbo].[LoadUser] AS TABLE(
	[Name] [varchar](60) NULL,
	[LastName] [varchar](60) NULL,
	[IdIdentificationType] [varchar](20) NULL,
	[IdentificationNumber] [varchar](20) NULL,
	[BirthDate] [date] NULL,
	[Email] [varchar](100) NULL,
	[TelephoneNumber] [varchar](100) NULL,
	[ProfileType] [varchar](20) NULL,
	[Role] [varchar](20) NULL,
	[Title] [varchar](20) NULL,
	[Profession] [varchar](20) NULL,
	[ProfessionalCardNumber] [varchar](20) NULL,
	[AttentionCenter] [varchar](20) NULL
)
GO

