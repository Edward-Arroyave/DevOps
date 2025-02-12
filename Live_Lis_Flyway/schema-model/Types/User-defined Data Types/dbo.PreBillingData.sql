CREATE TYPE [dbo].[PreBillingData] AS TABLE
(
[InitialDate] [datetime] NULL,
[FinalDate] [datetime] NULL,
[IdBillingOfSale] [int] NOT NULL,
[Number] [int] NOT NULL,
[NumberContract] [varchar] (100) NULL,
[NumberOrder] [varchar] (100) NULL
)
GO
