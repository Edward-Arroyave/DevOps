CREATE TABLE [dbo].[TB_TypeOfProcedure]
(
[IdTypeOfProcedure] [tinyint] NOT NULL IDENTITY(1, 1),
[TypeOfProcedure] [varchar] (50) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TypeOfProcedure] ADD CONSTRAINT [PK_TB_TypeOfProcedure] PRIMARY KEY CLUSTERED ([IdTypeOfProcedure])
GO
ALTER TABLE [dbo].[TB_TypeOfProcedure] ADD CONSTRAINT [FK_TB_TypeOfProcedure_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
