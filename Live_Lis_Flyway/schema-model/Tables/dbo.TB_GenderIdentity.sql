CREATE TABLE [dbo].[TB_GenderIdentity]
(
[IdGenderIdentity] [tinyint] NOT NULL IDENTITY(1, 1),
[GenderIdentityCode] [varchar] (3) NOT NULL,
[GenderIdentity] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_GenderIdentity] ADD CONSTRAINT [PK_TB_GenderIdentity] PRIMARY KEY CLUSTERED ([IdGenderIdentity])
GO
