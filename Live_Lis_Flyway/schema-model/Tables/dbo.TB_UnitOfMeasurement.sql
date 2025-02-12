CREATE TABLE [dbo].[TB_UnitOfMeasurement]
(
[IdUnitOfMeasurement] [tinyint] NOT NULL IDENTITY(1, 1),
[UnitOfMeasurement] [varchar] (30) NOT NULL,
[Active] [bit] NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_UnitOfMeasurement] ADD CONSTRAINT [PK_TB_UnitOfMeasurement] PRIMARY KEY CLUSTERED ([IdUnitOfMeasurement])
GO
ALTER TABLE [dbo].[TB_UnitOfMeasurement] ADD CONSTRAINT [FK_TB_UnitOfMeasurement_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
