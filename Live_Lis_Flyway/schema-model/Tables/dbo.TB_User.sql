CREATE TABLE [dbo].[TB_User]
(
[IdUser] [int] NOT NULL IDENTITY(1, 1),
[IdIdentificationType] [tinyint] NOT NULL,
[IdentificationNumber] [varchar] (20) NOT NULL,
[Name] [varchar] (60) NOT NULL,
[LastName] [varchar] (60) NOT NULL,
[BirthDate] [date] NULL,
[IdCountry] [int] NULL,
[IdCity] [int] NULL,
[TelephoneNumber] [varchar] (20) NOT NULL,
[Email] [varchar] (100) NOT NULL,
[IdRole] [tinyint] NULL,
[UserName] [varchar] (50) NULL,
[Password] [varchar] (120) NOT NULL,
[PasswordExpires] [bit] NULL,
[IdPasswdRenewalPeriod] [tinyint] NULL,
[PasswordExpirationDate] [date] NULL,
[AccountExpires] [bit] NULL,
[ExpirationDate] [date] NULL,
[RegistrationNumber] [varchar] (20) NULL,
[IdProfession] [smallint] NULL,
[IdEntailmentType] [tinyint] NULL,
[SessionDate] [datetime] NULL,
[EncryptedUserDate] [datetime] NULL,
[EncryptedUser] [varchar] (500) NULL,
[PhotoNameContainer] [varchar] (150) NULL,
[SignatureNameContainer] [varchar] (150) NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[Active] [bit] NOT NULL,
[AccessResultWeb] [bit] NULL,
[CompanyUser] [bit] NULL,
[IdCompany] [int] NULL,
[Removed] [bit] NULL CONSTRAINT [DF_User_Removed] DEFAULT ((0)),
[blocking] [bit] NULL,
[Attempts] [smallint] NULL CONSTRAINT [DF__TB_User__Attempt__2E91A8E5] DEFAULT ((0)),
[LockDate] [datetime] NULL,
[Time] [smallint] NULL CONSTRAINT [DF__TB_User__Time__2F85CD1E] DEFAULT ((0)),
[UserNameAlternative] [varchar] (50) NULL,
[PasswordLocked] [bit] NULL CONSTRAINT [DF__TB_User__Passwor__2280D7BB] DEFAULT ((0)),
[AlliedDoctor] [bit] NULL CONSTRAINT [DF__TB_User__AlliedD__233FF1CA] DEFAULT ((0)),
[ActiveAlliedDoctor] [bit] NULL CONSTRAINT [DF__TB_User__ActiveA__3282355A] DEFAULT ((1)),
[IdInstitution] [int] NULL,
[AccessTreasuryLogistics] [bit] NULL CONSTRAINT [DF__TB_User__AccessT__61081A19] DEFAULT ((0)),
[AccessMobileTreasuryLogistics] [bit] NULL,
[AccessWebTreasuryLogistics] [bit] NULL,
[LastAccessWebTreasuryLogistics] [datetime] NULL,
[LastAccessMobileTreasuryLogistics] [datetime] NULL,
[IdSpecialty] [tinyint] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Permission_User]
   ON [dbo].[TB_User]
   AFTER INSERT,DELETE,UPDATE
AS 
	DECLARE @IdUser int, @IdUserAction int
BEGIN
	SET NOCOUNT ON;
	
	IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
		BEGIN
			SET @IdUser = (SELECT IdUser FROM inserted)
			SET @IdUserAction = (SELECT IdUserAction FROM inserted)

			--- Asignación de permisos del rol al usuario.
			EXEC [sp_Assign_Permissions_User] @IdUser, @IdUserAction
		END
	ELSE IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
		BEGIN
			IF UPDATE (IdRole)
				BEGIN
					IF (SELECT IdRole FROM deleted) != (SELECT IdRole FROM inserted)
						BEGIN
							SET @IdUser = (SELECT IdUser FROM inserted)
							SET @IdUserAction = (SELECT IdUserAction FROM inserted)

							--- Asignación de permisos del rol al usuario.
							EXEC [sp_Assign_Permissions_User] @IdUser, @IdUserAction
						END
				END		
		END

END
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [PK_TB_User] PRIMARY KEY CLUSTERED ([IdUser])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_EntailmentType] FOREIGN KEY ([IdEntailmentType]) REFERENCES [dbo].[TB_EntailmentType] ([IdEntailmentType])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_IdentificationType] FOREIGN KEY ([IdIdentificationType]) REFERENCES [dbo].[TB_IdentificationType] ([IdIdentificationType])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_PasswdRenewalPeriod] FOREIGN KEY ([IdPasswdRenewalPeriod]) REFERENCES [dbo].[TB_PasswdRenewalPeriod] ([IdPasswdRenewalPeriod])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_Profession] FOREIGN KEY ([IdProfession]) REFERENCES [dbo].[TB_Profession] ([IdProfession])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_Role] FOREIGN KEY ([IdRole]) REFERENCES [dbo].[TB_Role] ([IdRole])
GO
ALTER TABLE [dbo].[TB_User] ADD CONSTRAINT [FK_TB_User_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
