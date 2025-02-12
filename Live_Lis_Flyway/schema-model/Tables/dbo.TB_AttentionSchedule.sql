CREATE TABLE [dbo].[TB_AttentionSchedule]
(
[IdAttentionSchedule] [int] NOT NULL IDENTITY(1, 1),
[IdAttentionCenter] [smallint] NOT NULL,
[StartTime] [varchar] (10) NOT NULL,
[EndTime] [varchar] (10) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TB_Attent__Activ__4D362B96] DEFAULT ((1)),
[IdUser] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TB_Attent__Creat__4E2A4FCF] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserUpdate] [int] NULL,
[Days] [varchar] (200) NULL
)
GO
ALTER TABLE [dbo].[TB_AttentionSchedule] ADD CONSTRAINT [PK__TB_Atten__DF76A27854BADF0C] PRIMARY KEY CLUSTERED ([IdAttentionSchedule])
GO
ALTER TABLE [dbo].[TB_AttentionSchedule] ADD CONSTRAINT [FK_TB_AttentionSchedule_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TB_AttentionSchedule] ADD CONSTRAINT [FK_TB_AttentionSchedule_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_AttentionSchedule] ADD CONSTRAINT [FK_TB_AttentionSchedule_TB_UserUpdate] FOREIGN KEY ([IdUserUpdate]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
