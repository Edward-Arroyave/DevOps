CREATE TABLE [dbo].[TB_ContainerType]
(
[IdContainerType] [tinyint] NOT NULL IDENTITY(1, 1),
[ContainerTypeName] [varchar] (40) NOT NULL,
[Color] [varchar] (15) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ContainerType] ADD CONSTRAINT [PK_TB_ContainerType] PRIMARY KEY CLUSTERED ([IdContainerType])
GO
ALTER TABLE [dbo].[TB_ContainerType] ADD CONSTRAINT [FK_TB_ContainerType_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
