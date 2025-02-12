CREATE TABLE [dbo].[TB_ServiceGroup]
(
[IdServiceGroup] [int] NOT NULL IDENTITY(1, 1),
[ServiceGroupCode] [varchar] (10) NOT NULL,
[ServiceGroupName] [varchar] (500) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceGroup] ADD CONSTRAINT [PK_TB_ServiceGroup] PRIMARY KEY CLUSTERED ([IdServiceGroup])
GO
ALTER TABLE [dbo].[TB_ServiceGroup] ADD CONSTRAINT [FK_TB_ServiceGroup_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
