CREATE TABLE [dbo].[TB_ServiceGroupLevel2]
(
[IdServiceGroupLevel2] [int] NOT NULL IDENTITY(1, 1),
[ServiceGroupLevel2Code] [varchar] (3) NOT NULL,
[ServiceGroupLevel2Name] [varchar] (800) NOT NULL,
[IdServiceGroup] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceGroupLevel2] ADD CONSTRAINT [PK_TB_ServiceGroupLevel2] PRIMARY KEY CLUSTERED ([IdServiceGroupLevel2])
GO
ALTER TABLE [dbo].[TB_ServiceGroupLevel2] ADD CONSTRAINT [FK_TB_ServiceGroupLevel2_TB_ServiceGroup] FOREIGN KEY ([IdServiceGroup]) REFERENCES [dbo].[TB_ServiceGroup] ([IdServiceGroup])
GO
ALTER TABLE [dbo].[TB_ServiceGroupLevel2] ADD CONSTRAINT [FK_TB_ServiceGroupLevel2_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
