CREATE TABLE [TYL].[TB_RouteFridge]
(
[IdRouteFridge] [int] NOT NULL IDENTITY(1, 1),
[StarOfRoute] [datetime] NULL,
[EndOfRoute] [datetime] NULL,
[IdUserRoute] [int] NULL,
[CodeRoute] [varchar] (20) NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [TYL].[TB_RouteFridge] ADD CONSTRAINT [PK__TB_Route__696C8D8CFBB20E60] PRIMARY KEY CLUSTERED ([IdRouteFridge])
GO
ALTER TABLE [TYL].[TB_RouteFridge] ADD CONSTRAINT [TB_Fridge_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
