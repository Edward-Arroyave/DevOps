CREATE TABLE [PTO].[TB_TypesOfColorations]
(
[IdTypesOfColorations] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_TypesO__Visib__53591940] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_TypesOfColorations] ADD CONSTRAINT [PK_TB_TYPESOFCOLORATIONS] PRIMARY KEY CLUSTERED ([IdTypesOfColorations])
GO
ALTER TABLE [PTO].[TB_TypesOfColorations] ADD CONSTRAINT [FK_TB_TypesOfColorations_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
