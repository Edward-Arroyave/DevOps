CREATE TABLE [dbo].[TB_HistorySend]
(
[IdHistorySend] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (12) NOT NULL,
[IdResultPaternityRequest] [int] NOT NULL,
[RequestNumber] [varchar] (20) NOT NULL,
[Email] [varchar] (100) NOT NULL,
[SendReason] [varchar] (max) NULL,
[SendDate] [datetime] NOT NULL,
[SendType] [varchar] (10) NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_HistorySend] ADD CONSTRAINT [PK_TB_HistorySend] PRIMARY KEY CLUSTERED ([IdHistorySend])
GO
ALTER TABLE [dbo].[TB_HistorySend] ADD CONSTRAINT [FK_TB_HistorySend_TB_ResultPaternityRequest] FOREIGN KEY ([IdResultPaternityRequest]) REFERENCES [dbo].[TB_ResultPaternityRequest] ([IdResultPaternityRequest])
GO
ALTER TABLE [dbo].[TB_HistorySend] ADD CONSTRAINT [FK_TB_HistorySend_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
