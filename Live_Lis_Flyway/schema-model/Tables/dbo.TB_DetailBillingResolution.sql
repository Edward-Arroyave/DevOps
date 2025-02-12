CREATE TABLE [dbo].[TB_DetailBillingResolution]
(
[IdDetailBillingResolution] [int] NOT NULL IDENTITY(1, 1),
[IdBillingResolution] [int] NOT NULL,
[DetailName] [varchar] (50) NOT NULL,
[Prefix] [varchar] (10) NOT NULL,
[PrefixCN] [varchar] (10) NULL,
[Consecutive] [int] NOT NULL,
[InitialNumber] [int] NOT NULL,
[FinalNumber] [int] NOT NULL,
[InitialDate] [datetime] NOT NULL,
[FinalDate] [datetime] NOT NULL,
[IdEconomicActivity] [smallint] NOT NULL,
[ResolutionText] [varchar] (255) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DetailBillingResolution] ADD CONSTRAINT [PK_TB_DetailBillingResolution] PRIMARY KEY CLUSTERED ([IdDetailBillingResolution])
GO
ALTER TABLE [dbo].[TB_DetailBillingResolution] ADD CONSTRAINT [FK_TB_DetailBillingResolution_TB_BillingResolution] FOREIGN KEY ([IdBillingResolution]) REFERENCES [dbo].[TB_BillingResolution] ([IdBillingResolution])
GO
ALTER TABLE [dbo].[TB_DetailBillingResolution] ADD CONSTRAINT [FK_TB_DetailBillingResolution_TB_EconomicActivity] FOREIGN KEY ([IdEconomicActivity]) REFERENCES [dbo].[TB_EconomicActivity] ([IdEconomicActivity])
GO
ALTER TABLE [dbo].[TB_DetailBillingResolution] ADD CONSTRAINT [FK_TB_DetailBillingResolution_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_DetailBillingResolution] ADD CONSTRAINT [FK_TB_DetailBillingResolution_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
