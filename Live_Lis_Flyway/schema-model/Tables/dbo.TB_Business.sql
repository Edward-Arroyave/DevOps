CREATE TABLE [dbo].[TB_Business]
(
[IdBusiness] [tinyint] NOT NULL IDENTITY(1, 1),
[BusinessName] [varchar] (100) NOT NULL,
[Name] [varchar] (100) NOT NULL,
[NIT] [varchar] (9) NOT NULL,
[VerificationDigit] [varchar] (1) NULL,
[Email] [varchar] (100) NOT NULL,
[PostalCode] [varchar] (8) NOT NULL,
[Address] [varchar] (100) NOT NULL,
[IdCountry] [int] NOT NULL,
[IdCity] [int] NULL,
[TelephoneNumber] [varchar] (20) NOT NULL,
[Logo] [varchar] (150) NULL,
[DataProcessingDocument] [varchar] (150) NULL,
[DataProcessingDocumentName] [varchar] (50) NULL,
[ManualBalancing] [bit] NOT NULL CONSTRAINT [DF_ManualBalancing] DEFAULT ((0)),
[IdAttentionCenter] [smallint] NULL,
[IdIdentificationType] [tinyint] NULL,
[Interoperability] [bit] NULL CONSTRAINT [DF__TB_Busine__Toggl__55CB7197] DEFAULT ((0)),
[IVA] [bit] NULL CONSTRAINT [DF__TB_Business__IVA__56BF95D0] DEFAULT ((0)),
[IVApercentage] [decimal] (4, 2) NULL,
[UpdateDate] [datetime] NULL,
[RFC] [varchar] (12) NULL
)
GO
ALTER TABLE [dbo].[TB_Business] ADD CONSTRAINT [PK_TB_Business] PRIMARY KEY CLUSTERED ([IdBusiness])
GO
ALTER TABLE [dbo].[TB_Business] ADD CONSTRAINT [FK_TB_Business_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_Business] ADD CONSTRAINT [FK_TB_Business_TB_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
