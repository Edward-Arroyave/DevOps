CREATE TYPE [dbo].[DetailBillingResolution] AS TABLE
(
[IdDetailBillingResolution] [int] NULL,
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
[IdUserAction] [int] NULL
)
GO
