CREATE TABLE [dbo].[TB_ContractException]
(
[IdContractException] [int] NOT NULL IDENTITY(1, 1),
[IdContract] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NOT NULL,
[IdExam] [int] NULL,
[IdService] [int] NULL,
[IdExamGroup] [int] NULL,
[ValueException] [decimal] (20, 2) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ContractException] ADD CONSTRAINT [PK_TB_ContractException] PRIMARY KEY CLUSTERED ([IdContractException])
GO
CREATE NONCLUSTERED INDEX [Active_IdContract_IdExamGroup] ON [dbo].[TB_ContractException] ([Active], [IdContract], [IdExamGroup]) INCLUDE ([IdExam], [ValueException])
GO
ALTER TABLE [dbo].[TB_ContractException] ADD CONSTRAINT [FK_TB_ContractException_TB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TB_ContractException] ADD CONSTRAINT [FK_TB_ContractException_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
