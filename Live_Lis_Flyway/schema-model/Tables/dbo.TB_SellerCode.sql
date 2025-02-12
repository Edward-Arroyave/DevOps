CREATE TABLE [dbo].[TB_SellerCode]
(
[IdSellerCode] [int] NOT NULL IDENTITY(1, 1),
[SellerCode] [varchar] (25) NOT NULL,
[Advisory] [varchar] (50) NULL,
[IdUser] [int] NULL,
[IdUserAction] [int] NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_SellerCode] ADD CONSTRAINT [PK_TB_SellerCode] PRIMARY KEY CLUSTERED ([IdSellerCode])
GO
ALTER TABLE [dbo].[TB_SellerCode] ADD CONSTRAINT [FK_TB_SellerCode_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_SellerCode] ADD CONSTRAINT [FK_TB_SellerCode_TB_User_Action] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
