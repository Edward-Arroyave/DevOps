CREATE TABLE [dbo].[TR_CommercialHouse_Reactive]
(
[IdCommercialHouse_Reactive] [int] NOT NULL IDENTITY(1, 1),
[IdCommercialHouse] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TR_Commer__Activ__0B686839] DEFAULT ((1)),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_CommercialHouse_Reactive] ADD CONSTRAINT [PK__TR_Comme__753FC3F1D226B5D2] PRIMARY KEY CLUSTERED ([IdCommercialHouse_Reactive])
GO
ALTER TABLE [dbo].[TR_CommercialHouse_Reactive] ADD CONSTRAINT [FK_TR_CommercialHouse_Reactive_TB_CommercialHouses] FOREIGN KEY ([IdCommercialHouse]) REFERENCES [dbo].[TB_CommercialHouses] ([IdCommercialHouses])
GO
ALTER TABLE [dbo].[TR_CommercialHouse_Reactive] ADD CONSTRAINT [FK_TR_CommercialHouse_Reactive_TB_Reactive] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [dbo].[TR_CommercialHouse_Reactive] ADD CONSTRAINT [FK_TR_CommercialHouse_Reactive_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
