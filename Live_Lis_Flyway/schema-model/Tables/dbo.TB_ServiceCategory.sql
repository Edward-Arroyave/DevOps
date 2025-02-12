CREATE TABLE [dbo].[TB_ServiceCategory]
(
[IdServiceCategory] [int] NOT NULL IDENTITY(1, 1),
[ServiceCategoryCode] [varchar] (10) NOT NULL,
[ServiceCategory] [varchar] (100) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceCategory] ADD CONSTRAINT [PK_TB_ServiceCategory] PRIMARY KEY CLUSTERED ([IdServiceCategory])
GO
ALTER TABLE [dbo].[TB_ServiceCategory] ADD CONSTRAINT [FK_TB_ServiceCategory_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
