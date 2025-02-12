CREATE TABLE [dbo].[TB_ContractDeadline]
(
[IdContractDeadline] [tinyint] NOT NULL IDENTITY(1, 1),
[ContractDeadline] [varchar] (10) NOT NULL,
[OdooPaymentTerm] [varchar] (15) NULL
)
GO
ALTER TABLE [dbo].[TB_ContractDeadline] ADD CONSTRAINT [PK_TB_ContractDeadline] PRIMARY KEY CLUSTERED ([IdContractDeadline])
GO
