CREATE TABLE [dbo].[TB_PersonInCharge]
(
[IdPersonInCharge] [int] NOT NULL IDENTITY(1, 1),
[IdIdentificationType] [tinyint] NOT NULL,
[IdentificationNumber] [varchar] (20) NOT NULL,
[FullName] [varchar] (255) NOT NULL,
[IdRelationship] [tinyint] NULL,
[IdCity] [int] NULL,
[Address] [varchar] (100) NOT NULL,
[TelephoneNumber] [varchar] (15) NOT NULL,
[Email] [varchar] (100) NOT NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_PersonInCharge] ADD CONSTRAINT [PK_TB_PersonInCharge] PRIMARY KEY CLUSTERED ([IdPersonInCharge])
GO
ALTER TABLE [dbo].[TB_PersonInCharge] ADD CONSTRAINT [FK_TB_PersonInCharge_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_PersonInCharge] ADD CONSTRAINT [FK_TB_PersonInCharge_TB_IdentificationType] FOREIGN KEY ([IdIdentificationType]) REFERENCES [dbo].[TB_IdentificationType] ([IdIdentificationType])
GO
ALTER TABLE [dbo].[TB_PersonInCharge] ADD CONSTRAINT [FK_TB_PersonInCharge_TB_Relationship] FOREIGN KEY ([IdRelationship]) REFERENCES [dbo].[TB_Relationship] ([IdRelationship])
GO
ALTER TABLE [dbo].[TB_PersonInCharge] ADD CONSTRAINT [FK_TB_PersonInCharge_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
