CREATE TABLE [dbo].[TB_CommercialHouses]
(
[IdCommercialHouses] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TB_Commer__Activ__06A3B31C] DEFAULT ((1)),
[UpdateDate] [datetime] NULL,
[IdCreationUser] [int] NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_CommercialHouses] ADD CONSTRAINT [PK__TB_Comme__7DEB30F98FE2F342] PRIMARY KEY CLUSTERED ([IdCommercialHouses])
GO
ALTER TABLE [dbo].[TB_CommercialHouses] ADD CONSTRAINT [FK_TB_CommercialHouses_TB_User] FOREIGN KEY ([IdCreationUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_CommercialHouses] ADD CONSTRAINT [FK_TB_CommercialHouses_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
