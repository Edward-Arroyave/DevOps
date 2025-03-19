/****** Object:  UserDefinedTableType [dbo].[LoadRolesAndPermissions]    Script Date: 19/02/2025 11:53:26 a. m. ******/
CREATE TYPE [dbo].[LoadRolesAndPermissions] AS TABLE(
	[Module] [varchar](50) NULL,
	[Permissions] [varchar](max) NULL,
	[Active] [varchar](10) NULL,
	[View] [varchar](10) NULL,
	[Edit] [varchar](10) NULL,
	[Create] [varchar](10) NULL
)
GO

