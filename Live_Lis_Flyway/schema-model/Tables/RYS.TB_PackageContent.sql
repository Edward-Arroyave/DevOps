CREATE TABLE [RYS].[TB_PackageContent]
(
[IdPackageContent] [int] NOT NULL IDENTITY(1, 1),
[IdPackage] [int] NULL,
[IdSampleRegistration] [int] NULL,
[IdSampleType] [int] NULL,
[Other] [varchar] (100) NULL,
[Amounth] [smallint] NULL,
[Observations] [varchar] (200) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TB_Packag__Activ__1BC9B88B] DEFAULT ((1)),
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[LabelCode] [varchar] (20) NULL,
[Internal] [bit] NULL
)
GO
ALTER TABLE [RYS].[TB_PackageContent] ADD CONSTRAINT [PK__TB_Packa__E4743C735F40557F] PRIMARY KEY CLUSTERED ([IdPackageContent])
GO
ALTER TABLE [RYS].[TB_PackageContent] ADD CONSTRAINT [FK_TB_Package_] FOREIGN KEY ([IdPackage]) REFERENCES [RYS].[TB_Package] ([IdPackage])
GO
ALTER TABLE [RYS].[TB_PackageContent] ADD CONSTRAINT [FK_TB_SampleRegistration_TB_SampleRegistration] FOREIGN KEY ([IdSampleRegistration]) REFERENCES [dbo].[TB_SampleRegistration] ([IdSampleRegistration])
GO
ALTER TABLE [RYS].[TB_PackageContent] ADD CONSTRAINT [FK_TB_SampleType_TB_SampleType] FOREIGN KEY ([IdSampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
