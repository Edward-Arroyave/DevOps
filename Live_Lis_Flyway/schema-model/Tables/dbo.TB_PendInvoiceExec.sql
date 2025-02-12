CREATE TABLE [dbo].[TB_PendInvoiceExec]
(
[IdPendInvoiceExec] [int] NOT NULL IDENTITY(1, 1),
[PendInvoiceExecDate] [datetime] NOT NULL,
[PendInvoiceExecStatus] [varchar] (10) NOT NULL,
[Description] [varchar] (max) NOT NULL,
[DataSent] [varchar] (max) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PendInvoiceExec] ADD CONSTRAINT [PK_TB_PendInvoiceExec] PRIMARY KEY CLUSTERED ([IdPendInvoiceExec])
GO
