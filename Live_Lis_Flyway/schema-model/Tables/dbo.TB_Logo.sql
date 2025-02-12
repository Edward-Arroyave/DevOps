CREATE TABLE [dbo].[TB_Logo]
(
[IdLogo] [int] NOT NULL IDENTITY(1, 1),
[IdCompany] [int] NOT NULL,
[Url] [varchar] (max) NULL,
[OriginalName] [varchar] (255) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUser] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Logo] ADD CONSTRAINT [PK__TB_Logo__38DA338646229892] PRIMARY KEY CLUSTERED ([IdLogo])
GO
ALTER TABLE [dbo].[TB_Logo] ADD CONSTRAINT [TB_Logo_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_Logo] ADD CONSTRAINT [TB_Logo_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
