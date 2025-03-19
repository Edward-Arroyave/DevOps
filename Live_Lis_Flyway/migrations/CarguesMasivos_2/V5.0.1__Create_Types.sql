/****** Object:  UserDefinedTableType [dbo].[LoadRolesAndPermissions]    Script Date: 11/03/2025 8:21:56 a. m. ******/
CREATE TYPE [dbo].[LoadRolesAndPermissions] AS TABLE(
	[ProfileName] [varchar](50) NULL,
	[RoleName] [varchar](50) NULL,
	[AreaName] [varchar](50) NULL,
	[ModulesPermission] [varchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LoadUser]    Script Date: 11/03/2025 8:22:10 a. m. ******/
CREATE TYPE [dbo].[LoadUser] AS TABLE(
	[IdIdentificationType] [varchar](50) NULL,
	[IdentificationNumber] [varchar](20) NULL,
	[Name] [varchar](60) NULL,
	[LastName] [varchar](60) NULL,
	[BirthDate] [date] NULL,
	[Country] [varchar](50) NULL,
	[Estado] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[TelephoneNumber] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[Institucion] [varchar](50) NULL,
	[Direccion] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](120) NULL,
	[ProfileType] [varchar](20) NULL,
	[Role] [varchar](20) NULL,
	[Title] [varchar](20) NULL,
	[Profession] [varchar](20) NULL,
	[ProfessionalCardNumber] [varchar](20) NULL,
	[AttentionCenter] [varchar](max) NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[LoadContainer]    Script Date: 11/03/2025 8:22:26 a. m. ******/
CREATE TYPE [dbo].[LoadContainer] AS TABLE(
	[ContainerName] [varchar](50) NULL,
	[Color] [varchar](50) NULL
)
GO

