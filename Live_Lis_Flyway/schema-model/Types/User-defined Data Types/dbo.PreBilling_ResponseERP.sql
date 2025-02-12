CREATE TYPE [dbo].[PreBilling_ResponseERP] AS TABLE
(
[IdPrebilling] [int] NULL,
[Transaction_id] [varchar] (100) NOT NULL,
[Async_id] [int] NOT NULL,
[Async_state] [varchar] (50) NOT NULL
)
GO
