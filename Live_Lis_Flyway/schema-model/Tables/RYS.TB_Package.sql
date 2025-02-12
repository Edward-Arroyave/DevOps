CREATE TABLE [RYS].[TB_Package]
(
[IdPackage] [int] NOT NULL IDENTITY(1, 1),
[PackageBarCode] [varchar] (30) NULL,
[IdPackageType] [int] NULL,
[IdAttentionCenter] [smallint] NULL,
[IdPackageStatus] [int] NULL,
[IdCreationUser] [int] NULL,
[DateCreationTemp] [datetime] NULL,
[GuideNumber] [varchar] (50) NULL,
[Transporter] [varchar] (200) NULL,
[GuidePrice] [money] NULL,
[IdCompany] [int] NULL,
[AmbientTempCreation] [decimal] (5, 2) NULL,
[RefrigerationTempCreation] [decimal] (5, 2) NULL,
[FreezingTempCreation] [decimal] (5, 2) NULL,
[IdLogisticUser] [int] NULL,
[LogisticDate] [datetime] NULL,
[AmbientTemLogistic] [decimal] (5, 2) NULL,
[RefrigerationTempLogistic] [decimal] (5, 2) NULL,
[FreezingTempLogistic] [decimal] (5, 2) NULL,
[VerificationDate] [datetime] NULL,
[AmbientTempVerif] [decimal] (5, 2) NULL,
[RefrigerationTempVerif] [decimal] (5, 2) NULL,
[FreezingTempVerif] [decimal] (5, 2) NULL,
[IdVerificationUser] [int] NULL,
[UpdateDate] [datetime] NULL,
[IdAttentionCenterLogistic] [smallint] NULL,
[IdAttentionCenterVerification] [smallint] NULL,
[Description] [varchar] (200) NULL
)
GO
ALTER TABLE [RYS].[TB_Package] ADD CONSTRAINT [PK__TB_Packa__361A6687EBDE94B0] PRIMARY KEY CLUSTERED ([IdPackage])
GO
ALTER TABLE [RYS].[TB_Package] ADD CONSTRAINT [FK_TB_AttentionCenter_TB_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [RYS].[TB_Package] ADD CONSTRAINT [FK_TB_Company_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [RYS].[TB_Package] ADD CONSTRAINT [FK_TB_PackageType_TB_PackageType] FOREIGN KEY ([IdPackageType]) REFERENCES [RYS].[TB_PackageType] ([IdPackageType])
GO
ALTER TABLE [RYS].[TB_Package] ADD CONSTRAINT [FK_TB_StatePackage_TB_PackageStatus] FOREIGN KEY ([IdPackageStatus]) REFERENCES [RYS].[TB_StatePackage] ([IdPackageStatus])
GO
ALTER TABLE [RYS].[TB_Package] ADD CONSTRAINT [FK_TB_User_TB_User] FOREIGN KEY ([IdCreationUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
