CREATE TABLE [History].[TH_ResultPaternityRequest]
(
[IdHisResultPaternityRequest] [int] NOT NULL IDENTITY(1, 1),
[IdResultPaternityRequest] [int] NOT NULL,
[IdRequest] [int] NOT NULL,
[ActionDate] [datetime] NULL,
[Movement] [varchar] (50) NULL,
[Observations] [varchar] (max) NULL,
[DevalidationReason] [varchar] (max) NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [History].[TH_ResultPaternityRequest] ADD CONSTRAINT [PK_TH_ResultPaternityRequest] PRIMARY KEY CLUSTERED ([IdHisResultPaternityRequest])
GO
