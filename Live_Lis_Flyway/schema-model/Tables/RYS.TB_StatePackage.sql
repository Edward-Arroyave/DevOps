CREATE TABLE [RYS].[TB_StatePackage]
(
[IdPackageStatus] [int] NOT NULL IDENTITY(1, 1),
[NameStatus] [varchar] (50) NULL
)
GO
ALTER TABLE [RYS].[TB_StatePackage] ADD CONSTRAINT [PK_TB_StatePackage] PRIMARY KEY CLUSTERED ([IdPackageStatus])
GO
