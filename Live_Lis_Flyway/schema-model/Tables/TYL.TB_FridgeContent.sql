CREATE TABLE [TYL].[TB_FridgeContent]
(
[IdFridgeContent] [int] NOT NULL IDENTITY(1, 1),
[IdRouteFridge] [int] NOT NULL,
[IdFridgeType] [int] NOT NULL,
[IdFridgeCode] [int] NULL,
[InitialTemperature] [decimal] (4, 2) NULL,
[IntermediateTemperature] [decimal] (4, 2) NULL,
[FinalTemperature] [decimal] (4, 2) NULL,
[DateInitialTemperature] [datetime] NULL,
[DateInitermediateTemperature] [datetime] NULL,
[DateFinalTemperature] [datetime] NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[Active] [bit] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [TYL].[TB_FridgeContent] ADD CONSTRAINT [PK__TB_Fridg__D6C9DA646A08AD54] PRIMARY KEY CLUSTERED ([IdFridgeContent])
GO
ALTER TABLE [TYL].[TB_FridgeContent] ADD CONSTRAINT [TB_FridgeContent_TB_fridge] FOREIGN KEY ([IdRouteFridge]) REFERENCES [TYL].[TB_RouteFridge] ([IdRouteFridge])
GO
ALTER TABLE [TYL].[TB_FridgeContent] ADD CONSTRAINT [TB_FridgeContent_TB_FridgeType] FOREIGN KEY ([IdFridgeType]) REFERENCES [TYL].[TB_FridgeType] ([IdFridgeType])
GO
ALTER TABLE [TYL].[TB_FridgeContent] ADD CONSTRAINT [TB_FridgeContent_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
