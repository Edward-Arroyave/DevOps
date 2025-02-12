CREATE TABLE [dbo].[TR_User_Contract]
(
[IdUser_Contract] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[WaitingResult] [bit] NOT NULL,
[PartialResult] [bit] NOT NULL,
[FinishedResult] [bit] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TR_User_Contract_Active] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TR_User_Contract] ADD CONSTRAINT [PK_TR_User_Contract] PRIMARY KEY CLUSTERED ([IdUser_Contract])
GO
ALTER TABLE [dbo].[TR_User_Contract] ADD CONSTRAINT [FK_TR_User_Contract_TB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TR_User_Contract] ADD CONSTRAINT [FK_TR_User_Contract_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
