CREATE TABLE [dbo].[TB_Company]
(
[IdCompany] [int] NOT NULL IDENTITY(1, 1),
[CompanyCode] [varchar] (10) NOT NULL,
[CompanyName] [varchar] (120) NOT NULL,
[IdEconomicActivity] [smallint] NULL,
[IdIdentificationType] [tinyint] NULL,
[NIT] [varchar] (12) NULL,
[VerificationDigit] [varchar] (1) NULL,
[Address] [varchar] (100) NULL,
[TelephoneNumber] [varchar] (30) NULL,
[Email] [varchar] (100) NULL,
[CreditQuota] [varchar] (20) NULL,
[CreditBalance] [varchar] (20) NULL,
[IdCity] [int] NULL,
[IdCommercialZone] [int] NULL,
[PortfolioContact] [varchar] (max) NULL,
[PortfolioContactTelephoneNumber] [varchar] (15) NULL,
[PolicyNumber] [varchar] (20) NULL,
[BillingContact] [varchar] (100) NULL,
[ValidateCreditQuota] [bit] NULL,
[AttentPreRequisite] [bit] NULL,
[AttentionPreRequisite] [varchar] (max) NULL,
[BillRequirement] [bit] NULL,
[BillingRequirements] [varchar] (max) NULL,
[IdCompanySegment] [tinyint] NULL,
[IdCompanySubSegment] [tinyint] NULL,
[IdMarketGroup] [tinyint] NULL,
[TelephoneNumberQuality] [varchar] (20) NULL,
[CompanyIntranet] [bit] NULL,
[IdPartnerOdoo] [int] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Company] ADD CONSTRAINT [PK_TB_Company] PRIMARY KEY CLUSTERED ([IdCompany])
GO
ALTER TABLE [dbo].[TB_Company] ADD CONSTRAINT [FK_TB_Company_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_Company] ADD CONSTRAINT [FK_TB_Company_TB_CompanyZone] FOREIGN KEY ([IdCommercialZone]) REFERENCES [dbo].[TB_CommercialZone] ([IdCommercialZone])
GO
ALTER TABLE [dbo].[TB_Company] ADD CONSTRAINT [FK_TB_Company_TB_EconomicActivity] FOREIGN KEY ([IdEconomicActivity]) REFERENCES [dbo].[TB_EconomicActivity] ([IdEconomicActivity])
GO
ALTER TABLE [dbo].[TB_Company] ADD CONSTRAINT [FK_TB_Company_TB_IdentificationType] FOREIGN KEY ([IdIdentificationType]) REFERENCES [dbo].[TB_IdentificationType] ([IdIdentificationType])
GO
ALTER TABLE [dbo].[TB_Company] ADD CONSTRAINT [FK_TB_Company_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
