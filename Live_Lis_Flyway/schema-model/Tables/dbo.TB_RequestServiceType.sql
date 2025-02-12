CREATE TABLE [dbo].[TB_RequestServiceType]
(
[IdRequestServiceType] [tinyint] NOT NULL IDENTITY(1, 1),
[RequestServiceType] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_RequestServiceType] ADD CONSTRAINT [PK_TB_RequestServiceType] PRIMARY KEY CLUSTERED ([IdRequestServiceType])
GO
