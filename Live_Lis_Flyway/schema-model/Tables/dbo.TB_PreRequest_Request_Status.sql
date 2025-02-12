CREATE TABLE [dbo].[TB_PreRequest_Request_Status]
(
[IdPreRequest_RequestStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[PreRequest_RequestStatus] [varchar] (10) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PreRequest_Request_Status] ADD CONSTRAINT [PK_TB_PreRequest_Request_Status] PRIMARY KEY CLUSTERED ([IdPreRequest_RequestStatus])
GO
