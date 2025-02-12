CREATE TABLE [dbo].[TB_ContractType]
(
[IdContractType] [tinyint] NOT NULL IDENTITY(1, 1),
[ContractType] [varchar] (40) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ContractType] ADD CONSTRAINT [PK_TB_ContractType] PRIMARY KEY CLUSTERED ([IdContractType])
GO
