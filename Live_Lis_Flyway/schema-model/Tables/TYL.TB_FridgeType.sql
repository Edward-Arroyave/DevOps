CREATE TABLE [TYL].[TB_FridgeType]
(
[IdFridgeType] [int] NOT NULL IDENTITY(1, 1),
[FridgeName] [varchar] (20) NULL
)
GO
ALTER TABLE [TYL].[TB_FridgeType] ADD CONSTRAINT [PK__TB_Fridg__B9600D44849498DB] PRIMARY KEY CLUSTERED ([IdFridgeType])
GO
