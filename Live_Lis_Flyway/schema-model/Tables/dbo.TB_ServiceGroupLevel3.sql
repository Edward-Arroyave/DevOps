CREATE TABLE [dbo].[TB_ServiceGroupLevel3]
(
[IdServiceGroupLevel3] [int] NOT NULL IDENTITY(1, 1),
[ServiceGroupLevel3Code] [varchar] (10) NOT NULL,
[ServiceGroupLevel3Name] [varchar] (500) NOT NULL,
[IdServiceGroupLevel2] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceGroupLevel3] ADD CONSTRAINT [PK_TB_ServiceGroupLevel3] PRIMARY KEY CLUSTERED ([IdServiceGroupLevel3])
GO
ALTER TABLE [dbo].[TB_ServiceGroupLevel3] ADD CONSTRAINT [FK_TB_ServiceGroupLevel3_TB_ServiceGroupLevel2] FOREIGN KEY ([IdServiceGroupLevel2]) REFERENCES [dbo].[TB_ServiceGroupLevel2] ([IdServiceGroupLevel2])
GO
ALTER TABLE [dbo].[TB_ServiceGroupLevel3] ADD CONSTRAINT [FK_TB_ServiceGroupLevel3_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
