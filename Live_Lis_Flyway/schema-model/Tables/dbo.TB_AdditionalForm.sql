CREATE TABLE [dbo].[TB_AdditionalForm]
(
[IdAdditionalForm] [int] NOT NULL IDENTITY(1, 1),
[IdAdditionalFormType] [tinyint] NOT NULL,
[AdditionalForm] [varchar] (100) NOT NULL,
[IdCompany] [int] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AdditionalForm] ADD CONSTRAINT [PK_TB_AdditionalForm] PRIMARY KEY CLUSTERED ([IdAdditionalForm])
GO
ALTER TABLE [dbo].[TB_AdditionalForm] ADD CONSTRAINT [FK_TB_AdditionalForm_TB_AdditionalFormType] FOREIGN KEY ([IdAdditionalFormType]) REFERENCES [dbo].[TB_AdditionalFormType] ([IdAdditionalFormType])
GO
ALTER TABLE [dbo].[TB_AdditionalForm] ADD CONSTRAINT [FK_TB_AdditionalForm_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_AdditionalForm] ADD CONSTRAINT [FK_TB_AdditionalForm_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
