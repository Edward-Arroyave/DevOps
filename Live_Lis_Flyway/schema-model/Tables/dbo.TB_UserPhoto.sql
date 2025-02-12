CREATE TABLE [dbo].[TB_UserPhoto]
(
[IdPhoto] [int] NOT NULL IDENTITY(1, 1),
[PhotoCode] [varchar] (25) NOT NULL,
[PhotoName] [varchar] (100) NULL,
[IdUser] [int] NOT NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_UserPhoto] ADD CONSTRAINT [PK_TB_Photo] PRIMARY KEY CLUSTERED ([IdPhoto])
GO
ALTER TABLE [dbo].[TB_UserPhoto] ADD CONSTRAINT [FK_TB_UserPhoto_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_UserPhoto] ADD CONSTRAINT [FK_TB_UserPhoto_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
