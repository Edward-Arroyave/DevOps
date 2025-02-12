CREATE TABLE [PTO].[TB_BodyPart]
(
[IdBodyPart] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) NOT NULL,
[BlockQuantity] [int] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_BodyPa__Visib__4DA03FEA] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_BodyPart] ADD CONSTRAINT [PK_TB_BODYPART] PRIMARY KEY CLUSTERED ([IdBodyPart])
GO
ALTER TABLE [PTO].[TB_BodyPart] ADD CONSTRAINT [FK_TB_BodyPart_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
