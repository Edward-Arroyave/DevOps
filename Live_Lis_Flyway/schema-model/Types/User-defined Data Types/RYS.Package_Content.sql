CREATE TYPE [RYS].[Package_Content] AS TABLE
(
[IdPackageContent] [int] NOT NULL,
[IdPackage] [int] NOT NULL,
[IdSampleRegistration] [int] NULL,
[IdSampleType] [int] NULL,
[Other] [nvarchar] (100) NULL,
[Amounth] [smallint] NULL,
[Internal] [bit] NULL,
[LabelCode] [nvarchar] (100) NULL,
[Observations] [nvarchar] (100) NULL,
[Active] [bit] NOT NULL
)
GO
