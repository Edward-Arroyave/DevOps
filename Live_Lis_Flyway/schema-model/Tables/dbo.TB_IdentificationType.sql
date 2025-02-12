CREATE TABLE [dbo].[TB_IdentificationType]
(
[IdIdentificationType] [tinyint] NOT NULL IDENTITY(1, 1),
[IdentificationTypeCode] [varchar] (4) NULL,
[IdentificationTypeDesc] [varchar] (70) NOT NULL,
[IdentificationTypeCode_EB] [varchar] (2) NULL,
[Patient] [bit] NOT NULL,
[ElectronicBilling] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_IdentificationType] ADD CONSTRAINT [PK_TB_IdentificationType] PRIMARY KEY CLUSTERED ([IdIdentificationType])
GO
