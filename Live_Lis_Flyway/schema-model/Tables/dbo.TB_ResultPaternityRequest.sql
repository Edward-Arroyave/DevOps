CREATE TABLE [dbo].[TB_ResultPaternityRequest]
(
[IdResultPaternityRequest] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[RequestNumber] [varchar] (20) NOT NULL,
[ResultsDocument] [varchar] (150) NULL,
[Validate] [bit] NULL,
[IdUserValidate] [int] NULL,
[ValidateDate] [datetime] NULL,
[Confirmation] [bit] NULL,
[IdUserConfirmation] [int] NULL,
[ConfirmationDate] [datetime] NULL,
[Observations] [varchar] (max) NULL,
[IdResultPaterReqStatus] [tinyint] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF_ResultPaternityRequest_Visible] DEFAULT ((0)),
[DevalidationReason] [varchar] (max) NULL,
[PrintNumber] [int] NULL CONSTRAINT [DF_ResultPaternityRequest_PrintNumber] DEFAULT ((0)),
[DownloadNumber] [int] NULL CONSTRAINT [DF_ResultPaternityRequest_DownloadNumber] DEFAULT ((0)),
[SendResults] [int] NULL CONSTRAINT [DF_ResultPaternityRequest_SendResults] DEFAULT ((0)),
[SendNotification] [int] NULL CONSTRAINT [DF_ResultPaternityRequest_SendNotification] DEFAULT ((0)),
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_ResultPaternityRequest] ADD CONSTRAINT [PK_TB_ResultPaternityRequest] PRIMARY KEY CLUSTERED ([IdResultPaternityRequest])
GO
ALTER TABLE [dbo].[TB_ResultPaternityRequest] ADD CONSTRAINT [FK_TB_ResultPaternityRequest_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TB_ResultPaternityRequest] ADD CONSTRAINT [FK_TB_ResultPaternityRequest_TB_ResultPaterReqStatus] FOREIGN KEY ([IdResultPaterReqStatus]) REFERENCES [dbo].[TB_ResultPaterReqStatus] ([IdResultPaterReqStatus])
GO
ALTER TABLE [dbo].[TB_ResultPaternityRequest] ADD CONSTRAINT [FK_TB_ResultPaternityRequest_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_ResultPaternityRequest] ADD CONSTRAINT [FK_TB_ResultPaternityRequest1_TB_User] FOREIGN KEY ([IdUserValidate]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_ResultPaternityRequest] ADD CONSTRAINT [FK_TB_ResultPaternityRequest2_TB_User] FOREIGN KEY ([IdUserConfirmation]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
