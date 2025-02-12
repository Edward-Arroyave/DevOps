CREATE TABLE [dbo].[TB_UserSignature]
(
[IdSignature] [int] NOT NULL IDENTITY(1, 1),
[SignatureCode] [varchar] (25) NOT NULL,
[SignatureName] [varchar] (100) NULL,
[IdUser] [int] NOT NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_UserSignature] ADD CONSTRAINT [PK_TB_Signature] PRIMARY KEY CLUSTERED ([IdSignature])
GO
ALTER TABLE [dbo].[TB_UserSignature] ADD CONSTRAINT [FK_TB_UserSignature_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_UserSignature] ADD CONSTRAINT [FK_TB_UserSignature_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
