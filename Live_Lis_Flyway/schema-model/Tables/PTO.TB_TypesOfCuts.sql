CREATE TABLE [PTO].[TB_TypesOfCuts]
(
[IdTypesOfCuts] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_TypesO__Visib__5729AA24] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_TypesOfCuts] ADD CONSTRAINT [PK_TB_TYPESOFCUTS] PRIMARY KEY CLUSTERED ([IdTypesOfCuts])
GO
ALTER TABLE [PTO].[TB_TypesOfCuts] ADD CONSTRAINT [FK_TB_TypesOfCuts_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
