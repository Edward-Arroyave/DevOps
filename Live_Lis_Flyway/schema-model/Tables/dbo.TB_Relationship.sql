CREATE TABLE [dbo].[TB_Relationship]
(
[IdRelationship] [tinyint] NOT NULL IDENTITY(1, 1),
[Relationship] [varchar] (25) NOT NULL,
[Paternity] [bit] NOT NULL,
[PersonInCharge] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Relationship] ADD CONSTRAINT [PK_TB_Relationship] PRIMARY KEY CLUSTERED ([IdRelationship])
GO
