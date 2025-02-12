CREATE TABLE [INTER].[ValidatedUsers]
(
[IdValidatedUsers] [int] NOT NULL IDENTITY(1, 1),
[IdMedicalDevice] [int] NOT NULL,
[IdUser] [int] NOT NULL,
[UserHomologation] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[ValidatedInterface] [bit] NULL
)
GO
ALTER TABLE [INTER].[ValidatedUsers] ADD CONSTRAINT [PK__Validate__EDECCE8A612732CB] PRIMARY KEY CLUSTERED ([IdValidatedUsers])
GO
ALTER TABLE [INTER].[ValidatedUsers] ADD CONSTRAINT [FK_MedicalDevice_INTER_ValidatedUsers] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[ValidatedUsers] ADD CONSTRAINT [FK_User_INTER_ValidatedUsers] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
