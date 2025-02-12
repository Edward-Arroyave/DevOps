CREATE TABLE [dbo].[TR_PreRequest_Request]
(
[IdPreRequest_Request] [int] NOT NULL IDENTITY(1, 1),
[IdPreRequest] [int] NOT NULL,
[IdRequest] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_PreRequest_Request_Active] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_PreRequest_Request_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_PreRequest_Request] ADD CONSTRAINT [PK_TR_PreRequest_Request] PRIMARY KEY CLUSTERED ([IdPreRequest_Request])
GO
CREATE NONCLUSTERED INDEX [IdRequest_IdPreRequest] ON [dbo].[TR_PreRequest_Request] ([IdRequest]) INCLUDE ([IdPreRequest])
GO
ALTER TABLE [dbo].[TR_PreRequest_Request] ADD CONSTRAINT [FK_TR_PreRequest_Request_TB_PreRequest] FOREIGN KEY ([IdPreRequest]) REFERENCES [dbo].[TB_PreRequest] ([IdPreRequest])
GO
ALTER TABLE [dbo].[TR_PreRequest_Request] ADD CONSTRAINT [FK_TR_PreRequest_Request_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TR_PreRequest_Request] ADD CONSTRAINT [FK_TR_PreRequest_Request_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
