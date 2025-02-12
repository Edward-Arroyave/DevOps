CREATE TYPE [dbo].[ReqExam_InformConsent] AS TABLE
(
[IdRequest] [int] NOT NULL,
[IdInformedConsent] [int] NOT NULL,
[InformedConsent] [varchar] (max) NOT NULL,
[ProfessionalSignature] [bit] NULL
)
GO
