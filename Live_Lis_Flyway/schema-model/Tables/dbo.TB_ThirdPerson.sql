CREATE TABLE [dbo].[TB_ThirdPerson]
(
[IdThirdPerson] [int] NOT NULL IDENTITY(1, 1),
[IdTypeOfPerson] [tinyint] NOT NULL,
[IdIdentificationType] [tinyint] NOT NULL,
[IdentificationNumber] [varchar] (20) NOT NULL,
[VerificationDigit] [varchar] (1) NULL,
[Name] [varchar] (255) NOT NULL,
[LastName] [varchar] (255) NULL,
[Address] [varchar] (100) NOT NULL,
[IdCountry] [int] NULL,
[IdCity] [int] NULL,
[TelephoneNumber] [varchar] (15) NOT NULL,
[Email] [varchar] (100) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ThirdPerson] ADD CONSTRAINT [PK_TB_ThirdPerson] PRIMARY KEY CLUSTERED ([IdThirdPerson])
GO
ALTER TABLE [dbo].[TB_ThirdPerson] ADD CONSTRAINT [FK_TB_ThirdPerson_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_ThirdPerson] ADD CONSTRAINT [FK_TB_ThirdPerson_TB_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
ALTER TABLE [dbo].[TB_ThirdPerson] ADD CONSTRAINT [FK_TB_ThirdPerson_TB_IdentificationType] FOREIGN KEY ([IdIdentificationType]) REFERENCES [dbo].[TB_IdentificationType] ([IdIdentificationType])
GO
ALTER TABLE [dbo].[TB_ThirdPerson] ADD CONSTRAINT [FK_TB_ThirdPerson_TB_TypeOfPerson] FOREIGN KEY ([IdTypeOfPerson]) REFERENCES [dbo].[TB_TypeOfPerson] ([IdTypeOfPerson])
GO
ALTER TABLE [dbo].[TB_ThirdPerson] ADD CONSTRAINT [FK_TB_ThirdPerson_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
