CREATE TABLE [dbo].[TB_EconomicActivity]
(
[IdEconomicActivity] [smallint] NOT NULL IDENTITY(1, 1),
[EconomicActivityCode] [varchar] (5) NOT NULL,
[EconomicActivityName] [varchar] (180) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_EconomicActivity] ADD CONSTRAINT [PK_TB_EconomicActivity] PRIMARY KEY CLUSTERED ([IdEconomicActivity])
GO
ALTER TABLE [dbo].[TB_EconomicActivity] ADD CONSTRAINT [FK_TB_EconomicActivity_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
