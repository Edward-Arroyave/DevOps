CREATE TABLE [dbo].[TB_RequestFileType]
(
[IdRequestFileType] [tinyint] NOT NULL IDENTITY(1, 1),
[RequestFileType] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_RequestFileType] ADD CONSTRAINT [PK_TB_RequestFileType] PRIMARY KEY CLUSTERED ([IdRequestFileType])
GO
