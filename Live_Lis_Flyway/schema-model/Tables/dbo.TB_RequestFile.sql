CREATE TABLE [dbo].[TB_RequestFile]
(
[IdRequestFile] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[IdRequestFileType] [tinyint] NOT NULL,
[RequestFileName] [varchar] (100) NOT NULL,
[RequestFileNameContainer] [varchar] (150) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_RequestFile] ADD CONSTRAINT [PK_TB_RequestFile] PRIMARY KEY CLUSTERED ([IdRequestFile])
GO
ALTER TABLE [dbo].[TB_RequestFile] ADD CONSTRAINT [FK_TB_RequestFile_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TB_RequestFile] ADD CONSTRAINT [FK_TB_RequestFile_TB_RequestFileType] FOREIGN KEY ([IdRequestFileType]) REFERENCES [dbo].[TB_RequestFileType] ([IdRequestFileType])
GO
ALTER TABLE [dbo].[TB_RequestFile] ADD CONSTRAINT [FK_TB_RequestFile_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
