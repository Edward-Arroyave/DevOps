CREATE TABLE [History].[TH_ConsultPaternityRequest]
(
[IdConsultPaternityRequest] [int] NOT NULL IDENTITY(1, 1),
[InitialDate] [date] NULL,
[FinalDate] [date] NULL,
[RequestNumber] [varchar] (20) NULL,
[IdRequestStatus] [tinyint] NULL,
[IdRequestType] [tinyint] NULL,
[InvoiceNumber] [varchar] (15) NULL,
[IdExam] [int] NULL,
[IdUser] [int] NOT NULL,
[ActionDate] [datetime] NOT NULL CONSTRAINT [DF_TH_ConsultPaternityRequest_ActionDate] DEFAULT (dateadd(hour,(-5),getdate()))
)
GO
ALTER TABLE [History].[TH_ConsultPaternityRequest] ADD CONSTRAINT [PK_TH_ConsultPaternityRequest] PRIMARY KEY CLUSTERED ([IdConsultPaternityRequest])
GO
