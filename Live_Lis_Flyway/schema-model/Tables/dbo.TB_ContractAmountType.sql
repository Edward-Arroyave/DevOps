CREATE TABLE [dbo].[TB_ContractAmountType]
(
[IdContractAmountType] [tinyint] NOT NULL IDENTITY(1, 1),
[ContractAmountType] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ContractAmountType] ADD CONSTRAINT [PK_TB_ContractAmountType] PRIMARY KEY CLUSTERED ([IdContractAmountType])
GO
