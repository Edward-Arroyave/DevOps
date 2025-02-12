CREATE TABLE [dbo].[TB_Reactive]
(
[IdReactive] [tinyint] NOT NULL IDENTITY(1, 1),
[Reactive] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[ReferenceCode] [varchar] (20) NULL
)
GO
ALTER TABLE [dbo].[TB_Reactive] ADD CONSTRAINT [PK_TB_Reactive] PRIMARY KEY CLUSTERED ([IdReactive])
GO
CREATE NONCLUSTERED INDEX [IDX_Reactive] ON [dbo].[TB_Reactive] ([IdReactive], [Active])
GO
ALTER TABLE [dbo].[TB_Reactive] ADD CONSTRAINT [FK_TB_Reactive_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
