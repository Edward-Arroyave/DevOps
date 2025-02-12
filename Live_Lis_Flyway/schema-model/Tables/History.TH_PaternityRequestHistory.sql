CREATE TABLE [History].[TH_PaternityRequestHistory]
(
[Id_PaternityRequestHistory] [int] NOT NULL IDENTITY(1, 1),
[ActionDate] [datetime] NOT NULL,
[Action] [varchar] (10) NOT NULL,
[IdRequest] [int] NOT NULL,
[RequestNumber] [varchar] (20) NOT NULL,
[AuthorityRequest] [bit] NOT NULL,
[LegalDocument] [varchar] (150) NULL,
[OrderingNumber] [varchar] (20) NULL,
[NumberOfPatients] [tinyint] NOT NULL,
[IdRequestStatus] [tinyint] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [History].[TH_PaternityRequestHistory] ADD CONSTRAINT [PK_TH_PaternityRequestHistory] PRIMARY KEY CLUSTERED ([Id_PaternityRequestHistory])
GO
