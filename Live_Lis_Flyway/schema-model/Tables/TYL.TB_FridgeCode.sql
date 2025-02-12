CREATE TABLE [TYL].[TB_FridgeCode]
(
[IdFridgeCode] [int] NOT NULL IDENTITY(1, 1),
[LabelCode] [varchar] (20) NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__TB_Fridge__Creat__7D3A4473] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NULL CONSTRAINT [DF__TB_Fridge__Activ__7E2E68AC] DEFAULT ((0))
)
GO
ALTER TABLE [TYL].[TB_FridgeCode] ADD CONSTRAINT [PK__TB_Fridg__9AEE64E70882D6C6] PRIMARY KEY CLUSTERED ([IdFridgeCode])
GO
