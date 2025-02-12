CREATE TABLE [dbo].[TB_ERPResponse]
(
[IdERPResponse] [tinyint] NOT NULL IDENTITY(1, 1),
[ERPResponse] [varchar] (15) NOT NULL,
[IdTransactionStatus] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ERPResponse] ADD CONSTRAINT [PK_TB_ERPResponse] PRIMARY KEY CLUSTERED ([IdERPResponse])
GO
