CREATE TYPE [dbo].[User_Menu] AS TABLE
(
[IdUser] [int] NULL,
[IdMenu] [int] NULL,
[ToRead] [bit] NULL,
[ToCreate] [bit] NULL,
[ToUpdate] [bit] NULL,
[IdUserAction] [int] NULL
)
GO
