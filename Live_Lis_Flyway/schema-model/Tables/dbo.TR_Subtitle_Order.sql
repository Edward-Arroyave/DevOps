CREATE TABLE [dbo].[TR_Subtitle_Order]
(
[IdSubtitleOrder] [int] NOT NULL IDENTITY(1, 1),
[IdCover] [int] NOT NULL,
[IdSubtitle_Title] [int] NULL,
[IdSubtitle_Subtitle] [int] NULL,
[IdCoverExam] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL,
[Position] [int] NOT NULL,
[IsVisible] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TR_Subtit__Creat__448BD6FC] DEFAULT (getdate()),
[IdCreationUser] [int] NOT NULL,
[IdUserAction] [int] NULL,
[UpdateDate] [datetime] NULL,
[StartDate] [datetime] NOT NULL,
[FinishDate] [datetime] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TR_Subtit__Activ__457FFB35] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [PK__TR_Subti__4FFF567C6D0B210D] PRIMARY KEY CLUSTERED ([IdSubtitleOrder])
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [FK_Subtitle_Order_IdCreationUser] FOREIGN KEY ([IdCreationUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [FK_Subtitle_Order_IdUserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [FK_TB_Subtitle_Order_IdAnalyte] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [FK_TB_Subtitle_Order_IdCoverExam] FOREIGN KEY ([IdCoverExam]) REFERENCES [dbo].[TR_CoverExam] ([IdCoverExam])
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [FK_TB_Subtitle_Order_IdSubtitle_Subtitle] FOREIGN KEY ([IdSubtitle_Subtitle]) REFERENCES [dbo].[TB_Subtitle] ([IdSubtitle])
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [FK_TB_Subtitle_Order_IdSubtitle_Title] FOREIGN KEY ([IdSubtitle_Title]) REFERENCES [dbo].[TB_Subtitle] ([IdSubtitle])
GO
ALTER TABLE [dbo].[TR_Subtitle_Order] ADD CONSTRAINT [FK_TR_Subtitle_Order_IdCover] FOREIGN KEY ([IdCover]) REFERENCES [dbo].[TB_Cover] ([IdCover])
GO
