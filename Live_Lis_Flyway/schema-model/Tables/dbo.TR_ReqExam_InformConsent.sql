CREATE TABLE [dbo].[TR_ReqExam_InformConsent]
(
[IdReqExam_InformConsent] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NULL,
[IdInformedConsent] [tinyint] NULL,
[InformedConsent] [varchar] (max) NULL,
[PatientSignature] [bit] NOT NULL,
[ProfessionalSignature] [bit] NOT NULL,
[Active] [bit] NOT NULL,
[IdUserAction] [int] NULL,
[ProfessionalSignatureDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TR_ReqExam_InformConsent] ADD CONSTRAINT [PK_TR_ReqExam_InformConsent] PRIMARY KEY CLUSTERED ([IdReqExam_InformConsent])
GO
ALTER TABLE [dbo].[TR_ReqExam_InformConsent] ADD CONSTRAINT [FK_TR_ReqExam_InformConsent_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
