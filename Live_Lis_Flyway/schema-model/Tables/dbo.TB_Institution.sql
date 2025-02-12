CREATE TABLE [dbo].[TB_Institution]
(
[IdInstitution] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) NOT NULL,
[Address] [varchar] (200) NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUser] [int] NOT NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_Institution] ADD CONSTRAINT [PK__TB_Insti__3882AA6DA70AE30E] PRIMARY KEY CLUSTERED ([IdInstitution])
GO
ALTER TABLE [dbo].[TB_Institution] ADD CONSTRAINT [FK_TB_Institution_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_Institution] ADD CONSTRAINT [FK_TB_Institution_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
