CREATE TYPE [dbo].[Role_Menu] AS TABLE
(
[IdRole] [int] NULL,
[IdMenu] [int] NULL,
[ToRead] [bit] NULL,
[ToCreate] [bit] NULL,
[ToUpdate] [bit] NULL,
[IdUserAction] [int] NULL
)
GO
