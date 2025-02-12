CREATE TABLE [RYS].[TB_PackageType]
(
[IdPackageType] [int] NOT NULL IDENTITY(1, 1),
[NameType] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [RYS].[TB_PackageType] ADD CONSTRAINT [PK_TB_PackageType_1] PRIMARY KEY CLUSTERED ([IdPackageType])
GO
