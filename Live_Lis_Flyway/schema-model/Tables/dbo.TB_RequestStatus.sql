CREATE TABLE [dbo].[TB_RequestStatus]
(
[IdRequestStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[RequestStatus] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_RequestStatus] ADD CONSTRAINT [PK_TB_RequestStatus] PRIMARY KEY CLUSTERED ([IdRequestStatus])
GO
