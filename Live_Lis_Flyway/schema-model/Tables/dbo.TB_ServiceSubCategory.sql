CREATE TABLE [dbo].[TB_ServiceSubCategory]
(
[IdServiceSubCategory] [int] NOT NULL IDENTITY(1, 1),
[ServiceSubCategoryCode] [varchar] (10) NOT NULL,
[ServiceSubCategory] [varchar] (100) NOT NULL,
[IdServiceCategory] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceSubCategory] ADD CONSTRAINT [PK_TB_ServiceSubCategory] PRIMARY KEY CLUSTERED ([IdServiceSubCategory])
GO
ALTER TABLE [dbo].[TB_ServiceSubCategory] ADD CONSTRAINT [FK_TB_ServiceSubCategory_TB_ServiceCategory] FOREIGN KEY ([IdServiceCategory]) REFERENCES [dbo].[TB_ServiceCategory] ([IdServiceCategory])
GO
ALTER TABLE [dbo].[TB_ServiceSubCategory] ADD CONSTRAINT [FK_TB_ServiceSubCategory_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
