CREATE TABLE [dbo].[TB_DetailBillingResolution_Tmp]
(
[IdDetailBillingResolution] [int] NOT NULL,
[IdBillingResolution] [int] NULL,
[DetailName] [varchar] (50) NULL,
[Prefix] [varchar] (10) NULL,
[PrefixCN] [varchar] (10) NULL,
[Consecutive] [int] NULL,
[InitialNumber] [int] NULL,
[FinalNumber] [int] NULL,
[InitialDate] [datetime] NULL,
[FinalDate] [datetime] NULL,
[EconomicActivity] [varchar] (100) NULL,
[ResolutionText] [varchar] (255) NULL,
[Status] [bit] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DetailBillingResolution_Tmp] ADD CONSTRAINT [PK_TB_DetailBillingResolution_Tmp] PRIMARY KEY CLUSTERED ([IdDetailBillingResolution])
GO
