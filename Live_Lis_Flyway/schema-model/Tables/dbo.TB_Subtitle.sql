CREATE TABLE [dbo].[TB_Subtitle]
(
[IdSubtitle] [int] NOT NULL IDENTITY(1, 1),
[IdCover] [int] NOT NULL,
[SubtitleName] [varchar] (50) NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TB_Subtit__Creat__38260017] DEFAULT (getdate()),
[IdCreationUser] [int] NOT NULL,
[IdUserAction] [int] NULL,
[UpdateDate] [datetime] NULL,
[IsTitle] [bit] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TB_Subtit__Activ__391A2450] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TB_Subtitle] ADD CONSTRAINT [PK__TB_Subti__8C10B5CB719B5147] PRIMARY KEY CLUSTERED ([IdSubtitle])
GO
ALTER TABLE [dbo].[TB_Subtitle] ADD CONSTRAINT [FK_TB_Subtitle_IdCover] FOREIGN KEY ([IdCover]) REFERENCES [dbo].[TB_Cover] ([IdCover])
GO
ALTER TABLE [dbo].[TB_Subtitle] ADD CONSTRAINT [FK_TB_Subtitle_IdCreationUser] FOREIGN KEY ([IdCreationUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_Subtitle] ADD CONSTRAINT [FK_TB_Subtitle_IdUserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
