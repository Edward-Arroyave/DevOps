CREATE TABLE [POSANT].[TB_BoardPostAnalitic]
(
[IdBoardPostAnalitic] [int] NOT NULL IDENTITY(1, 1),
[BoardName] [varchar] (50) NOT NULL,
[WorkSpace] [varchar] (200) NOT NULL,
[BoardToken] [varchar] (max) NOT NULL,
[UserRole] [varchar] (20) NOT NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[Active] [bit] NOT NULL,
[BoardCode] [varchar] (10) NULL
)
GO
ALTER TABLE [POSANT].[TB_BoardPostAnalitic] ADD CONSTRAINT [PK__TB_Board__5FD3082189A0AF80] PRIMARY KEY CLUSTERED ([IdBoardPostAnalitic])
GO
ALTER TABLE [POSANT].[TB_BoardPostAnalitic] ADD CONSTRAINT [FK__TB_BoardP__IdUse__7CC54327] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
